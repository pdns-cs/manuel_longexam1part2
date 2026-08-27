import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/user.dart';

/// Handles authentication against https://dummyjson.com/auth and persists the
/// authenticated user (plus token) locally with shared_preferences.
class UserService {
  static const _kToken = 'auth_token';
  static const _kRefreshToken = 'auth_refresh_token';
  static const _kUser = 'auth_user';

  /// POST /auth/login — returns the [User] on success, throws on failure.
  Future<User> login({
    required String username,
    required String password,
  }) async {
    final http.Response response;
    try {
      response = await http
          .post(
            Uri.parse('$host/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'username': username.trim(),
              'password': password,
              'expiresInMins': 60,
            }),
          )
          .timeout(const Duration(seconds: 15));
    } catch (_) {
      throw Exception('No connection. Check your internet and try again.');
    }

    if (response.statusCode != 200) {
      String message = 'Invalid username or password.';
      try {
        message = jsonDecode(response.body)['message'] ?? message;
      } catch (_) {}
      throw Exception(message);
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final user = User.fromJson(data);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kToken, data['accessToken']?.toString() ?? '');
    await prefs.setString(
      _kRefreshToken,
      data['refreshToken']?.toString() ?? '',
    );
    await prefs.setString(_kUser, jsonEncode(user.toJson()));

    return user;
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_kToken);
    return token != null && token.isNotEmpty;
  }

  /// The user saved at login time (no network call).
  Future<User?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kUser);
    if (raw == null || raw.isEmpty) return null;
    try {
      return User.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kToken);
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kToken);
    await prefs.remove(_kRefreshToken);
    await prefs.remove(_kUser);
  }
}
