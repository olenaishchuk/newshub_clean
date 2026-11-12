import 'package:newshub_clean/src/domain/entities/post_category.dart';

/// Сутність "Новина". Бізнес-правило: заголовок не може бути порожнім.
class NewsPost {
  final String id;
  final String title;
  final PostCategory category;
  final String source;
  final DateTime publishedAt;
  final bool isSaved;

  NewsPost({
    required this.id,
    required this.title,
    required this.category,
    required this.source,
    required this.publishedAt,
    this.isSaved = false,
  }) {
    if (title.trim().isEmpty) {
      throw ArgumentError('Заголовок новини не може бути порожнім');
    }
  }

  /// Повертає копію новини зі зміненим станом "збережено"
  NewsPost copyWith({bool? isSaved}) {
    return NewsPost(
      id: id,
      title: title,
      category: category,
      source: source,
      publishedAt: publishedAt,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
