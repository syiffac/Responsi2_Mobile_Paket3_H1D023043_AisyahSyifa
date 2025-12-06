import 'package:flutter/foundation.dart';
import '../models/book.dart';
import '../services/book_service.dart';

enum BookStatus { initial, loading, loaded, error, adding, updating, deleting }

class BookBloc extends ChangeNotifier {
  BookStatus _status = BookStatus.initial;
  List<Book> _books = [];
  Book? _selectedBook;
  String? _errorMessage;
  String? _successMessage;

  BookStatus get status => _status;
  List<Book> get books => _books;
  Book? get selectedBook => _selectedBook;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  bool get isLoading => _status == BookStatus.loading;

  Future<void> getBooks() async {
    _status = BookStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await BookService.getBooks();

    if (result['success']) {
      _books = result['data'] as List<Book>;
      _status = BookStatus.loaded;
    } else {
      _errorMessage = result['message'];
      _status = BookStatus.error;
    }

    notifyListeners();
  }

  Future<void> getBookById(int id) async {
    _status = BookStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await BookService.getBookById(id);

    if (result['success']) {
      _selectedBook = result['data'] as Book;
      _status = BookStatus.loaded;
    } else {
      _errorMessage = result['message'];
      _status = BookStatus.error;
    }

    notifyListeners();
  }

  Future<bool> createBook(Book book) async {
    _status = BookStatus.adding;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    final result = await BookService.createBook(book);

    if (result['success']) {
      _successMessage = result['message'];
      _status = BookStatus.loaded;
      await getBooks();
      return true;
    } else {
      _errorMessage = result['message'];
      _status = BookStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateBook(int id, Book book) async {
    _status = BookStatus.updating;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    final result = await BookService.updateBook(id, book);

    if (result['success']) {
      _successMessage = result['message'];
      _status = BookStatus.loaded;
      final index = _books.indexWhere((b) => b.id == id);
      if (index != -1) {
        _books[index] = book.copyWith(id: id);
      }
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      _status = BookStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteBook(int id) async {
    _status = BookStatus.deleting;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    final result = await BookService.deleteBook(id);

    if (result['success']) {
      _successMessage = result['message'];
      _books.removeWhere((book) => book.id == id);
      _status = BookStatus.loaded;
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      _status = BookStatus.error;
      notifyListeners();
      return false;
    }
  }

  void setSelectedBook(Book? book) {
    _selectedBook = book;
    notifyListeners();
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    if (_status == BookStatus.error) {
      _status = BookStatus.loaded;
    }
    notifyListeners();
  }

  List<Book> searchBooks(String query) {
    if (query.isEmpty) return _books;
    final lowerQuery = query.toLowerCase();
    return _books.where((book) {
      return book.judul.toLowerCase().contains(lowerQuery) ||
          book.penulis.toLowerCase().contains(lowerQuery) ||
          book.penerbit.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
