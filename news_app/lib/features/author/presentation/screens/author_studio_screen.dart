import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../news/presentation/widgets/news_card.dart';
import '../controllers/author_controller.dart';

class AuthorStudioScreen extends ConsumerStatefulWidget {
  const AuthorStudioScreen({super.key});

  @override
  ConsumerState<AuthorStudioScreen> createState() => _AuthorStudioScreenState();
}

class _AuthorStudioScreenState extends ConsumerState<AuthorStudioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _summaryController = TextEditingController();
  final _contentController = TextEditingController();
  final _sourceController = TextEditingController(
    text: 'PulseWire Author Desk',
  );
  final _imageUrlController = TextEditingController();
  final _tagsController = TextEditingController();
  final _readTimeController = TextEditingController(text: '5');
  String _category = 'technology';
  bool _isBreaking = false;

  @override
  void initState() {
    super.initState();
    ref.listenManual<AuthorState>(authorControllerProvider, (previous, next) {
      if (next.message != null && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.message!)));
        ref.read(authorControllerProvider.notifier).clearMessage();
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _summaryController.dispose();
    _contentController.dispose();
    _sourceController.dispose();
    _imageUrlController.dispose();
    _tagsController.dispose();
    _readTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(authorControllerProvider);
    final session = state.session;

    if (session == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go(AppRoutes.authorLogin);
        }
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Author Studio'),
        actions: [
          TextButton(
            onPressed: () async {
              await ref.read(authorControllerProvider.notifier).logout();
              if (context.mounted) {
                context.go(AppRoutes.authorLogin);
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: [
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ${session.name}',
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 6),
                Text(session.email, style: theme.textTheme.bodyMedium),
                if (session.bio.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(session.bio, style: theme.textTheme.bodyMedium),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),
          GlassCard(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create News Article',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) =>
                        value == null || value.trim().length < 8
                        ? 'Enter a stronger title.'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _subtitleController,
                    decoration: const InputDecoration(labelText: 'Subtitle'),
                    validator: (value) =>
                        value == null || value.trim().length < 8
                        ? 'Enter a subtitle.'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _summaryController,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Summary'),
                    validator: (value) =>
                        value == null || value.trim().length < 12
                        ? 'Enter a short summary.'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _contentController,
                    maxLines: 8,
                    decoration: const InputDecoration(
                      labelText: 'Full content',
                    ),
                    validator: (value) =>
                        value == null || value.trim().length < 20
                        ? 'Enter the article body.'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: const InputDecoration(labelText: 'Image URL'),
                    validator: (value) =>
                        value == null || !value.startsWith('http')
                        ? 'Enter a valid image URL.'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: _category,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items:
                        const [
                              'technology',
                              'business',
                              'politics',
                              'sports',
                              'science',
                              'culture',
                              'health',
                              'world',
                            ]
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _category = value);
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _readTimeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Read time (minutes)',
                          ),
                          validator: (value) =>
                              int.tryParse(value ?? '') == null
                              ? 'Enter a number.'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _sourceController,
                          decoration: const InputDecoration(
                            labelText: 'Source',
                          ),
                          validator: (value) =>
                              value == null || value.trim().length < 2
                              ? 'Enter source.'
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _tagsController,
                    decoration: const InputDecoration(
                      labelText: 'Tags (comma separated)',
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Add at least one tag.'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _isBreaking,
                    onChanged: (value) {
                      setState(() => _isBreaking = value);
                    },
                    title: const Text('Mark as breaking news'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: state.isLoading
                        ? null
                        : () async {
                            if (!(_formKey.currentState?.validate() ?? false)) {
                              return;
                            }

                            await ref
                                .read(authorControllerProvider.notifier)
                                .publishArticle(
                                  title: _titleController.text.trim(),
                                  subtitle: _subtitleController.text.trim(),
                                  summary: _summaryController.text.trim(),
                                  content: _contentController.text.trim(),
                                  source: _sourceController.text.trim(),
                                  imageUrl: _imageUrlController.text.trim(),
                                  category: _category,
                                  readTimeMinutes: int.parse(
                                    _readTimeController.text.trim(),
                                  ),
                                  isBreaking: _isBreaking,
                                  tags: _tagsController.text
                                      .split(',')
                                      .map((item) => item.trim())
                                      .where((item) => item.isNotEmpty)
                                      .toList(),
                                );

                            if (mounted) {
                              _titleController.clear();
                              _subtitleController.clear();
                              _summaryController.clear();
                              _contentController.clear();
                              _imageUrlController.clear();
                              _tagsController.clear();
                              _readTimeController.text = '5';
                              setState(() => _isBreaking = false);
                            }
                          },
                    child: state.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Publish Article'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          SectionHeader(
            title: 'Your Published News',
            subtitle: 'Everything you create appears in the public feed.',
            action: TextButton(
              onPressed: () =>
                  ref.read(authorControllerProvider.notifier).loadMyArticles(),
              child: const Text('Refresh'),
            ),
          ),
          const SizedBox(height: 14),
          if (state.articles.isEmpty)
            GlassCard(
              child: Text(
                'No published articles yet. Create one above and refresh the reader home feed to see it.',
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ...state.articles.map(
            (article) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: CompactNewsTile(
                article: article,
                onTap: () => context.push(AppRoutes.article(article.id)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
