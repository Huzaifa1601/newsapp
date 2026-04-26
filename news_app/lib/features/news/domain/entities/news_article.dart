class NewsCategory {
  const NewsCategory({
    required this.slug,
    required this.title,
    required this.description,
  });

  final String slug;
  final String title;
  final String description;

  factory NewsCategory.fromJson(Map<String, dynamic> json) {
    return NewsCategory(
      slug: json['slug'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'slug': slug, 'title': title, 'description': description};
  }
}

class NewsArticle {
  const NewsArticle({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.summary,
    required this.content,
    required this.author,
    required this.source,
    required this.imageUrl,
    required this.category,
    required this.publishedAt,
    required this.readTimeMinutes,
    required this.isBreaking,
    required this.views,
    required this.likes,
    required this.tags,
  });

  final String id;
  final String title;
  final String subtitle;
  final String summary;
  final String content;
  final String author;
  final String source;
  final String imageUrl;
  final String category;
  final DateTime publishedAt;
  final int readTimeMinutes;
  final bool isBreaking;
  final int views;
  final int likes;
  final List<String> tags;

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      content: json['content'] as String? ?? '',
      author: json['author'] as String? ?? 'PulseWire Desk',
      source: json['source'] as String? ?? 'PulseWire',
      imageUrl: json['imageUrl'] as String? ?? '',
      category: json['category'] as String? ?? 'general',
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      readTimeMinutes: (json['readTimeMinutes'] as num?)?.toInt() ?? 5,
      isBreaking: json['isBreaking'] as bool? ?? false,
      views: (json['views'] as num?)?.toInt() ?? 0,
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      tags: (json['tags'] as List<dynamic>? ?? const [])
          .map((item) => item.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'summary': summary,
      'content': content,
      'author': author,
      'source': source,
      'imageUrl': imageUrl,
      'category': category,
      'publishedAt': publishedAt.toIso8601String(),
      'readTimeMinutes': readTimeMinutes,
      'isBreaking': isBreaking,
      'views': views,
      'likes': likes,
      'tags': tags,
    };
  }
}

class HomeFeed {
  const HomeFeed({
    required this.categories,
    required this.breakingNews,
    required this.trendingNews,
    required this.personalizedNews,
    required this.feed,
    required this.hasMore,
    required this.nextPage,
  });

  final List<NewsCategory> categories;
  final List<NewsArticle> breakingNews;
  final List<NewsArticle> trendingNews;
  final List<NewsArticle> personalizedNews;
  final List<NewsArticle> feed;
  final bool hasMore;
  final int nextPage;

  factory HomeFeed.fromJson(Map<String, dynamic> json) {
    final payload = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final categories = (payload['categories'] as List<dynamic>? ?? const [])
        .map(
          (item) => item is String
              ? NewsCategory(
                  slug: item,
                  title: _titleize(item),
                  description: '',
                )
              : NewsCategory.fromJson(item as Map<String, dynamic>),
        )
        .toList();

    List<NewsArticle> parseArticles(String key) {
      return (payload[key] as List<dynamic>? ?? const [])
          .map((item) => NewsArticle.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return HomeFeed(
      categories: categories,
      breakingNews: parseArticles('breakingNews'),
      trendingNews: parseArticles('trendingNews'),
      personalizedNews: parseArticles('personalizedNews'),
      feed: parseArticles('feed'),
      hasMore: payload['hasMore'] as bool? ?? false,
      nextPage: (payload['nextPage'] as num?)?.toInt() ?? 2,
    );
  }

  static String _titleize(String value) {
    return value
        .split('_')
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }
}
