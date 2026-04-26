import 'package:flutter_test/flutter_test.dart';

import 'package:news_app/features/news/domain/entities/news_article.dart';

void main() {
  test('news article JSON round trip preserves key fields', () {
    final article = NewsArticle(
      id: 'sample-1',
      title: 'Premium news title',
      subtitle: 'Subtitle',
      summary: 'Summary',
      content: 'Content body',
      author: 'PulseWire Desk',
      source: 'PulseWire',
      imageUrl: 'https://example.com/image.jpg',
      category: 'technology',
      publishedAt: DateTime.parse('2026-04-17T10:00:00.000Z'),
      readTimeMinutes: 4,
      isBreaking: true,
      views: 12,
      likes: 3,
      tags: const ['ai', 'mobile'],
    );

    final encoded = article.toJson();
    final decoded = NewsArticle.fromJson(encoded);

    expect(decoded.id, article.id);
    expect(decoded.title, article.title);
    expect(decoded.category, article.category);
    expect(decoded.isBreaking, isTrue);
    expect(decoded.tags, contains('ai'));
  });
}
