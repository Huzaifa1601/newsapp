import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/news_image.dart';
import '../../domain/entities/news_article.dart';

class BreakingNewsCarousel extends StatefulWidget {
  const BreakingNewsCarousel({
    super.key,
    required this.articles,
    required this.onArticleTap,
  });

  final List<NewsArticle> articles;
  final ValueChanged<NewsArticle> onArticleTap;

  @override
  State<BreakingNewsCarousel> createState() => _BreakingNewsCarouselState();
}

class _BreakingNewsCarouselState extends State<BreakingNewsCarousel> {
  late final PageController _controller = PageController(
    viewportFraction: 0.92,
  );
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || widget.articles.isEmpty) {
        return;
      }
      final next = (_currentIndex + 1) % widget.articles.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.articles.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Column(
      children: [
        SizedBox(
          height: 330,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.articles.length,
            onPageChanged: (value) {
              setState(() => _currentIndex = value);
            },
            itemBuilder: (context, index) {
              final article = widget.articles[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => widget.onArticleTap(article),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: 'article-image-${article.id}',
                        child: NewsImage(
                          imageUrl: article.imageUrl,
                          height: 330,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.08),
                              Colors.black.withValues(alpha: 0.75),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(999),
                                color: theme.colorScheme.secondary,
                              ),
                              child: Text(
                                'BREAKING',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              article.title,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${article.source} • ${DateFormat('MMM d, h:mm a').format(article.publishedAt)}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.84),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.articles.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: _currentIndex == index ? 24 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: _currentIndex == index
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withValues(alpha: 0.28),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
