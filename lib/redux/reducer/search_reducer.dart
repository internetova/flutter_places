import 'package:places/redux/action/search_action.dart';
import 'package:places/redux/state/app_state.dart';
import 'package:places/redux/state/search_state.dart';

/// Редьюсер экрана поиска.
/// Вернуть состояние загрузки результатов запроса
AppState getSearchResultReducer(AppState state, GetSearchResultAction action) =>
    state.copyWith(searchState: const SearchLoadingState());

/// Вернуть результат запроса
AppState loadedSearchResultReducer(
        AppState state, LoadedSearchResultAction action) =>
    state.copyWith(searchState: SearchResultState(action.result));

/// Вернуть состояние загрузки истории поисковых запросов
AppState getSearchHistoryReducer(
        AppState state, GetSearchHistoryAction action) =>
    state.copyWith(searchState: const SearchLoadingState());

/// Вернуть результат загрузки истории поисковых запросов
AppState loadedSearchHistoryReducer(
        AppState state, LoadedSearchHistoryAction action) =>
    state.copyWith(searchState: SearchResultHistoryState(action.result));

/// Вернуть результат загрузки удаления запроса из истории
AppState removeRequestFromHistoryReducer(
    AppState state, RemoveRequestFromHistoryAction action) =>
    state.copyWith(searchState: const SearchLoadingState());

/// Вернуть результат загрузки очистки истории поисковых запросов
AppState clearHistorySearchReducer(
    AppState state, ClearHistorySearchAction action) =>
    state.copyWith(searchState: const SearchLoadingState());

/// Состояние ошибки
AppState searchErrorReducer(
    AppState state, SearchErrorAction action) =>
    state.copyWith(searchState: const SearchErrorState());
