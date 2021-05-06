import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:places/data/interactor/search_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:rxdart/rxdart.dart';

part 'search_event.dart';

part 'search_state.dart';

/// блок для экрана поиска
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchInteractor _searchInteractor;

  SearchBloc(this._searchInteractor) : super(LoadingSearchState());

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    /// получить историю поиска
    if (event is GetSearchHistory) {
      yield* _getSearchHistory();

      /// начат поиск на сервере
    } else if (event is GetSearchResult) {
      yield* _getSearchResult(event);

      /// удалить запрос из истории поиска
    } else if (event is RemoveRequestFromHistory) {
      yield* _removeRequestFromHistory(event);

      /// очистить историю поиска
    } else if (event is ClearSearchHistory) {
      yield* _clearSearchHistory();

      /// изменения в текстовом поле
    } else if (event is ChangedTextFieldSearch) {
      yield* _changedTextFieldSearch(event);

      /// запуск поиска при изменении текстового поля
    } else if (event is StartSearchFromTextField) {
      yield* _startSearchFromTextField(event);
    }
  }

  /// обрабатываем запрос данных к серверу
  Stream<SearchState> _getSearchResult(GetSearchResult event) async* {
    yield LoadingSearchState();

    try {
      // todo удалить позже
      print('-----старт поиска--------: ${event.keywords}');

      final placesList = await _searchInteractor.getSearchResult(
          filter: event.filter, keywords: event.keywords);

      yield LoadedSearchState(placesList);
    } catch (_) {
      yield FailureSearchState();
      rethrow;
    }
  }

  /// получаем историю поисковых запросов
  Stream<SearchState> _getSearchHistory() async* {
    yield LoadingSearchState();

    try {
      final result = await _searchInteractor.getSearchHistory();
      yield LoadedSearchHistoryState(result);
    } catch (_) {
      yield FailureSearchState();
      rethrow;
    }
  }

  /// очистить историю запросов
  Stream<SearchState> _clearSearchHistory() async* {
    _searchInteractor.clearSearchHistory();
    add(GetSearchHistory());
  }

  /// удалить конкретный запрос
  Stream<SearchState> _removeRequestFromHistory(
      RemoveRequestFromHistory event) async* {
    _searchInteractor.removeKeywords(event.index);
    add(GetSearchHistory());
  }

  /// для поиска при изменении текста в строке запроса
  // Input stream (search terms)
  final _searchTerms = BehaviorSubject<String>();

  void dispose() {
    _searchTerms.close();
  }

  /// изменение строки поиска
  Stream<SearchState> _changedTextFieldSearch(
      ChangedTextFieldSearch event) async* {
    _searchTerms.add(event.queryString);
    yield ChangedTextFieldSearchState();
  }

  /// запускаем поиск при изменении текста в поле
  Stream<SearchState> _startSearchFromTextField(
      StartSearchFromTextField event) async* {
    _searchTerms
        .debounceTime(Duration(milliseconds: 500))
        .listen((queryString) {
      add(GetSearchResult(filter: event.filter, keywords: queryString));
    });
  }
}
