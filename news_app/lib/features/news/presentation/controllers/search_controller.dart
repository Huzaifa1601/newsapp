import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../domain/entities/news_article.dart';
import '../../domain/repositories/news_repository.dart';
import 'news_providers.dart';

class SearchState {
  const SearchState({
    this.query = '',
    this.selectedCategory = 'all',
    this.sortBy = 'latest',
    this.dateRange = 'all',
    this.suggestions = const [],
    this.results = const [],
    this.isLoading = false,
    this.isListening = false,
    this.errorMessage,
  });

  final String query;
  final String selectedCategory;
  final String sortBy;
  final String dateRange;
  final List<String> suggestions;
  final List<NewsArticle> results;
  final bool isLoading;
  final bool isListening;
  final String? errorMessage;

  SearchState copyWith({
    String? query,
    String? selectedCategory,
    String? sortBy,
    String? dateRange,
    List<String>? suggestions,
    List<NewsArticle>? results,
    bool? isLoading,
    bool? isListening,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SearchState(
      query: query ?? this.query,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      sortBy: sortBy ?? this.sortBy,
      dateRange: dateRange ?? this.dateRange,
      suggestions: suggestions ?? this.suggestions,
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      isListening: isListening ?? this.isListening,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class SearchController extends StateNotifier<SearchState> {
  SearchController(this._repository, this._speechToText)
    : super(const SearchState()) {
    unawaited(loadSuggestions());
  }

  final NewsRepository _repository;
  final SpeechToText _speechToText;
  Timer? _debounce;

  Future<void> loadSuggestions() async {
    final suggestions = await _repository.suggestions(state.query);
    state = state.copyWith(suggestions: suggestions);
  }

  Future<void> onQueryChanged(String value) async {
    state = state.copyWith(query: value, isLoading: value.trim().isNotEmpty);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 360), () async {
      await search();
    });
  }

  Future<void> setCategory(String category) async {
    state = state.copyWith(selectedCategory: category);
    await search();
  }

  Future<void> setSortBy(String sortBy) async {
    state = state.copyWith(sortBy: sortBy);
    await search();
  }

  Future<void> setDateRange(String dateRange) async {
    state = state.copyWith(dateRange: dateRange);
    await search();
  }

  Future<void> search() async {
    if (state.query.trim().isEmpty) {
      state = state.copyWith(
        results: const [],
        isLoading: false,
        clearError: true,
      );
      await loadSuggestions();
      return;
    }

    try {
      final suggestions = await _repository.suggestions(state.query);
      final results = await _repository.search(
        query: state.query,
        category: state.selectedCategory,
        sortBy: state.sortBy,
        dateRange: state.dateRange,
      );

      state = state.copyWith(
        suggestions: suggestions,
        results: results,
        isLoading: false,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<void> applySuggestion(String suggestion) async {
    state = state.copyWith(query: suggestion);
    await search();
  }

  Future<void> toggleListening() async {
    if (state.isListening) {
      await _speechToText.stop();
      state = state.copyWith(isListening: false);
      return;
    }

    final ready = await _speechToText.initialize();
    if (!ready) {
      state = state.copyWith(errorMessage: 'Voice search is unavailable.');
      return;
    }

    state = state.copyWith(isListening: true, clearError: true);
    await _speechToText.listen(
      onResult: (result) async {
        await onQueryChanged(result.recognizedWords);
        if (result.finalResult) {
          state = state.copyWith(isListening: false);
        }
      },
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

final searchControllerProvider =
    StateNotifierProvider<SearchController, SearchState>((ref) {
      return SearchController(
        ref.read(newsRepositoryProvider),
        ref.read(speechToTextProvider),
      );
    });
