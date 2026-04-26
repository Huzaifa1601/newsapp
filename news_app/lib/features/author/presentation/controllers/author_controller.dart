import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/services/app_preferences.dart';
import '../../../../core/services/service_providers.dart';
import '../../../news/domain/entities/news_article.dart';
import '../../data/datasources/author_remote_data_source.dart';
import '../../domain/entities/author_session.dart';

class AuthorState {
  const AuthorState({
    this.session,
    this.articles = const [],
    this.isLoading = false,
    this.message,
    this.isError = false,
  });

  final AuthorSession? session;
  final List<NewsArticle> articles;
  final bool isLoading;
  final String? message;
  final bool isError;

  bool get isAuthenticated => session != null;

  AuthorState copyWith({
    AuthorSession? session,
    bool clearSession = false,
    List<NewsArticle>? articles,
    bool? isLoading,
    String? message,
    bool clearMessage = false,
    bool? isError,
  }) {
    return AuthorState(
      session: clearSession ? null : session ?? this.session,
      articles: articles ?? this.articles,
      isLoading: isLoading ?? this.isLoading,
      message: clearMessage ? null : message ?? this.message,
      isError: isError ?? this.isError,
    );
  }
}

class AuthorController extends StateNotifier<AuthorState> {
  AuthorController(this._remoteDataSource, this._preferences)
    : super(
        AuthorState(
          session: _preferences.authorToken == null
              ? null
              : AuthorSession(
                  token: _preferences.authorToken!,
                  name: _preferences.authorName ?? 'Author',
                  email: _preferences.authorEmail ?? '',
                  bio: _preferences.authorBio,
                ),
        ),
      ) {
    if (state.session != null) {
      loadMyArticles();
    }
  }

  final AuthorRemoteDataSource _remoteDataSource;
  final AppPreferences _preferences;

  Future<void> register({
    required String name,
    required String email,
    required String password,
    String bio = '',
  }) async {
    await _performAuthAction(() {
      return _remoteDataSource.register(
        name: name,
        email: email,
        password: password,
        bio: bio,
      );
    });
  }

  Future<void> login({required String email, required String password}) async {
    await _performAuthAction(() {
      return _remoteDataSource.login(email: email, password: password);
    });
  }

  Future<void> loadMyArticles() async {
    final session = state.session;
    if (session == null) {
      return;
    }

    state = state.copyWith(isLoading: true, clearMessage: true);
    try {
      final articles = await _remoteDataSource.fetchMyArticles(session.token);
      state = state.copyWith(
        articles: articles,
        isLoading: false,
        clearMessage: true,
        isError: false,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        message: error.toString().replaceFirst('Exception: ', ''),
        isError: true,
      );
    }
  }

  Future<void> publishArticle({
    required String title,
    required String subtitle,
    required String summary,
    required String content,
    required String source,
    required String imageUrl,
    required String category,
    required int readTimeMinutes,
    required bool isBreaking,
    required List<String> tags,
  }) async {
    final session = state.session;
    if (session == null) {
      return;
    }

    state = state.copyWith(isLoading: true, clearMessage: true);
    try {
      final article = await _remoteDataSource.publishArticle(
        token: session.token,
        payload: {
          'title': title,
          'subtitle': subtitle,
          'summary': summary,
          'content': content,
          'author': session.name,
          'source': source,
          'imageUrl': imageUrl,
          'category': category,
          'readTimeMinutes': readTimeMinutes,
          'isBreaking': isBreaking,
          'views': 0,
          'likes': 0,
          'tags': tags,
        },
      );

      state = state.copyWith(
        articles: [article, ...state.articles],
        isLoading: false,
        message: 'Article published successfully.',
        isError: false,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        message: error.toString().replaceFirst('Exception: ', ''),
        isError: true,
      );
    }
  }

  Future<void> logout() async {
    await _preferences.clearAuthorSession();
    state = state.copyWith(
      clearSession: true,
      articles: const [],
      isLoading: false,
      clearMessage: true,
      isError: false,
    );
  }

  void clearMessage() {
    state = state.copyWith(clearMessage: true);
  }

  Future<void> _performAuthAction(
    Future<AuthorSession> Function() action,
  ) async {
    state = state.copyWith(isLoading: true, clearMessage: true);
    try {
      final session = await action();
      await _preferences.saveAuthorSession(
        token: session.token,
        name: session.name,
        email: session.email,
        bio: session.bio,
      );
      state = state.copyWith(
        session: session,
        isLoading: false,
        clearMessage: true,
        isError: false,
      );
      await loadMyArticles();
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        message: error.toString().replaceFirst('Exception: ', ''),
        isError: true,
      );
    }
  }
}

final authorRemoteDataSourceProvider = Provider<AuthorRemoteDataSource>((ref) {
  return AuthorRemoteDataSource(client: ref.read(httpClientProvider));
});

final authorControllerProvider =
    StateNotifierProvider<AuthorController, AuthorState>((ref) {
      return AuthorController(
        ref.read(authorRemoteDataSourceProvider),
        ref.read(appPreferencesProvider),
      );
    });
