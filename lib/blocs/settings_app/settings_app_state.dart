part of 'settings_app_cubit.dart';

/// состояние настроек пользователя
/// тема, первый старт
class SettingsAppState extends Equatable {
  final bool isDark;
  final bool isFirstStart;

  const SettingsAppState({
    required this.isDark,
    required this.isFirstStart,
  });

  SettingsAppState copyWith({
    bool? isDark,
    bool? isFirstStart,
  }) {
    return SettingsAppState(
      isDark: isDark ?? this.isDark,
      isFirstStart: isFirstStart ?? this.isFirstStart,
    );
  }

  @override
  List<Object> get props => [isDark, isFirstStart];
}
