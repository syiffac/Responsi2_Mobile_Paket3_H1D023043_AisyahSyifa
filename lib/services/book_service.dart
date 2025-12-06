import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../models/book.dart';
import 'auth_service.dart';

class BookService {
  // Get headers with token
  static Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Get all books
  static Future<Map<String, dynamic>> getBooks() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.booksEndpoint}'),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        List<Book> books = [];
        if (data['data'] != null) {
          books = (data['data'] as List)
              .map((book) => Book.fromJson(book))
              .toList();
        } else if (data is List) {
          books = data.map((book) => Book.fromJson(book)).toList();
        }

        return {'success': true, 'data': books};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal mengambil data buku',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // Get book by ID
  static Future<Map<String, dynamic>> getBookById(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.booksEndpoint}/$id'),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Book book;
        if (data['data'] != null) {
          book = Book.fromJson(data['data']);
        } else {
          book = Book.fromJson(data);
        }

        return {'success': true, 'data': book};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal mengambil detail buku',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // Create book
  static Future<Map<String, dynamic>> createBook(Book book) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.booksEndpoint}'),
        headers: headers,
        body: jsonEncode(book.toJson()),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'Buku berhasil ditambahkan',
          'data': data['data'] != null ? Book.fromJson(data['data']) : null,
        };
      } else {
        return {
          'success': false,
          'message':
              data['message'] ??
              data['messages']?['error'] ??
              'Gagal menambahkan buku',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // Update book
  static Future<Map<String, dynamic>> updateBook(int id, Book book) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.booksEndpoint}/$id'),
        headers: headers,
        body: jsonEncode(book.toJson()),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Buku berhasil diperbarui',
          'data': data['data'] != null ? Book.fromJson(data['data']) : null,
        };
      } else {
        return {
          'success': false,
          'message':
              data['message'] ??
              data['messages']?['error'] ??
              'Gagal memperbarui buku',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // Delete book
  static Future<Map<String, dynamic>> deleteBook(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.booksEndpoint}/$id'),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Buku berhasil dihapus',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal menghapus buku',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }
}
