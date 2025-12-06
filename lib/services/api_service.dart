import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import 'auth_service.dart';

class ApiService {
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Base headers
  static Future<Map<String, String>> _getHeaders({bool withAuth = true}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (withAuth) {
      final token = await AuthService.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // ==================== GET REQUEST ====================
  static Future<ApiResponse> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    bool withAuth = true,
  }) async {
    try {
      final uri = Uri.parse('${AppConstants.baseUrl}$endpoint').replace(
        queryParameters: queryParams?.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );

      final headers = await _getHeaders(withAuth: withAuth);
      final response = await http.get(uri, headers: headers);

      return _handleResponse(response);
    } on SocketException {
      return ApiResponse(
        success: false,
        message: 'Tidak ada koneksi internet',
        statusCode: 0,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Terjadi kesalahan: $e',
        statusCode: 0,
      );
    }
  }

  // ==================== POST REQUEST ====================
  static Future<ApiResponse> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool withAuth = true,
  }) async {
    try {
      final uri = Uri.parse('${AppConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(withAuth: withAuth);

      final response = await http.post(
        uri,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );

      return _handleResponse(response);
    } on SocketException {
      return ApiResponse(
        success: false,
        message: 'Tidak ada koneksi internet',
        statusCode: 0,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Terjadi kesalahan: $e',
        statusCode: 0,
      );
    }
  }

  // ==================== PUT REQUEST ====================
  static Future<ApiResponse> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool withAuth = true,
  }) async {
    try {
      final uri = Uri.parse('${AppConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(withAuth: withAuth);

      final response = await http.put(
        uri,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );

      return _handleResponse(response);
    } on SocketException {
      return ApiResponse(
        success: false,
        message: 'Tidak ada koneksi internet',
        statusCode: 0,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Terjadi kesalahan: $e',
        statusCode: 0,
      );
    }
  }

  // ==================== DELETE REQUEST ====================
  static Future<ApiResponse> delete(
    String endpoint, {
    bool withAuth = true,
  }) async {
    try {
      final uri = Uri.parse('${AppConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(withAuth: withAuth);

      final response = await http.delete(uri, headers: headers);

      return _handleResponse(response);
    } on SocketException {
      return ApiResponse(
        success: false,
        message: 'Tidak ada koneksi internet',
        statusCode: 0,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Terjadi kesalahan: $e',
        statusCode: 0,
      );
    }
  }

  // ==================== HANDLE RESPONSE ====================
  static ApiResponse _handleResponse(http.Response response) {
    dynamic data;
    String? message;

    try {
      data = jsonDecode(response.body);
      if (data is Map<String, dynamic>) {
        message = data['message'] ?? data['messages']?['error'];
      }
    } catch (e) {
      data = response.body;
    }

    final isSuccess = response.statusCode >= 200 && response.statusCode < 300;

    return ApiResponse(
      success: isSuccess,
      data: data,
      message: message ?? (isSuccess ? 'Berhasil' : 'Gagal'),
      statusCode: response.statusCode,
    );
  }
}

// ==================== API RESPONSE MODEL ====================
class ApiResponse {
  final bool success;
  final dynamic data;
  final String message;
  final int statusCode;

  ApiResponse({
    required this.success,
    this.data,
    required this.message,
    required this.statusCode,
  });

  @override
  String toString() {
    return 'ApiResponse(success: $success, message: $message, statusCode: $statusCode)';
  }
}
