part of 'settings_app_cubit.dart';

/// состояние настроек пользователя
/// тема, первый старт
class SettingsAppState extends Equatable {
  final bool isDark;
  final bool isFirstStart;
  final bool isAppReady;

  const SettingsAppState({
    required this.isDark,
    required this.isFirstStart,
    this.isAppReady = false,
  });

  SettingsAppState copyWith({
    bool? isDark,
    bool? isFirstStart,
    bool? isAppReady,
  }) {
    return SettingsAppState(
      isDark: isDark ?? this.isDark,
      isFirstStart: isFirstStart ?? this.isFirstStart,
      isAppReady: isAppReady ?? this.isAppReady,
    );
  }

  @override
  List<Object> get props => [isDark, isFirstStart, isAppReady];
}
