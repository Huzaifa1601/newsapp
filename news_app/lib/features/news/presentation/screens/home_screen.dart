import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/widgets/animated_skeleton.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../settings/presentation/controllers/settings_controller.dart';
import '../controllers/bookmarks_controller.dart';
import '../controllers/home_controller.dart';
import '../widgets/breaking_news_carousel.dart';
import '../widgets/category_selector.dart';
import '../widgets/news_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final homeState = ref.watch(homeControllerProvider);
    final bookmarks = ref.watch(bookmarksControllerProvider);
    final authState = ref.watch(authControllerProvider);
    final settings = ref.watch(settingsControllerProvider);

    Future<void> openArticle(String articleId) async {
      context.push(AppRoutes.article(articleId));
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.read(homeControllerProvider.notifier).refresh(),
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.pixels >
                notification.metrics.maxScrollExtent - 400) {
              ref.read(homeControllerProvider.notifier).loadMore();
            }
            return false;
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('EEEE, MMM d').format(DateTime.now()),
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          authState.user == null
                              ? 'Good evening'
                              : 'Hello, ${authState.user!.name.split(' ').first}',
                          style: theme.textTheme.displaySmall,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'A premium briefing curated around your interests.',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton.filledTonal(
                    onPressed: () => context.go(AppRoutes.profile),
                    icon: CircleAvatar(
                      radius: 16,
                      child: Text(
                        (authState.user?.name.isNotEmpty == true
                                ? authState.user!.name.substring(0, 1)
                                : 'P')
                            .toUpperCase(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => context.go(AppRoutes.search),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: theme.colorScheme.surface.withValues(alpha: 0.84),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search_rounded,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Search stories, topics, or authors',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                      Icon(
                        Icons.mic_none_rounded,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CategorySelector(
                categories: homeState.categories,
                selectedCategory: homeState.selectedCategory,
                onSelected: (value) {
                  ref
                      .read(homeControllerProvider.notifier)
                      .selectCategory(value);
                },
              ),
              const SizedBox(height: 26),
              if (homeState.isLoading && homeState.feed.isEmpty) ...[
                const AnimatedSkeleton(height: 330, borderRadius: 30),
                const SizedBox(height: 24),
                const AnimatedSkeleton(height: 120),
                const SizedBox(height: 14),
                const AnimatedSkeleton(height: 120),
                const SizedBox(height: 14),
                const AnimatedSkeleton(height: 120),
              ] else ...[
                SectionHeader(
                  title: 'Breaking Now',
                  subtitle: 'Fast-moving stories with the biggest impact.',
                  action: TextButton(
                    onPressed: () => context.go(AppRoutes.search),
                    child: const Text('See all'),
                  ),
                ),
                const SizedBox(height: 18),
                BreakingNewsCarousel(
                  articles: homeState.breakingNews,
                  onArticleTap: (article) => openArticle(article.id),
                ),
                const SizedBox(height: 28),
                SectionHeader(
                  title: 'Trending',
                  subtitle: 'What readers are opening most right now.',
                ),
                const SizedBox(height: 18),
                SizedBox(
                  height: 154,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: homeState.trendingNews.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final article = homeState.trendingNews[index];
                      return SizedBox(
                        width: 320,
                        child: CompactNewsTile(
                          article: article,
                          onTap: () => openArticle(article.id),
                          trailing: IconButton(
                            onPressed: () => ref
                                .read(bookmarksControllerProvider.notifier)
                                .toggle(article),
                            icon: Icon(
                              bookmarks.any((item) => item.id == article.id)
                                  ? Icons.bookmark_rounded
                                  : Icons.bookmark_border_rounded,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 28),
                SectionHeader(
                  title: 'For You',
                  subtitle:
                      'Weighted around ${settings.preferredCategories.take(2).join(' and ')}.',
                ),
                const SizedBox(height: 18),
                ...homeState.personalizedNews.map(
                  (article) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: CompactNewsTile(
                      article: article,
                      onTap: () => openArticle(article.id),
                      trailing: IconButton(
                        onPressed: () => ref
                            .read(bookmarksControllerProvider.notifier)
                            .toggle(article),
                        icon: Icon(
                          bookmarks.any((item) => item.id == article.id)
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                SectionHeader(
                  title: 'Latest Feed',
                  subtitle: 'Infinite scroll with premium spacing and clarity.',
                ),
                const SizedBox(height: 18),
                ...homeState.feed.map(
                  (article) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: NewsCard(
                      article: article,
                      onTap: () => openArticle(article.id),
                      trailing: IconButton(
                        onPressed: () => ref
                            .read(bookmarksControllerProvider.notifier)
                            .toggle(article),
                        icon: Icon(
                          bookmarks.any((item) => item.id == article.id)
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                        ),
                      ),
                    ),
                  ),
                ),
                if (homeState.isLoadingMore)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                if (!homeState.hasMore)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Center(
                      child: Text(
                        'You are all caught up.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
              ],
              if (homeState.errorMessage != null && homeState.feed.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Center(
                    child: Text(
                      homeState.errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
