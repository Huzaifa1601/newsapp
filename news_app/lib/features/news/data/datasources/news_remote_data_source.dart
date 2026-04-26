import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/news_article.dart';

class NewsRemoteDataSource {
  NewsRemoteDataSource({required http.Client client, String? baseUrl})
    : _client = client,
      _baseUrl = baseUrl ?? AppConstants.defaultBackendUrl;

  final http.Client _client;
  final String _baseUrl;

  Future<HomeFeed> fetchHome({
    required String category,
    required int page,
    required int pageSize,
    required List<String> preferredCategories,
  }) async {
    final uri = Uri.parse('$_baseUrl/news/home').replace(
      queryParameters: {
        'category': category,
        'page': '$page',
        'pageSize': '$pageSize',
        if (preferredCategories.isNotEmpty)
          'interests': preferredCategories.join(','),
      },
    );

    final response = await _client.get(uri).timeout(const Duration(seconds: 6));
    _ensureSuccess(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return HomeFeed.fromJson(json);
  }

  Future<List<NewsArticle>> search({
    required String query,
    required String category,
    required String sortBy,
    required String dateRange,
  }) async {
    final uri = Uri.parse('$_baseUrl/news/search').replace(
      queryParameters: {
        'query': query,
        'category': category,
        'sortBy': sortBy,
        'dateRange': dateRange,
      },
    );

    final response = await _client.get(uri).timeout(const Duration(seconds: 6));
    _ensureSuccess(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final data = json['data'] as List<dynamic>? ?? const [];
    return data
        .map((item) => NewsArticle.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<NewsArticle> getArticle(String articleId) async {
    final response = await _client
        .get(Uri.parse('$_baseUrl/news/$articleId'))
        .timeout(const Duration(seconds: 6));
    _ensureSuccess(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final payload = json['data'] as Map<String, dynamic>? ?? json;
    return NewsArticle.fromJson(payload);
  }

  Future<void> trackInteraction({
    required String articleId,
    required String type,
  }) async {
    final uri = Uri.parse('$_baseUrl/news/$articleId/interactions');
    await _client.post(
      uri,
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({'type': type}),
    );
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode >= 400) {
      throw Exception('Backend request failed with ${response.statusCode}.');
    }
  }
}
