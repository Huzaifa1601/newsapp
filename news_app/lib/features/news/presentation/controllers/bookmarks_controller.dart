import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../domain/entities/news_article.dart';
import '../../domain/repositories/news_repository.dart';
import 'news_providers.dart';

class BookmarksController extends StateNotifier<List<NewsArticle>> {
  BookmarksController(this._repository) : super(const []) {
    load();
  }

  final NewsRepository _repository;

  Future<void> load() async {
    state = await _repository.getBookmarks();
  }

  Future<void> toggle(NewsArticle article) async {
    await _repository.toggleBookmark(article);
    await load();
  }

  bool contains(String articleId) {
    return state.any((article) => article.id == articleId);
  }
}

final bookmarksControllerProvider =
    StateNotifierProvider<BookmarksController, List<NewsArticle>>((ref) {
      return BookmarksController(ref.read(newsRepositoryProvider));
    });

final readingHistoryProvider = FutureProvider<List<NewsArticle>>((ref) {
  return ref.read(newsRepositoryProvider).getReadingHistory();
});
