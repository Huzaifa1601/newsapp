import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../controllers/search_controller.dart';
import '../widgets/news_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(searchControllerProvider);
    final notifier = ref.read(searchControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: [
          TextField(
            controller: _controller,
            onChanged: notifier.onQueryChanged,
            decoration: InputDecoration(
              hintText: 'Search the world',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: IconButton(
                onPressed: notifier.toggleListening,
                icon: Icon(
                  state.isListening
                      ? Icons.graphic_eq_rounded
                      : Icons.mic_none_rounded,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Category', style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final category in const [
                'all',
                'technology',
                'business',
                'politics',
                'sports',
                'science',
                'culture',
                'health',
                'world',
              ])
                ChoiceChip(
                  label: Text(category),
                  selected: state.selectedCategory == category,
                  onSelected: (_) => notifier.setCategory(category),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text('Sort & Date', style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final sort in const ['latest', 'popular'])
                ChoiceChip(
                  label: Text(sort),
                  selected: state.sortBy == sort,
                  onSelected: (_) => notifier.setSortBy(sort),
                ),
              for (final range in const ['all', 'today', 'week', 'month'])
                FilterChip(
                  label: Text(range),
                  selected: state.dateRange == range,
                  onSelected: (_) => notifier.setDateRange(range),
                ),
            ],
          ),
          const SizedBox(height: 22),
          if (state.query.isEmpty) ...[
            Text('Suggestions', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: state.suggestions
                  .map(
                    (suggestion) => ActionChip(
                      label: Text(suggestion),
                      onPressed: () {
                        _controller.text = suggestion;
                        notifier.applySuggestion(suggestion);
                      },
                    ),
                  )
                  .toList(),
            ),
          ] else if (state.isLoading) ...[
            const Center(child: CircularProgressIndicator()),
          ] else ...[
            Row(
              children: [
                Text('Results', style: theme.textTheme.headlineSmall),
                const Spacer(),
                Text('${state.results.length} stories'),
              ],
            ),
            const SizedBox(height: 16),
            if (state.results.isEmpty)
              Text(
                'No matches yet. Try another topic or switch filters.',
                style: theme.textTheme.bodyLarge,
              ),
            ...state.results.map(
              (article) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: CompactNewsTile(
                  article: article,
                  onTap: () => context.push(AppRoutes.article(article.id)),
                ),
              ),
            ),
          ],
          if (state.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                state.errorMessage!,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
        ],
      ),
    );
  }
}
