/// API Endpoints untuk Inventaris Buku Abimart
/// Base URL: http://localhost/book_inventory/public
class ApiEndpoints {
  // ==================== AUTH ENDPOINTS ====================
  /// POST /register - Registrasi member baru
  /// Body: { name, email, password }
  static const String register = '/register';

  /// POST /login - Login, dapat token
  /// Body: { email, password }
  /// Response: { token, user }
  static const String login = '/login';

  /// POST /logout - Logout
  /// Header: Authorization: Bearer {token}
  static const String logout = '/logout';

  // ==================== BOOK ENDPOINTS ====================
  /// GET /books - List semua buku
  /// Header: Authorization: Bearer {token}
  /// Response: { data: [...] }
  static const String books = '/books';

  /// POST /books - Tambah buku baru
  /// Header: Authorization: Bearer {token}
  /// Body: { judul, harga, jumlah, tanggal_masuk, volume, penulis, penerbit }
  static const String createBook = '/books';

  /// GET /books/{id} - Detail buku
  /// Header: Authorization: Bearer {token}
  static String getBookById(int id) => '/books/$id';

  /// PUT /books/{id} - Update buku
  /// Header: Authorization: Bearer {token}
  /// Body: { judul, harga, jumlah, tanggal_masuk, volume, penulis, penerbit }
  static String updateBook(int id) => '/books/$id';

  /// DELETE /books/{id} - Hapus buku
  /// Header: Authorization: Bearer {token}
  static String deleteBook(int id) => '/books/$id';
}

/// HTTP Methods yang tersedia
class HttpMethod {
  static const String get = 'GET';
  static const String post = 'POST';
  static const String put = 'PUT';
  static const String delete = 'DELETE';
  static const String patch = 'PATCH';
}

/// HTTP Status Codes
class HttpStatusCode {
  static const int ok = 200;
  static const int created = 201;
  static const int noContent = 204;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int unprocessableEntity = 422;
  static const int internalServerError = 500;

  static bool isSuccess(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  static bool isClientError(int statusCode) {
    return statusCode >= 400 && statusCode < 500;
  }

  static bool isServerError(int statusCode) {
    return statusCode >= 500;
  }
}
