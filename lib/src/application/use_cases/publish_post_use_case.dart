import 'dart:math';

import 'package:newshub_clean/src/domain/entities/news_post.dart';
import 'package:newshub_clean/src/domain/entities/post_category.dart';
import 'package:newshub_clean/src/domain/interfaces/post_repository.dart';

/// Сценарій: опублікувати нову новину.
/// Залежить лише від інтерфейсу PostRepository (принцип DIP).
class PublishPostUseCase {
  final PostRepository _repository;

  PublishPostUseCase(this._repository);

  Future<NewsPost> call({
    required String title,
    required PostCategory category,
    required String source,
  }) async {
    final now = DateTime.now();
    final post = NewsPost(
      id: '${now.microsecondsSinceEpoch}${Random().nextInt(9999)}',
      title: title.trim(),
      category: category,
      source: source.trim(),
      publishedAt: now,
    );
    await _repository.save(post);
    return post;
  }
}
