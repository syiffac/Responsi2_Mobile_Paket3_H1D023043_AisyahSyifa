import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import '../models/user.dart';

class AuthService {
  // Register
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final url = '${AppConstants.baseUrl}${AppConstants.registerEndpoint}';
      final requestBody = jsonEncode({
        'nama': name,
        'email': email,
        'password': password,
      });

      // Debug logging
      print('=== REGISTER REQUEST ===');
      print('URL: $url');
      print('Body: $requestBody');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: requestBody,
      );

      // Debug response
      print('=== REGISTER RESPONSE ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'Registrasi berhasil',
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message':
              data['message'] ??
              data['messages']?['error'] ??
              'Registrasi gagal',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // Login
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = '${AppConstants.baseUrl}${AppConstants.loginEndpoint}';
      final requestBody = jsonEncode({'email': email, 'password': password});

      // Debug logging
      print('=== LOGIN REQUEST ===');
      print('URL: $url');
      print('Body: $requestBody');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: requestBody,
      );

      // Debug response
      print('=== LOGIN RESPONSE ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Save token and user data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.tokenKey, data['token'] ?? '');

        if (data['user'] != null) {
          // Handle id yang bisa berupa String atau int
          var userId = data['user']['id'];
          if (userId is String) {
            userId = int.tryParse(userId) ?? 0;
          }
          await prefs.setInt(AppConstants.userIdKey, userId ?? 0);
          await prefs.setString(
            AppConstants.userNameKey,
            data['user']['nama']?.toString() ??
                data['user']['name']?.toString() ??
                '',
          );
          await prefs.setString(
            AppConstants.userEmailKey,
            data['user']['email']?.toString() ?? '',
          );
        }

        return {
          'success': true,
          'message': data['message'] ?? 'Login berhasil',
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message':
              data['message'] ?? data['messages']?['error'] ?? 'Login gagal',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // Logout
  static Future<Map<String, dynamic>> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.tokenKey) ?? '';

      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.logoutEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // Clear local data regardless of response
      await prefs.remove(AppConstants.tokenKey);
      await prefs.remove(AppConstants.userIdKey);
      await prefs.remove(AppConstants.userNameKey);
      await prefs.remove(AppConstants.userEmailKey);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Logout berhasil',
        };
      } else {
        return {'success': true, 'message': 'Logout berhasil'};
      }
    } catch (e) {
      // Still clear local data on error
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.tokenKey);
      await prefs.remove(AppConstants.userIdKey);
      await prefs.remove(AppConstants.userNameKey);
      await prefs.remove(AppConstants.userEmailKey);

      return {'success': true, 'message': 'Logout berhasil'};
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.tokenKey);
    return token != null && token.isNotEmpty;
  }

  // Get current user
  static Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.tokenKey);

    if (token == null || token.isEmpty) {
      return null;
    }

    return User(
      id: prefs.getInt(AppConstants.userIdKey),
      name: prefs.getString(AppConstants.userNameKey) ?? '',
      email: prefs.getString(AppConstants.userEmailKey) ?? '',
      token: token,
    );
  }

  // Get token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.tokenKey);
  }
}
