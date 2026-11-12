import 'package:newshub_clean/src/domain/entities/news_post.dart';

/// Абстракція сховища новин. Реалізується у зовнішньому шарі,
/// Application-шар працює лише з цим інтерфейсом.
abstract interface class PostRepository {
  Future<List<NewsPost>> getAll();
  Future<NewsPost?> getById(String id);
  Future<void> save(NewsPost post);
}
