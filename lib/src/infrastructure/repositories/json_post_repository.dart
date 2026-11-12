import 'dart:convert';
import 'dart:io';

import 'package:newshub_clean/src/domain/entities/news_post.dart';
import 'package:newshub_clean/src/domain/entities/post_category.dart';
import 'package:newshub_clean/src/domain/interfaces/post_repository.dart';

/// Реалізація сховища у JSON-файлі. Перетворення в JSON робиться тут,
/// тому Domain-сутність нічого не знає про формат зберігання.
class JsonPostRepository implements PostRepository {
  final String filePath;

  JsonPostRepository(this.filePath);

  @override
  Future<List<NewsPost>> getAll() => _read();

  @override
  Future<NewsPost?> getById(String id) async {
    final all = await _read();
    for (final post in all) {
      if (post.id == id) return post;
    }
    return null;
  }

  @override
  Future<void> save(NewsPost post) async {
    final all = await _read();
    final index = all.indexWhere((p) => p.id == post.id);
    if (index >= 0) {
      all[index] = post;
    } else {
      all.add(post);
    }
    await _write(all);
  }

  Future<List<NewsPost>> _read() async {
    final file = File(filePath);
    if (!await file.exists()) return [];
    final text = await file.readAsString();
    if (text.trim().isEmpty) return [];
    final list = jsonDecode(text) as List<dynamic>;
    return list.map((e) => _fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> _write(List<NewsPost> items) async {
    final file = File(filePath);
    await file.parent.create(recursive: true);
    final text =
        const JsonEncoder.withIndent('  ').convert(items.map(_toJson).toList());
    await file.writeAsString(text);
  }

  Map<String, dynamic> _toJson(NewsPost p) => {
        'id': p.id,
        'title': p.title,
        'category': p.category.name,
        'source': p.source,
        'publishedAt': p.publishedAt.toIso8601String(),
        'isSaved': p.isSaved,
      };

  NewsPost _fromJson(Map<String, dynamic> j) => NewsPost(
        id: j['id'] as String,
        title: j['title'] as String,
        category: PostCategory.values.byName(j['category'] as String),
        source: j['source'] as String,
        publishedAt: DateTime.parse(j['publishedAt'] as String),
        isSaved: j['isSaved'] as bool? ?? false,
      );
}
