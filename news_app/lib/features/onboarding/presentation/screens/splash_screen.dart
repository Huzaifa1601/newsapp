import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/onboarding_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..forward();

  @override
  void initState() {
    super.initState();
    unawaited(_navigate());
  }

  Future<void> _navigate() async {
    await Future<void>.delayed(const Duration(milliseconds: 2200));
    while (mounted) {
      final authState = ref.read(authControllerProvider);
      if (authState.isInitialized) {
        final onboardingSeen = ref.read(onboardingControllerProvider);
        if (!mounted) {
          return;
        }
        if (!onboardingSeen) {
          context.go(AppRoutes.onboarding);
        } else if (authState.isAuthenticated) {
          context.go(AppRoutes.home);
        } else {
          context.go(AppRoutes.login);
        }
        return;
      }
      await Future<void>.delayed(const Duration(milliseconds: 120));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.15),
              theme.scaffoldBackgroundColor,
              theme.colorScheme.secondary.withValues(alpha: 0.12),
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final scale = Curves.easeOutBack.transform(_controller.value);
              return Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: _controller.value.clamp(0, 1),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 108,
                        height: 108,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.secondary,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.24,
                              ),
                              blurRadius: 32,
                              offset: const Offset(0, 18),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.auto_stories_rounded,
                          color: Colors.white,
                          size: 46,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('PulseWire', style: theme.textTheme.displaySmall),
                      const SizedBox(height: 8),
                      Text(
                        'Briefings with taste.',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
