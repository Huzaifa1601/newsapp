import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/news_image.dart';
import '../../domain/entities/news_article.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.action,
  });

  final String title;
  final String subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(subtitle, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
        ...switch (action) {
          final widget? => [widget],
          null => const [],
        },
      ],
    );
  }
}

class NewsCard extends StatelessWidget {
  const NewsCard({
    super.key,
    required this.article,
    required this.onTap,
    this.trailing,
  });

  final NewsArticle article;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'article-image-${article.id}',
            child: NewsImage(
              imageUrl: article.imageUrl,
              height: 210,
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _MetaPill(label: article.category.toUpperCase()),
              const Spacer(),
              Text(
                DateFormat('MMM d').format(article.publishedAt),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(article.title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(article.summary, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                '${article.readTimeMinutes} min read',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(width: 14),
              Icon(
                Icons.visibility_outlined,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(article.views.toString(), style: theme.textTheme.bodySmall),
              const Spacer(),
              ...switch (trailing) {
                final widget? => [widget],
                null => const [],
              },
            ],
          ),
        ],
      ),
    );
  }
}

class CompactNewsTile extends StatelessWidget {
  const CompactNewsTile({
    super.key,
    required this.article,
    required this.onTap,
    this.trailing,
  });

  final NewsArticle article;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NewsImage(
            imageUrl: article.imageUrl,
            height: 92,
            width: 92,
            borderRadius: BorderRadius.circular(18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  article.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 10),
                Text(
                  '${article.source} - ${article.readTimeMinutes} min',
                  style: theme.textTheme.labelMedium,
                ),
              ],
            ),
          ),
          ...switch (trailing) {
            final widget? => [widget],
            null => const [],
          },
        ],
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: theme.colorScheme.primary.withValues(alpha: 0.14),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
