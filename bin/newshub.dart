import 'dart:convert';
import 'dart:io';

import 'package:newshub_clean/src/application/use_cases/get_posts_use_case.dart';
import 'package:newshub_clean/src/application/use_cases/publish_post_use_case.dart';
import 'package:newshub_clean/src/application/use_cases/toggle_saved_use_case.dart';
import 'package:newshub_clean/src/domain/entities/post_category.dart';
import 'package:newshub_clean/src/domain/interfaces/post_repository.dart';
import 'package:newshub_clean/src/infrastructure/repositories/json_post_repository.dart';
import 'package:newshub_clean/src/infrastructure/repositories/memory_post_repository.dart';
import 'package:newshub_clean/src/presentation/cli/console_app.dart';

/// Composition root: єдине місце, де збираються всі шари через DI.
Future<void> main() async {
  // 1. Читаємо конфігурацію
  final configText = await File('config/settings.json').readAsString();
  final config = jsonDecode(configText) as Map<String, dynamic>;

  // 2. Обираємо реалізацію сховища (use cases про це нічого не знають)
  final PostRepository repository = switch (config['storage']) {
    'json' => JsonPostRepository(config['dataFile'] as String),
    _ => MemoryPostRepository(),
  };

  // 3. Передаємо репозиторій у use cases через конструктор
  final publishPost = PublishPostUseCase(repository);
  final getPosts = GetPostsUseCase(repository);
  final toggleSaved = ToggleSavedUseCase(repository);

  // 4. Початкові дані, якщо сховище порожнє
  if ((await getPosts()).isEmpty) {
    await publishPost(
      title: 'Збірна України перемогла у відбірковому матчі',
      category: PostCategory.sport,
      source: 'Суспільне Спорт',
    );
    await publishPost(
      title: 'Представлено новий процесор для штучного інтелекту',
      category: PostCategory.tech,
      source: 'Укранюз',
    );
    await publishPost(
      title: 'Європарламент підтримав цифровий євро',
      category: PostCategory.politics,
      source: 'Суспільне',
    );
  }

  // 5. Запускаємо інтерфейс
  await ConsoleApp(
    publishPost: publishPost,
    getPosts: getPosts,
    toggleSaved: toggleSaved,
  ).run();
}
