import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const _slides = <_Slide>[
    _Slide(
      title: 'Breaking news, elevated.',
      description:
          'A polished briefing experience with bold typography, glass surfaces, and smooth storytelling transitions.',
      icon: Icons.bolt_rounded,
    ),
    _Slide(
      title: 'Personalized by reading behavior.',
      description:
          'PulseWire quietly learns the topics you return to and reshapes the feed around your real interests.',
      icon: Icons.insights_rounded,
    ),
    _Slide(
      title: 'Search with voice, save offline.',
      description:
          'Use voice search, keep key stories bookmarked, and come back to them even when connectivity drops.',
      icon: Icons.mic_external_on_rounded,
    ),
    _Slide(
      title: 'Premium profile and notification flow.',
      description:
          'Manage themes, interests, history, and alerts with the same care as the main reading experience.',
      icon: Icons.notifications_active_rounded,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    await ref.read(onboardingControllerProvider.notifier).complete();
    if (mounted) {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLastPage = _currentPage == AppConstants.onboardingPageCount - 1;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.12),
                  theme.scaffoldBackgroundColor,
                  theme.colorScheme.secondary.withValues(alpha: 0.10),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _completeOnboarding,
                      child: const Text('Skip'),
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _slides.length,
                      onPageChanged: (value) {
                        setState(() => _currentPage = value);
                      },
                      itemBuilder: (context, index) {
                        final slide = _slides[index];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 220,
                              height: 220,
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
                                      alpha: 0.22,
                                    ),
                                    blurRadius: 40,
                                    offset: const Offset(0, 20),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                slide.icon,
                                color: Colors.white,
                                size: 84,
                              ),
                            ),
                            const SizedBox(height: 36),
                            Text(
                              slide.title,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.displaySmall,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              slide.description,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slides.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 28 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: _currentPage == index
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline.withValues(
                                  alpha: 0.32,
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    onPressed: () async {
                      if (isLastPage) {
                        await _completeOnboarding();
                      } else {
                        await _pageController.nextPage(
                          duration: const Duration(milliseconds: 320),
                          curve: Curves.easeOutCubic,
                        );
                      }
                    },
                    child: Text(isLastPage ? 'Get Started' : 'Next'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Slide {
  const _Slide({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}
