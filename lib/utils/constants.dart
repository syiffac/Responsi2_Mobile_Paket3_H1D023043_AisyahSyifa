import 'package:flutter/material.dart';

class AppConstants {
  // API Base URL
  // Ganti dengan IP lokal kamu jika run di emulator/device fisik
  // Untuk Chrome: bisa pakai localhost
  // Untuk Emulator/Device: pakai IP lokal (cek dengan ipconfig)
  static const String baseUrl = 'http://10.45.98.208:8080';

  // API Endpoints
  static const String registerEndpoint = '/register';
  static const String loginEndpoint = '/login';
  static const String logoutEndpoint = '/logout';
  static const String booksEndpoint = '/books';

  // App Name
  static const String appName = 'Inventaris Buku Syiffac';

  // Shared Preferences Keys
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String userNameKey = 'user_name';
  static const String userEmailKey = 'user_email';
}

class AppColors {
  // Vintage Retro Colors
  static const Color primary = Color(0xFF8B4513); // Saddle Brown
  static const Color primaryLight = Color(0xFFCD853F); // Peru
  static const Color primaryDark = Color(0xFF654321); // Dark Brown

  // Accent Colors - Vintage Gold & Cream
  static const Color accent = Color(0xFFD4AF37); // Gold
  static const Color accentLight = Color(0xFFF5DEB3); // Wheat
  static const Color gold = Color(0xFFD4AF37); // Gold
  static const Color burgundy = Color(0xFF722F37); // Burgundy
  static const Color olive = Color(0xFF556B2F); // Dark Olive Green

  // Background Colors - Vintage Paper
  static const Color background = Color(0xFFFAF0E6); // Linen
  static const Color cardBackground = Color(0xFFFFFAF0); // Floral White
  static const Color surface = Color(0xFFF5F5DC); // Beige

  // Text Colors
  static const Color textPrimary = Color(0xFF2F1810); // Dark Espresso
  static const Color textSecondary = Color(0xFF5D4E37); // Coffee
  static const Color textLight = Color(0xFFFFFAF0);

  // Vintage Decorative Colors
  static const Color vintage1 = Color(0xFF8B7355); // Burly Wood Dark
  static const Color vintage2 = Color(0xFFBC8F8F); // Rosy Brown
  static const Color vintage3 = Color(0xFFDEB887); // Burlywood

  // Other Colors
  static const Color error = Color(0xFF8B0000); // Dark Red (vintage)
  static const Color success = Color(0xFF2E8B57); // Sea Green (vintage)
  static const Color divider = Color(0xFFD2B48C); // Tan
}
