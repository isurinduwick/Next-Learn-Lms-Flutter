import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<bool> login(String email, String password) async {
    // Check for hard-coded credentials
    if (email == 'isu@gmail.com' && password == '1234567') {
      // Save dummy user info to shared preferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', 'dummy_token');
      prefs.setString('user',
          jsonEncode({'name': 'Test User', 'email': email, 'role': 'student'}));
      return true;
    }
    return false;
  }

  static Future<bool> register(
    String fullName,
    String email,
    String password,
    String role,
  ) async {
    // Always return success for now
    return true;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }
}
