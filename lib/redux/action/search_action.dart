import 'package:places/data/model/place.dart';
import 'package:places/data/model/search_filter.dart';

/// базовый класс действий на экране Поиска
abstract class SearchAction {}

/// отправить запрос на поиск
class GetSearchResultAction extends SearchAction {
  final SearchFilter filter;
  final String keywords;

  GetSearchResultAction({required this.filter, required this.keywords});
}

/// результат поиска загружен
class LoadedSearchResultAction extends SearchAction {
  final List<Place> result;

  LoadedSearchResultAction(this.result);
}

/// получить историю поисковых запросов
class GetSearchHistoryAction extends SearchAction {}

/// история поисковых запросов загружена
class LoadedSearchHistoryAction extends SearchAction {
  final List<String> result;

  LoadedSearchHistoryAction(this.result);
}

/// удалить запрос из истории поиска
class RemoveRequestFromHistoryAction extends SearchAction {
  final int index;

  RemoveRequestFromHistoryAction(this.index);
}

/// очистить историю
class ClearHistorySearchAction extends SearchAction {}

/// ошибка
class SearchErrorAction extends SearchAction {}
