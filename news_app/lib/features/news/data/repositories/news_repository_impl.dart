import 'dart:math';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/app_preferences.dart';
import '../../../../core/services/news_cache_service.dart';
import '../../domain/entities/news_article.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_data_source.dart';
import '../sample/sample_news.dart';

class NewsRepositoryImpl implements NewsRepository {
  NewsRepositoryImpl({
    required NewsRemoteDataSource remoteDataSource,
    required NewsCacheService cacheService,
    required AppPreferences preferences,
  }) : _remoteDataSource = remoteDataSource,
       _cacheService = cacheService,
       _preferences = preferences;

  final NewsRemoteDataSource _remoteDataSource;
  final NewsCacheService _cacheService;
  final AppPreferences _preferences;

  @override
  Future<HomeFeed> fetchHome({
    required String category,
    required int page,
    required int pageSize,
    required List<String> preferredCategories,
  }) async {
    try {
      final result = await _remoteDataSource.fetchHome(
        category: category,
        page: page,
        pageSize: pageSize,
        preferredCategories: preferredCategories,
      );
      await _cacheService.cacheArticles([
        ...result.breakingNews,
        ...result.trendingNews,
        ...result.personalizedNews,
        ...result.feed,
      ]);
      return result;
    } catch (_) {
      return _buildFallbackFeed(
        category: category,
        page: page,
        pageSize: pageSize,
        preferredCategories: preferredCategories,
      );
    }
  }

  @override
  Future<List<NewsArticle>> search({
    required String query,
    required String category,
    required String sortBy,
    required String dateRange,
  }) async {
    if (query.trim().isEmpty) {
      return const [];
    }

    try {
      final result = await _remoteDataSource.search(
        query: query,
        category: category,
        sortBy: sortBy,
        dateRange: dateRange,
      );
      await _cacheService.cacheArticles(result);
      return result;
    } catch (_) {
      return _searchFallback(
        query: query,
        category: category,
        sortBy: sortBy,
        dateRange: dateRange,
      );
    }
  }

  @override
  Future<List<String>> suggestions(String query) async {
    final lower = query.toLowerCase();
    if (lower.isEmpty) {
      return _preferences.searchHistory.take(5).toList();
    }

    final history = _preferences.searchHistory.where(
      (item) => item.toLowerCase().contains(lower),
    );
    final titles = sampleArticles
        .where((article) => article.title.toLowerCase().contains(lower))
        .map((article) => article.title);
    final tags = sampleArticles
        .expand((article) => article.tags)
        .where((tag) => tag.toLowerCase().contains(lower));

    return {...history, ...titles, ...tags}.take(8).toList();
  }

  @override
  Future<NewsArticle> getArticle(String articleId) async {
    try {
      final article = await _remoteDataSource.getArticle(articleId);
      await _cacheService.cacheArticles([article]);
      return article;
    } catch (_) {
      return _cacheService.getCachedArticle(articleId) ??
          sampleArticles.firstWhere((article) => article.id == articleId);
    }
  }

  @override
  Future<List<NewsArticle>> getRelatedArticles(NewsArticle article) async {
    return sampleArticles
        .where(
          (candidate) =>
              candidate.id != article.id &&
              candidate.category == article.category,
        )
        .take(3)
        .toList();
  }

  @override
  Future<List<NewsArticle>> getBookmarks() async {
    return _cacheService.getBookmarks();
  }

  @override
  Future<void> toggleBookmark(NewsArticle article) async {
    if (_cacheService.isBookmarked(article.id)) {
      await _cacheService.removeBookmark(article.id);
    } else {
      await _cacheService.saveBookmark(article);
    }
  }

  @override
  bool isBookmarked(String articleId) => _cacheService.isBookmarked(articleId);

  @override
  Future<List<NewsArticle>> getReadingHistory() async {
    final ids = _preferences.readingHistory;
    final allArticles = [
      ...sampleArticles,
      ..._cacheService.getAllCachedArticles(),
    ];
    final mapped = <String, NewsArticle>{};
    for (final article in allArticles) {
      mapped[article.id] = article;
    }
    return ids.map((id) => mapped[id]).whereType<NewsArticle>().toList();
  }

  @override
  Future<void> recordArticleOpened(NewsArticle article) async {
    await _preferences.recordArticleInteraction(article);
    await _cacheService.cacheArticles([article]);
    try {
      await _remoteDataSource.trackInteraction(
        articleId: article.id,
        type: 'open',
      );
    } catch (_) {}
  }

  @override
  Future<void> likeArticle(NewsArticle article) async {
    try {
      await _remoteDataSource.trackInteraction(
        articleId: article.id,
        type: 'like',
      );
    } catch (_) {}
  }

  HomeFeed _buildFallbackFeed({
    required String category,
    required int page,
    required int pageSize,
    required List<String> preferredCategories,
  }) {
    final base = category == 'all'
        ? sampleArticles
        : sampleArticles
              .where((article) => article.category == category)
              .toList();

    final sortedByDate = [...base]
      ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    final sortedByPopularity = [...sampleArticles]
      ..sort((a, b) => (b.views + b.likes).compareTo(a.views + a.likes));

    final interests = preferredCategories.isEmpty
        ? AppConstants.defaultPreferredCategories
        : preferredCategories;

    final personalized = [...sampleArticles]
      ..sort((a, b) {
        final aScore = _interestScore(a, interests);
        final bScore = _interestScore(b, interests);
        return bScore.compareTo(aScore);
      });

    final start = max(0, (page - 1) * pageSize);
    final end = min(start + pageSize, sortedByDate.length);
    final feed = start >= sortedByDate.length
        ? <NewsArticle>[]
        : sortedByDate.sublist(start, end);

    return HomeFeed(
      categories: sampleCategories,
      breakingNews: sampleArticles
          .where((article) => article.isBreaking)
          .take(4)
          .toList(),
      trendingNews: sortedByPopularity.take(5).toList(),
      personalizedNews: personalized.take(5).toList(),
      feed: feed,
      hasMore: end < sortedByDate.length,
      nextPage: page + 1,
    );
  }

  List<NewsArticle> _searchFallback({
    required String query,
    required String category,
    required String sortBy,
    required String dateRange,
  }) {
    final lower = query.toLowerCase();
    final now = DateTime.now();

    bool matchesDate(NewsArticle article) {
      return switch (dateRange) {
        'today' => article.publishedAt.isAfter(
          now.subtract(const Duration(days: 1)),
        ),
        'week' => article.publishedAt.isAfter(
          now.subtract(const Duration(days: 7)),
        ),
        'month' => article.publishedAt.isAfter(
          now.subtract(const Duration(days: 30)),
        ),
        _ => true,
      };
    }

    final filtered = sampleArticles.where((article) {
      final inCategory = category == 'all' || article.category == category;
      final matchesQuery =
          article.title.toLowerCase().contains(lower) ||
          article.summary.toLowerCase().contains(lower) ||
          article.tags.any((tag) => tag.toLowerCase().contains(lower));
      return inCategory && matchesQuery && matchesDate(article);
    }).toList();

    filtered.sort((a, b) {
      if (sortBy == 'popular') {
        return (b.views + b.likes).compareTo(a.views + a.likes);
      }
      return b.publishedAt.compareTo(a.publishedAt);
    });

    return filtered;
  }

  int _interestScore(NewsArticle article, List<String> interests) {
    final preferenceWeight = interests.contains(article.category) ? 1000 : 0;
    final behaviorWeight = _preferences.categoryScores[article.category] ?? 0;
    final popularityWeight = article.views + article.likes;
    return preferenceWeight + (behaviorWeight * 10) + popularityWeight;
  }
}
