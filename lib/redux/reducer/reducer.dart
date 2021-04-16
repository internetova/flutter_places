import 'package:places/redux/action/search_action.dart';
import 'package:places/redux/reducer/search_reducer.dart';
import 'package:places/redux/state/app_state.dart';
import 'package:redux/redux.dart';

/// основной редьюсер
final reducer = combineReducers<AppState>([
  TypedReducer<AppState, GetSearchResultAction>(getSearchResultReducer),
  TypedReducer<AppState, LoadedSearchResultAction>(loadedSearchResultReducer),
  TypedReducer<AppState, GetSearchHistoryAction>(getSearchHistoryReducer),
  TypedReducer<AppState, LoadedSearchHistoryAction>(loadedSearchHistoryReducer),
  TypedReducer<AppState, RemoveRequestFromHistoryAction>(removeRequestFromHistoryReducer),
  TypedReducer<AppState, ClearHistorySearchAction>(clearHistorySearchReducer),
  TypedReducer<AppState, SearchErrorAction>(searchErrorReducer),
]);