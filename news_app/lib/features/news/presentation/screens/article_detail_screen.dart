import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/services/service_providers.dart';
import '../../../../core/widgets/news_image.dart';
import '../../domain/entities/news_article.dart';
import '../controllers/bookmarks_controller.dart';
import '../controllers/news_providers.dart';
import '../widgets/news_card.dart';

final articleProvider = FutureProvider.family<NewsArticle, String>((
  ref,
  articleId,
) {
  return ref.read(newsRepositoryProvider).getArticle(articleId);
});

final relatedArticlesProvider =
    FutureProvider.family<List<NewsArticle>, NewsArticle>((ref, article) {
      return ref.read(newsRepositoryProvider).getRelatedArticles(article);
    });

class ArticleDetailScreen extends ConsumerStatefulWidget {
  const ArticleDetailScreen({super.key, required this.articleId});

  final String articleId;

  @override
  ConsumerState<ArticleDetailScreen> createState() =>
      _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends ConsumerState<ArticleDetailScreen> {
  bool _recorded = false;

  @override
  Widget build(BuildContext context) {
    final articleAsync = ref.watch(articleProvider(widget.articleId));
    final bookmarks = ref.watch(bookmarksControllerProvider);

    return articleAsync.when(
      data: (article) {
        if (!_recorded) {
          _recorded = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(newsRepositoryProvider).recordArticleOpened(article);
          });
        }

        final relatedAsync = ref.watch(relatedArticlesProvider(article));
        final isBookmarked = bookmarks.any(
          (savedArticle) => savedArticle.id == article.id,
        );

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 360,
                pinned: true,
                actions: [
                  IconButton(
                    onPressed: () => SharePlus.instance.share(
                      ShareParams(
                        text: '${article.title}\n\nRead in PulseWire.',
                      ),
                    ),
                    icon: const Icon(Icons.share_outlined),
                  ),
                  IconButton(
                    onPressed: () => ref
                        .read(bookmarksControllerProvider.notifier)
                        .toggle(article),
                    icon: Icon(
                      isBookmarked
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: 'article-image-${article.id}',
                        child: NewsImage(
                          imageUrl: article.imageUrl,
                          height: 360,
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.10),
                              Colors.black.withValues(alpha: 0.82),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.category.toUpperCase(),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        article.title,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        article.subtitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 16,
                        runSpacing: 10,
                        children: [
                          _MetaLine(
                            icon: Icons.person_outline_rounded,
                            label: article.author,
                          ),
                          _MetaLine(
                            icon: Icons.schedule_rounded,
                            label: DateFormat(
                              'MMM d, yyyy - h:mm a',
                            ).format(article.publishedAt),
                          ),
                          _MetaLine(
                            icon: Icons.menu_book_rounded,
                            label: '${article.readTimeMinutes} min read',
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          FilledButton.tonalIcon(
                            onPressed: () => ref
                                .read(voicePlaybackServiceProvider)
                                .speak('${article.title}. ${article.summary}'),
                            icon: const Icon(Icons.volume_up_outlined),
                            label: const Text('Listen'),
                          ),
                          const SizedBox(width: 12),
                          FilledButton.tonalIcon(
                            onPressed: () => ref
                                .read(newsRepositoryProvider)
                                .likeArticle(article),
                            icon: const Icon(Icons.favorite_border_rounded),
                            label: Text(article.likes.toString()),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ...article.content
                          .split('\n\n')
                          .map(
                            (paragraph) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Text(
                                paragraph,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                      const SizedBox(height: 18),
                      const SectionHeader(
                        title: 'Related Articles',
                        subtitle: 'More on the same theme.',
                      ),
                      const SizedBox(height: 16),
                      relatedAsync.when(
                        data: (related) => Column(
                          children: related
                              .map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: CompactNewsTile(
                                    article: item,
                                    onTap: () => context.pushReplacement(
                                      '/article/${item.id}',
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stackTrace) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(error.toString(), textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}

class _MetaLine extends StatelessWidget {
  const _MetaLine({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Text(label, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
