import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:places/data/interactor/settings_interactor.dart';

part 'theme_state.dart';

/// кубит для темы
class ThemeCubit extends Cubit<ThemeState> {
  final SettingsInteractor _interactor;

  ThemeCubit(this._interactor) : super(ThemeState(false));

  /// загружаем данные пользователя при входе в приложение
  Future<void> initState() async {
    final bool isDark = await _interactor.getTheme();
    emit(ThemeState(isDark));
  }

  Future<void> toggleTheme(bool isDark) async{
    await _interactor.toggleTheme(isDark: isDark);
    emit(ThemeState(isDark));
  }
}
