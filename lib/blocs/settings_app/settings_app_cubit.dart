import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:places/data/interactor/settings_interactor.dart';

part 'settings_app_state.dart';

/// кубит для состояния настроек пользователя
/// тема, первый старт
class SettingsAppCubit extends Cubit<SettingsAppState> {
  final SettingsInteractor _interactor;

  SettingsAppCubit(this._interactor)
      : super(SettingsAppState(isDark: false, isFirstStart: true));

  /// загружаем данные пользователя при входе в приложение
  Future<void> initState() async {
    final bool isDark = await _interactor.getTheme();
    final bool isFirstStart = await _interactor.getIsFirstStart();
    emit(SettingsAppState(isDark: isDark, isFirstStart: isFirstStart));
  }

  /// переключаем тему
  Future<void> toggleTheme(bool isDark) async {
    await _interactor.toggleTheme(isDark: isDark);
    emit(state.copyWith(isDark: isDark));
  }

  /// сохраняем первый запуск приложения
  Future<void> setIsFirstRun(bool isFirstRun) async{
    await _interactor.setIsFirstStart(isFirstRun);
    emit(state.copyWith(isFirstStart: false));
  }
}
