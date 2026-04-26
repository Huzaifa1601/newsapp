import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/app_constants.dart';
import '../../../news/domain/entities/news_article.dart';
import '../../domain/entities/author_session.dart';

class AuthorRemoteDataSource {
  AuthorRemoteDataSource({required http.Client client, String? baseUrl})
    : _client = client,
      _baseUrl = baseUrl ?? AppConstants.defaultBackendUrl;

  final http.Client _client;
  final String _baseUrl;

  Future<AuthorSession> register({
    required String name,
    required String email,
    required String password,
    String bio = '',
  }) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/auth/author/register'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'bio': bio,
      }),
    );

    return _parseSession(response);
  }

  Future<AuthorSession> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/auth/author/login'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    return _parseSession(response);
  }

  Future<NewsArticle> publishArticle({
    required String token,
    required Map<String, dynamic> payload,
  }) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/admin/news'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(payload),
    );

    _ensureSuccess(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return NewsArticle.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<List<NewsArticle>> fetchMyArticles(String token) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/admin/author/news'),
      headers: {'Authorization': 'Bearer $token'},
    );

    _ensureSuccess(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final data = json['data'] as List<dynamic>? ?? const [];
    return data
        .map((item) => NewsArticle.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  AuthorSession _parseSession(http.Response response) {
    _ensureSuccess(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final data = json['data'] as Map<String, dynamic>;
    final user = data['user'] as Map<String, dynamic>;

    return AuthorSession(
      token: data['token'] as String,
      name: user['name'] as String,
      email: user['email'] as String,
      bio: user['bio'] as String? ?? '',
    );
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode >= 400) {
      try {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(json['message'] ?? 'Request failed.');
      } catch (_) {
        throw Exception('Request failed with ${response.statusCode}.');
      }
    }
  }
}
