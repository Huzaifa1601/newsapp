import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/news/domain/entities/news_article.dart';

class AppPreferences {
  static const _onboardingSeenKey = 'onboarding_seen';
  static const _themeModeKey = 'theme_mode';
  static const _localeCodeKey = 'locale_code';
  static const _preferredCategoriesKey = 'preferred_categories';
  static const _searchHistoryKey = 'search_history';
  static const _readingHistoryKey = 'reading_history';
  static const _categoryScoresKey = 'category_scores';
  static const _authorTokenKey = 'author_token';
  static const _authorNameKey = 'author_name';
  static const _authorEmailKey = 'author_email';
  static const _authorBioKey = 'author_bio';

  late SharedPreferences _preferences;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  bool get isOnboardingSeen =>
      _preferences.getBool(_onboardingSeenKey) ?? false;

  Future<void> setOnboardingSeen() async {
    await _preferences.setBool(_onboardingSeenKey, true);
  }

  ThemeMode get themeMode {
    final value = _preferences.getString(_themeModeKey);
    return switch (value) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => ThemeMode.system,
    };
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    final value = switch (mode) {
      ThemeMode.dark => 'dark',
      ThemeMode.light => 'light',
      ThemeMode.system => 'system',
    };
    await _preferences.setString(_themeModeKey, value);
  }

  String get localeCode => _preferences.getString(_localeCodeKey) ?? 'en';

  Future<void> saveLocaleCode(String localeCode) async {
    await _preferences.setString(_localeCodeKey, localeCode);
  }

  List<String> get preferredCategories =>
      _preferences.getStringList(_preferredCategoriesKey) ?? const [];

  Future<void> savePreferredCategories(List<String> categories) async {
    await _preferences.setStringList(_preferredCategoriesKey, categories);
  }

  List<String> get searchHistory =>
      _preferences.getStringList(_searchHistoryKey) ?? const [];

  Future<void> addSearchHistory(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return;
    }

    final history = searchHistory.toList()
      ..remove(trimmed)
      ..insert(0, trimmed);
    await _preferences.setStringList(
      _searchHistoryKey,
      history.take(10).toList(),
    );
  }

  Future<void> clearSearchHistory() async {
    await _preferences.remove(_searchHistoryKey);
  }

  List<String> get readingHistory =>
      _preferences.getStringList(_readingHistoryKey) ?? const [];

  Future<void> recordReadingHistory(String articleId) async {
    final history = readingHistory.toList()
      ..remove(articleId)
      ..insert(0, articleId);
    await _preferences.setStringList(
      _readingHistoryKey,
      history.take(20).toList(),
    );
  }

  Map<String, int> get categoryScores {
    final raw = _preferences.getString(_categoryScoresKey);
    if (raw == null || raw.isEmpty) {
      return <String, int>{};
    }

    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map((key, value) => MapEntry(key, (value as num).toInt()));
  }

  Future<void> recordArticleInteraction(NewsArticle article) async {
    final scores = categoryScores;
    scores.update(article.category, (value) => value + 1, ifAbsent: () => 1);
    await _preferences.setString(_categoryScoresKey, jsonEncode(scores));
    await recordReadingHistory(article.id);
  }

  String? get authorToken => _preferences.getString(_authorTokenKey);
  String? get authorName => _preferences.getString(_authorNameKey);
  String? get authorEmail => _preferences.getString(_authorEmailKey);
  String get authorBio => _preferences.getString(_authorBioKey) ?? '';

  Future<void> saveAuthorSession({
    required String token,
    required String name,
    required String email,
    String bio = '',
  }) async {
    await _preferences.setString(_authorTokenKey, token);
    await _preferences.setString(_authorNameKey, name);
    await _preferences.setString(_authorEmailKey, email);
    await _preferences.setString(_authorBioKey, bio);
  }

  Future<void> clearAuthorSession() async {
    await _preferences.remove(_authorTokenKey);
    await _preferences.remove(_authorNameKey);
    await _preferences.remove(_authorEmailKey);
    await _preferences.remove(_authorBioKey);
  }
}
