import 'package:places/redux/state/search_state.dart';
/// Redux Шаг 3. Добавить состояние конкретного экрана в список общих состояний
///
/// состояние приложения
/// тут пока только состояние экрана поиска
class AppState {
  final SearchState searchState;

  AppState({this.searchState = const SearchInitialState()});

  /// делает новую копию состояния в случае изменения
  AppState copyWith({SearchState? searchState}) =>
      AppState(searchState: searchState ?? this.searchState);
}
