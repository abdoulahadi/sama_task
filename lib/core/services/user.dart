import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sama_task/core/constants/app_strings.dart';
import 'package:sama_task/data/models/user.dart';

class UserService {
  static const String _baseUrl = '${AppStrings.baseApiUrl}auths';

  final _client = http.Client();

  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/login'),
      body: jsonEncode(request.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    return _handleResponse(response, AuthResponse.fromJson);
  }

  Future<User> register(RegisterRequest request) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/register'),
      body: jsonEncode(request.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    return _handleResponse(response, User.fromJson);
  }

  Future<User> getProfile(String token) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/profils'),
      headers: _authHeader(token),
    );
    return _handleResponse(response, User.fromJson);
  }

  Future<User> updateProfile(String token, UpdateUserRequest request) async {
    final response = await _client.put(
      Uri.parse('$_baseUrl/profils'),
      body: jsonEncode(request.toJson()),
      headers: _authHeader(token),
    );
    return _handleResponse(response, User.fromJson);
  }

  Future<AuthResponse> refreshToken(String refreshToken) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/refresh'),
      headers: _authHeader(refreshToken),
    );
    return _handleResponse(response, AuthResponse.fromJson);
  }

  Map<String, String> _authHeader(String token) => {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  T _handleResponse<T>(http.Response response, T Function(Map<String, dynamic>) converter) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return converter(jsonDecode(response.body));
    } else {
      throw Exception('Erreur ${response.statusCode}: ${response.body}');
    }
  }
}