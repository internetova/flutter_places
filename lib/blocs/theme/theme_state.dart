part of 'theme_cubit.dart';

/// состояние текущей темы пользователя
class ThemeState extends Equatable {
  final bool isDark;

  const ThemeState(this.isDark);

  @override
  List<Object> get props => [isDark];
}
