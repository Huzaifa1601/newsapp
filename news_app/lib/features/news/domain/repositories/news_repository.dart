import '../entities/news_article.dart';

abstract class NewsRepository {
  Future<HomeFeed> fetchHome({
    required String category,
    required int page,
    required int pageSize,
    required List<String> preferredCategories,
  });

  Future<List<NewsArticle>> search({
    required String query,
    required String category,
    required String sortBy,
    required String dateRange,
  });

  Future<List<String>> suggestions(String query);
  Future<NewsArticle> getArticle(String articleId);
  Future<List<NewsArticle>> getRelatedArticles(NewsArticle article);
  Future<List<NewsArticle>> getBookmarks();
  Future<void> toggleBookmark(NewsArticle article);
  bool isBookmarked(String articleId);
  Future<List<NewsArticle>> getReadingHistory();
  Future<void> recordArticleOpened(NewsArticle article);
  Future<void> likeArticle(NewsArticle article);
}
