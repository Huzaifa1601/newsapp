import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/author/presentation/screens/author_login_screen.dart';
import '../../features/author/presentation/screens/author_studio_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/news/presentation/screens/article_detail_screen.dart';
import '../../features/news/presentation/screens/bookmarks_screen.dart';
import '../../features/news/presentation/screens/home_screen.dart';
import '../../features/news/presentation/screens/search_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/onboarding/presentation/screens/splash_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/shell/presentation/screens/main_shell.dart';

abstract final class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const signUp = '/sign-up';
  static const forgotPassword = '/forgot-password';
  static const authorLogin = '/author-login';
  static const authorStudio = '/author-studio';
  static const home = '/home';
  static const search = '/search';
  static const bookmarks = '/bookmarks';
  static const profile = '/profile';

  static String article(String articleId) => '/article/$articleId';
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) =>
            _fadePage(key: state.pageKey, child: const SplashScreen()),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) =>
            _fadePage(key: state.pageKey, child: const OnboardingScreen()),
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) =>
            _fadePage(key: state.pageKey, child: const LoginScreen()),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        pageBuilder: (context, state) =>
            _fadePage(key: state.pageKey, child: const SignUpScreen()),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        pageBuilder: (context, state) =>
            _fadePage(key: state.pageKey, child: const ForgotPasswordScreen()),
      ),
      GoRoute(
        path: AppRoutes.authorLogin,
        pageBuilder: (context, state) =>
            _fadePage(key: state.pageKey, child: const AuthorLoginScreen()),
      ),
      GoRoute(
        path: AppRoutes.authorStudio,
        pageBuilder: (context, state) =>
            _fadePage(key: state.pageKey, child: const AuthorStudioScreen()),
      ),
      GoRoute(
        path: '/article/:articleId',
        pageBuilder: (context, state) => _fadePage(
          key: state.pageKey,
          child: ArticleDetailScreen(
            articleId: state.pathParameters['articleId'] ?? '',
          ),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: HomeScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.search,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: SearchScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.bookmarks,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: BookmarksScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ProfileScreen()),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

CustomTransitionPage<void> _fadePage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetAnimation = Tween<Offset>(
        begin: const Offset(0, 0.04),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

      return FadeTransition(
        opacity: animation,
        child: SlideTransition(position: offsetAnimation, child: child),
      );
    },
  );
}
