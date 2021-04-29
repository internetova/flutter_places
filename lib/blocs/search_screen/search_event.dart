part of 'search_bloc.dart';

/// события для экрана поиска
abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

/// запрошены данные у сервера
class GetSearchResult extends SearchEvent {
  final SearchFilter filter;
  final String keywords;

  GetSearchResult({
    required this.filter,
    required this.keywords,
  });

  @override
  List<Object?> get props => [filter, keywords];
}

/// получить историю поисковых запросов
class GetSearchHistory extends SearchEvent {
  @override
  List<Object?> get props => [];
}

/// удалить запрос из истории поиска
class RemoveRequestFromHistory extends SearchEvent {
  final int index;

  RemoveRequestFromHistory(this.index);

  @override
  List<Object?> get props => [index];
}

/// очистить историю
class ClearSearchHistory extends SearchEvent {
  @override
  List<Object?> get props => [];
}