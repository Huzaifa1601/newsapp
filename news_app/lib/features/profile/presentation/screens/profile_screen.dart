import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../author/presentation/controllers/author_controller.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../news/presentation/controllers/bookmarks_controller.dart';
import '../../../settings/presentation/controllers/settings_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authControllerProvider);
    final authorState = ref.watch(authorControllerProvider);
    final bookmarks = ref.watch(bookmarksControllerProvider);
    final settings = ref.watch(settingsControllerProvider);
    final historyAsync = ref.watch(readingHistoryProvider);

    final user = authState.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: [
          GlassCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 34,
                  child: Text(
                    (user?.name.isNotEmpty == true
                            ? user!.name.substring(0, 1)
                            : 'P')
                        .toUpperCase(),
                    style: theme.textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'PulseWire Reader',
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        user?.email ?? 'Sign in to sync your profile',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_outlined),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Saved', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(
                        '${bookmarks.length}',
                        style: theme.textTheme.displaySmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GlassCard(
                  child: historyAsync.when(
                    data: (history) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('History', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(
                          '${history.length}',
                          style: theme.textTheme.displaySmall,
                        ),
                      ],
                    ),
                    loading: () => const SizedBox(
                      height: 56,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, stackTrace) => const Text('0'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Author Tools', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  authorState.isAuthenticated
                      ? 'Signed in as ${authorState.session!.name}. Publish articles that appear in the public news feed.'
                      : 'Sign in as an author to create and publish news for readers.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.push(
                    authorState.isAuthenticated
                        ? AppRoutes.authorStudio
                        : AppRoutes.authorLogin,
                  ),
                  child: Text(
                    authorState.isAuthenticated
                        ? 'Open Author Studio'
                        : 'Author Login',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Preferences', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 16),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Dark mode'),
                  subtitle: Text(
                    'Current: ${settings.themeMode.name}',
                    style: theme.textTheme.bodySmall,
                  ),
                  value: settings.themeMode == ThemeMode.dark,
                  onChanged: (_) => ref
                      .read(settingsControllerProvider.notifier)
                      .toggleThemeMode(),
                ),
                const Divider(),
                Text('Favorite categories', style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final category in const [
                      'technology',
                      'business',
                      'world',
                      'politics',
                      'sports',
                      'science',
                      'culture',
                      'health',
                    ])
                      FilterChip(
                        label: Text(category),
                        selected: settings.preferredCategories.contains(
                          category,
                        ),
                        onSelected: (_) => ref
                            .read(settingsControllerProvider.notifier)
                            .togglePreferredCategory(category),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Language', style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'en', label: Text('English')),
                    ButtonSegment(value: 'ur', label: Text('Urdu')),
                  ],
                  selected: {settings.localeCode},
                  onSelectionChanged: (value) => ref
                      .read(settingsControllerProvider.notifier)
                      .setLocaleCode(value.first),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Recent reading', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 16),
                historyAsync.when(
                  data: (history) {
                    if (history.isEmpty) {
                      return Text(
                        'Your reading journey will appear here.',
                        style: theme.textTheme.bodyMedium,
                      );
                    }
                    return Column(
                      children: history
                          .take(3)
                          .map(
                            (article) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(article.title),
                              subtitle: Text(article.source),
                              onTap: () =>
                                  context.push(AppRoutes.article(article.id)),
                            ),
                          )
                          .toList(),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => Text(
                    'History is unavailable right now.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          if (user != null)
            FilledButton.tonal(
              onPressed: () async {
                await ref.read(authControllerProvider.notifier).signOut();
                if (context.mounted) {
                  context.go(AppRoutes.login);
                }
              },
              child: const Text('Logout'),
            ),
        ],
      ),
    );
  }
}
