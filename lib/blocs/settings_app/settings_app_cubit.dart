import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:places/data/interactor/settings_interactor.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/ui/res/sizes.dart';

part 'settings_app_state.dart';

/// кубит для состояния настроек пользователя
/// тема, первый старт, настройки фильтра
class SettingsAppCubit extends Cubit<SettingsAppState> {
  final SettingsInteractor _interactor;

  SettingsAppCubit(this._interactor)
      : super(
          SettingsAppState(
            isDark: false,
            isFirstStart: true,
            searchFilter: SearchFilter(
              radius: searchFilterRadius,
              typeFilter: searchFilterTypeFilter,
            ),
          ),
        );

  /// загружаем данные пользователя при входе в приложение
  Future<void> initState() async {
    final bool isDark = await _interactor.getTheme();
    final bool isFirstStart = await _interactor.getIsFirstStart();
    final SearchFilter searchFilter = await _interactor.getSearchFilter();

    emit(SettingsAppState(
      isDark: isDark,
      isFirstStart: isFirstStart,
      searchFilter: searchFilter,
      isAppNotReady: false,
    ));
  }

  /// переключаем тему
  Future<void> toggleTheme(bool isDark) async {
    await _interactor.setTheme(isDark: isDark);
    emit(state.copyWith(isDark: isDark));
  }

  /// сохраняем первый запуск приложения
  Future<void> setIsFirstRun(bool isFirstRun) async {
    await _interactor.setIsFirstStart(isFirstRun);
    emit(state.copyWith(isFirstStart: false));
  }

  /// обновить настройки фильтр поиска
  Future<void> updateSearchFilter(SearchFilter searchFilter) async {
    await _interactor.updateSearchFilter(newFilter: searchFilter);
    emit(state.copyWith(searchFilter: searchFilter));
  }
}
