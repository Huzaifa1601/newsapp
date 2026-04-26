import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthState {
  const AuthState({
    this.user,
    this.isInitialized = false,
    this.isLoading = false,
    this.message,
    this.isError = false,
  });

  final AppUser? user;
  final bool isInitialized;
  final bool isLoading;
  final String? message;
  final bool isError;

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    AppUser? user,
    bool clearUser = false,
    bool? isInitialized,
    bool? isLoading,
    String? message,
    bool clearMessage = false,
    bool? isError,
  }) {
    return AuthState(
      user: clearUser ? null : user ?? this.user,
      isInitialized: isInitialized ?? this.isInitialized,
      isLoading: isLoading ?? this.isLoading,
      message: clearMessage ? null : message ?? this.message,
      isError: isError ?? this.isError,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._repository) : super(const AuthState()) {
    _subscription = _repository.authStateChanges().listen(
      (user) {
        if (state.user?.isGuest == true && user == null) {
          state = state.copyWith(isInitialized: true);
          return;
        }

        state = state.copyWith(
          user: user,
          clearUser: user == null,
          isInitialized: true,
          isLoading: false,
          clearMessage: true,
        );
      },
      onError: (Object error) {
        state = state.copyWith(
          isInitialized: true,
          isLoading: false,
          message: _mapError(error),
          isError: true,
        );
      },
    );
  }

  final AuthRepository _repository;
  late final StreamSubscription<AppUser?> _subscription;

  Future<void> signIn({required String email, required String password}) async {
    await _performAuthAction(() {
      return _repository.signInWithEmail(email: email, password: password);
    });
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await _performAuthAction(() {
      return _repository.signUpWithEmail(
        name: name,
        email: email,
        password: password,
      );
    });
  }

  Future<void> signInWithGoogle() async {
    await _performAuthAction(_repository.signInWithGoogle);
  }

  Future<void> continueAsGuest() async {
    state = state.copyWith(
      user: AppUser.guest(),
      isInitialized: true,
      isLoading: false,
      message: null,
      isError: false,
    );
  }

  Future<void> sendPasswordResetEmail(String email) async {
    state = state.copyWith(isLoading: true, clearMessage: true);
    try {
      await _repository.sendPasswordResetEmail(email);
      state = state.copyWith(
        isLoading: false,
        message: 'Password reset link sent to $email',
        isError: false,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        message: _mapError(error),
        isError: true,
      );
    }
  }

  Future<void> signOut() async {
    if (state.user?.isGuest == true) {
      state = state.copyWith(clearUser: true, isLoading: false);
      return;
    }

    state = state.copyWith(isLoading: true, clearMessage: true);
    try {
      await _repository.signOut();
      state = state.copyWith(clearUser: true, isLoading: false);
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        message: _mapError(error),
        isError: true,
      );
    }
  }

  void clearMessage() {
    state = state.copyWith(clearMessage: true);
  }

  Future<void> _performAuthAction(Future<AppUser> Function() action) async {
    state = state.copyWith(isLoading: true, clearMessage: true);
    try {
      final user = await action();
      state = state.copyWith(
        user: user,
        isLoading: false,
        isInitialized: true,
        isError: false,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        isInitialized: true,
        message: _mapError(error),
        isError: true,
      );
    }
  }

  String _mapError(Object error) {
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return 'Something went wrong. Please try again.';
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(authRemoteDataSourceProvider));
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    return AuthController(ref.read(authRepositoryProvider));
  },
);
