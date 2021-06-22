part of 'search_bloc.dart';

/// события для экрана поиска
abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

/// запрошены данные у сервера
class GetSearchResult extends SearchEvent {
  final ObjectPosition? userLocation;
  final SearchFilter? filter;
  final String keywords;

  GetSearchResult({
    this.userLocation,
    this.filter,
    required this.keywords,
  });

  @override
  List<Object?> get props => [userLocation, filter, keywords];
}

/// получить историю поисковых запросов
class GetSearchHistory extends SearchEvent {
  @override
  List<Object?> get props => [];
}

/// удалить запрос из истории поиска
class DeleteRequestFromHistory extends SearchEvent {
  final int index;

  DeleteRequestFromHistory(this.index);

  @override
  List<Object?> get props => [index];
}

/// очистить историю
class ClearSearchHistory extends SearchEvent {
  @override
  List<Object?> get props => [];
}

/// изменение строки поиска при вводе текста
class ChangedTextFieldSearch extends SearchEvent {
  final String queryString;

  ChangedTextFieldSearch(this.queryString);

  @override
  List<Object?> get props => [queryString];
}

/// инициализация запуска поиска если если есть изменения в текстовом поле,
/// текстовый запрос возьмём из стрима,
/// событие запустим в initState виджета [SearchScreen]
class StartSearchFromTextField extends SearchEvent {
  final ObjectPosition? userLocation;
  final SearchFilter? filter;

  StartSearchFromTextField({this.userLocation, this.filter});

  @override
  List<Object?> get props => [userLocation, filter];
}