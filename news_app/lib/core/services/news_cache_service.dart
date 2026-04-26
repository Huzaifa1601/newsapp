import 'dart:convert';

import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../features/news/domain/entities/news_article.dart';

class NewsCacheService {
  static const _articlesBoxName = 'cached_articles';
  static const _bookmarksBoxName = 'bookmarked_articles';

  late Box<String> _articlesBox;
  late Box<String> _bookmarksBox;

  Future<void> init() async {
    await Hive.initFlutter();
    _articlesBox = await Hive.openBox<String>(_articlesBoxName);
    _bookmarksBox = await Hive.openBox<String>(_bookmarksBoxName);
  }

  Future<void> cacheArticles(Iterable<NewsArticle> articles) async {
    for (final article in articles) {
      await _articlesBox.put(article.id, jsonEncode(article.toJson()));
    }
  }

  Future<void> saveBookmark(NewsArticle article) async {
    await _bookmarksBox.put(article.id, jsonEncode(article.toJson()));
  }

  Future<void> removeBookmark(String articleId) async {
    await _bookmarksBox.delete(articleId);
  }

  bool isBookmarked(String articleId) => _bookmarksBox.containsKey(articleId);

  List<NewsArticle> getBookmarks() {
    return _bookmarksBox.values
        .map(
          (item) =>
              NewsArticle.fromJson(jsonDecode(item) as Map<String, dynamic>),
        )
        .toList()
      ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
  }

  NewsArticle? getCachedArticle(String articleId) {
    final raw = _articlesBox.get(articleId) ?? _bookmarksBox.get(articleId);
    if (raw == null) {
      return null;
    }
    return NewsArticle.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  List<NewsArticle> getAllCachedArticles() {
    final merged = <String, NewsArticle>{};
    for (final raw in _articlesBox.values) {
      final article = NewsArticle.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
      merged[article.id] = article;
    }
    for (final raw in _bookmarksBox.values) {
      final article = NewsArticle.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
      merged[article.id] = article;
    }
    return merged.values.toList()
      ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
  }
}
