import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String _keyToken = 'user_token';
  static const String _keyFirstName = 'user_firstname';
  static const String _keyLastName = 'user_lastname';
  static const String _keyUsername = 'user_username';
  static const String _keyPhoto = 'user_photo';
  static const String _keyEmail = 'user_email';

  static Future<void> saveUserInfo({
    required String token,
    required String firstname,
    required String lastname,
    required String username,
    required String photo,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyFirstName, firstname);
    await prefs.setString(_keyLastName, lastname);
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyPhoto, photo);
    await prefs.setString(_keyEmail, email);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  static Future<String?> getFirstName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyFirstName);
  }

  static Future<String?> getLastName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastName);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  static Future<String?> getPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPhoto);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  static Future<void> clearUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyFirstName);
    await prefs.remove(_keyLastName);
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyPhoto);
    await prefs.remove(_keyEmail);
  }
}