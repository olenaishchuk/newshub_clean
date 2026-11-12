import 'package:newshub_clean/src/domain/entities/news_post.dart';
import 'package:newshub_clean/src/domain/interfaces/post_repository.dart';

class ToggleSavedUseCase {
  final PostRepository _repository;

  ToggleSavedUseCase(this._repository);

  Future<NewsPost> call(String id) async {
    final post = await _repository.getById(id);
    if (post == null) {
      throw StateError('Новину з id=$id не знайдено');
    }
    final updated = post.copyWith(isSaved: !post.isSaved);
    await _repository.save(updated);
    return updated;
  }
}
