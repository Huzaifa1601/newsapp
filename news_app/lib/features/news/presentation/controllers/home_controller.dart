import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../settings/presentation/controllers/settings_controller.dart';
import '../../domain/entities/news_article.dart';
import '../../domain/repositories/news_repository.dart';
import 'news_providers.dart';

class HomeState {
  const HomeState({
    this.categories = const [],
    this.breakingNews = const [],
    this.trendingNews = const [],
    this.personalizedNews = const [],
    this.feed = const [],
    this.selectedCategory = 'all',
    this.nextPage = 1,
    this.hasMore = true,
    this.isLoading = true,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  final List<NewsCategory> categories;
  final List<NewsArticle> breakingNews;
  final List<NewsArticle> trendingNews;
  final List<NewsArticle> personalizedNews;
  final List<NewsArticle> feed;
  final String selectedCategory;
  final int nextPage;
  final bool hasMore;
  final bool isLoading;
  final bool isRefreshing;
  final bool isLoadingMore;
  final String? errorMessage;

  HomeState copyWith({
    List<NewsCategory>? categories,
    List<NewsArticle>? breakingNews,
    List<NewsArticle>? trendingNews,
    List<NewsArticle>? personalizedNews,
    List<NewsArticle>? feed,
    String? selectedCategory,
    int? nextPage,
    bool? hasMore,
    bool? isLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HomeState(
      categories: categories ?? this.categories,
      breakingNews: breakingNews ?? this.breakingNews,
      trendingNews: trendingNews ?? this.trendingNews,
      personalizedNews: personalizedNews ?? this.personalizedNews,
      feed: feed ?? this.feed,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      nextPage: nextPage ?? this.nextPage,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class HomeController extends StateNotifier<HomeState> {
  HomeController(this._repository, this._preferredCategories)
    : super(const HomeState()) {
    loadInitial();
  }

  final NewsRepository _repository;
  final List<String> _preferredCategories;

  Future<void> loadInitial() async {
    state = state.copyWith(isLoading: true, clearError: true);
    await _load(page: 1, resetFeed: true);
  }

  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true, clearError: true);
    await _load(page: 1, resetFeed: true);
  }

  Future<void> selectCategory(String category) async {
    state = state.copyWith(selectedCategory: category, isLoading: true);
    await _load(page: 1, resetFeed: true);
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore || state.isLoading) {
      return;
    }

    state = state.copyWith(isLoadingMore: true);
    await _load(page: state.nextPage, resetFeed: false);
  }

  Future<void> _load({required int page, required bool resetFeed}) async {
    try {
      final result = await _repository.fetchHome(
        category: state.selectedCategory,
        page: page,
        pageSize: AppConstants.pageSize,
        preferredCategories: _preferredCategories,
      );

      state = state.copyWith(
        categories: result.categories,
        breakingNews: result.breakingNews,
        trendingNews: result.trendingNews,
        personalizedNews: result.personalizedNews,
        feed: resetFeed ? result.feed : [...state.feed, ...result.feed],
        nextPage: result.nextPage,
        hasMore: result.hasMore,
        isLoading: false,
        isRefreshing: false,
        isLoadingMore: false,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        isLoadingMore: false,
        errorMessage: error.toString(),
      );
    }
  }
}

final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>(
  (ref) {
    final repository = ref.read(newsRepositoryProvider);
    final settings = ref.watch(settingsControllerProvider);
    return HomeController(repository, settings.preferredCategories);
  },
);
