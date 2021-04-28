import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:places/data/interactor/search_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/search_filter.dart';

part 'search_event.dart';

part 'search_state.dart';

/// блок для экрана поиска
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchInteractor _searchInteractor;

  SearchBloc(this._searchInteractor) : super(LoadingSearchState());

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is GetSearchHistory) {
      yield* _mapGetSearchHistoryToState();
    } else if (event is GetSearchResult) {
      yield* _mapGetSearchResultToState(event);
    } else if (event is RemoveRequestFromHistory) {
      yield* _mapRemoveRequestFromHistoryToState(event);
    } else if (event is ClearSearchHistory) {
      yield* _mapClearSearchHistoryToState();
    }
  }

  /// обрабатываем запрос данных к серверу
  Stream<SearchState> _mapGetSearchResultToState(GetSearchResult event) async* {
    yield LoadingSearchState();

    try {
      print('старт поиска');
      final placesList = await _searchInteractor.getSearchResult(
          filter: event.filter, keywords: event.keywords);
      print(placesList);
      yield LoadedSearchState(placesList);
    } catch (_) {
      yield FailureSearchState();
      rethrow;
    }
  }

  /// получаем историю поисковых запросов
  Stream<SearchState> _mapGetSearchHistoryToState() async* {
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
  Stream<SearchState> _mapClearSearchHistoryToState() async* {
    _searchInteractor.clearSearchHistory();
    add(GetSearchHistory());
  }

  /// удалить конкретный запрос
  Stream<SearchState> _mapRemoveRequestFromHistoryToState(
      RemoveRequestFromHistory event) async* {
    _searchInteractor.removeKeywords(event.index);
    add(GetSearchHistory());
  }
}
