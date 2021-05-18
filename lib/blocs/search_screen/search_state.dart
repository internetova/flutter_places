part of 'search_bloc.dart';

/// стейт для экрана поиска
abstract class SearchState extends Equatable {
  const SearchState();
}

/// статус загрузки данных
class LoadingSearchState extends SearchState {
  @override
  List<Object?> get props => [];
}

/// результаты поиска загружены
class LoadedSearchState extends SearchState {
  final List<Place> result;

  LoadedSearchState(this.result);

  @override
  List<Object?> get props => [result];
}

/// результаты истории поиска загружены
class LoadedSearchHistoryState extends SearchState {
  final List<SearchHistoryItem> result;

  LoadedSearchHistoryState(this.result);

  @override
  List<Object?> get props => [result];
}

/// состояние ошибки
class FailureSearchState extends SearchState {
  @override
  List<Object?> get props => [];
}

/// состояние строки поиска
class ChangedTextFieldSearchState extends SearchState {
  @override
  List<Object?> get props => [];
}