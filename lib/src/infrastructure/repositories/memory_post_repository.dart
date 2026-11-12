import 'package:newshub_clean/src/domain/entities/news_post.dart';
import 'package:newshub_clean/src/domain/interfaces/post_repository.dart';

/// Реалізація сховища у пам'яті (дані зникають після закриття програми)
class MemoryPostRepository implements PostRepository {
  final Map<String, NewsPost> _items = {};

  @override
  Future<List<NewsPost>> getAll() async => List.of(_items.values);

  @override
  Future<NewsPost?> getById(String id) async => _items[id];

  @override
  Future<void> save(NewsPost post) async {
    _items[post.id] = post;
  }
}
