import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../controllers/bookmarks_controller.dart';
import '../widgets/news_card.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(bookmarksControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: bookmarks.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Save stories for offline reading and they will show up here.',
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final article = bookmarks[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: NewsCard(
                    article: article,
                    onTap: () => context.push(AppRoutes.article(article.id)),
                    trailing: IconButton(
                      onPressed: () => ref
                          .read(bookmarksControllerProvider.notifier)
                          .toggle(article),
                      icon: const Icon(Icons.bookmark_remove_rounded),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
