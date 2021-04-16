import 'package:places/data/model/place.dart';
/// Redux Шаг 2. Описать состояния экрана
///
/// базовое состояние экрана Поиск
abstract class SearchState {
  const SearchState();
}

/// состояние инициализации
class SearchInitialState extends SearchState {
  const SearchInitialState();
}

/// состояние загрузки:
/// отправлен поисковый запрос,
/// запрошена история поисковых запросов,
/// очистка истории запросов или удаление одиночных запросов
class SearchLoadingState extends SearchState {
  const SearchLoadingState();
}

/// результаты поиска загружены
class SearchResultState extends SearchState {
  final List<Place> result;

  const SearchResultState(this.result);
}

/// результаты истории поиска загружены
class SearchResultHistoryState extends SearchState {
  final List<String> result;

  const SearchResultHistoryState(this.result);
}

/// получена ошибка
class SearchErrorState extends SearchState {
  const SearchErrorState();
}
