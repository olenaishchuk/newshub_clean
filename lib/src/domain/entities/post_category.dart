/// Категорії новин (бізнес-правило: допустимі лише ці значення)
enum PostCategory {
  sport('Спорт'),
  tech('Технології'),
  politics('Політика');

  final String label;
  const PostCategory(this.label);
}
