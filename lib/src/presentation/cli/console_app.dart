import 'dart:convert';
import 'dart:io';

import 'package:newshub_clean/src/application/use_cases/get_posts_use_case.dart';
import 'package:newshub_clean/src/application/use_cases/publish_post_use_case.dart';
import 'package:newshub_clean/src/application/use_cases/toggle_saved_use_case.dart';
import 'package:newshub_clean/src/domain/entities/news_post.dart';
import 'package:newshub_clean/src/domain/entities/post_category.dart';

/// Консольний інтерфейс. Бізнес-логіки тут немає: лише введення/виведення
/// та виклики use cases.
class ConsoleApp {
  final PublishPostUseCase _publishPost;
  final GetPostsUseCase _getPosts;
  final ToggleSavedUseCase _toggleSaved;

  List<NewsPost> _shown = [];

  ConsoleApp({
    required PublishPostUseCase publishPost,
    required GetPostsUseCase getPosts,
    required ToggleSavedUseCase toggleSaved,
  })  : _publishPost = publishPost,
        _getPosts = getPosts,
        _toggleSaved = toggleSaved;

  Future<void> run() async {
    while (true) {
      stdout.writeln('\n=== NewsHub ===');
      stdout.writeln('1. Усі новини');
      stdout.writeln('2. Новини за категорією');
      stdout.writeln('3. Збережені');
      stdout.writeln('4. Опублікувати новину');
      stdout.writeln('5. Зберегти або прибрати зі збережених');
      stdout.writeln('0. Вихід');
      final choice = _readLine('Оберіть пункт: ');

      switch (choice) {
        case '1':
          await _show();
        case '2':
          final category = _askCategory();
          if (category == null) {
            stdout.writeln('Невірна категорія');
          } else {
            await _show(category: category);
          }
        case '3':
          await _show(onlySaved: true);
        case '4':
          await _publish();
        case '5':
          await _toggle();
        case '0':
          stdout.writeln('До побачення!');
          return;
        default:
          stdout.writeln('Невідомий пункт меню');
      }
    }
  }

  String _readLine(String prompt) {
    stdout.write(prompt);
    return (stdin.readLineSync(encoding: utf8) ?? '').trim();
  }

  Future<void> _show({PostCategory? category, bool onlySaved = false}) async {
    _shown = await _getPosts(category: category, onlySaved: onlySaved);
    if (_shown.isEmpty) {
      stdout.writeln('Нічого не знайдено');
      return;
    }
    for (var i = 0; i < _shown.length; i++) {
      final p = _shown[i];
      final mark = p.isSaved ? '[*]' : '[ ]';
      stdout.writeln(
          '${i + 1}. $mark [${p.category.label}] ${p.title} - ${p.source}');
    }
  }

  PostCategory? _askCategory() {
    for (final c in PostCategory.values) {
      stdout.writeln('${c.index + 1}. ${c.label}');
    }
    final n = int.tryParse(_readLine('Категорія: '));
    if (n == null || n < 1 || n > PostCategory.values.length) return null;
    return PostCategory.values[n - 1];
  }

  Future<void> _publish() async {
    final title = _readLine('Заголовок: ');
    final category = _askCategory();
    if (category == null) {
      stdout.writeln('Невірна категорія');
      return;
    }
    final source = _readLine('Джерело: ');
    try {
      await _publishPost(title: title, category: category, source: source);
      stdout.writeln('Новину опубліковано');
    } on ArgumentError catch (e) {
      stdout.writeln('Помилка: ${e.message}');
    }
  }

  Future<void> _toggle() async {
    await _show();
    if (_shown.isEmpty) return;
    final n = int.tryParse(_readLine('Номер новини: '));
    if (n == null || n < 1 || n > _shown.length) {
      stdout.writeln('Невірний номер');
      return;
    }
    final updated = await _toggleSaved(_shown[n - 1].id);
    stdout.writeln(updated.isSaved ? 'Збережено' : 'Прибрано зі збережених');
  }
}
