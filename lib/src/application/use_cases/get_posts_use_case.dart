import 'package:newshub_clean/src/domain/entities/news_post.dart';
import 'package:newshub_clean/src/domain/entities/post_category.dart';
import 'package:newshub_clean/src/domain/interfaces/post_repository.dart';

/// Повертає новини, відфільтровані за категорією та/або збереженими,
/// від найновіших до найстаріших.
class GetPostsUseCase {
  final PostRepository _repository;

  GetPostsUseCase(this._repository);

  Future<List<NewsPost>> call({
    PostCategory? category,
    bool onlySaved = false,
  }) async {
    final all = await _repository.getAll();
    final result = all
        .where((p) =>
            (category == null || p.category == category) &&
            (!onlySaved || p.isSaved))
        .toList();
    result.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    return result;
  }
}
