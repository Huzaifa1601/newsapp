import 'package:flutter/material.dart';

import '../../domain/entities/news_article.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  final List<NewsCategory> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final items = [
      const NewsCategory(
        slug: 'all',
        title: 'All',
        description: 'Every headline in one stream',
      ),
      ...categories,
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final category = items[index];
          final selected = category.slug == selectedCategory;
          return ChoiceChip(
            label: Text(category.title),
            selected: selected,
            onSelected: (selected) => onSelected(category.slug),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemCount: items.length,
      ),
    );
  }
}
