/// item истории поиска
/// [id] для сортировки результатов
/// [request] поисковые запросы
class SearchHistoryItem {
  final int id;
  final String request;

  SearchHistoryItem({
    required this.id,
    required this.request,
  });
}
