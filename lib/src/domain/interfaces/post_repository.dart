import 'package:newshub_clean/src/domain/entities/news_post.dart';

abstract interface class PostRepository {
  Future<List<NewsPost>> getAll();
  Future<NewsPost?> getById(String id);
  Future<void> save(NewsPost post);
}
