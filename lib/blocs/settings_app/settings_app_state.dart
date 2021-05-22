part of 'settings_app_cubit.dart';

/// состояние настроек пользователя
/// тема, первый старт
class SettingsAppState extends Equatable {
  final bool isDark;
  final bool isFirstStart;
  final bool isAppNotReady;

  const SettingsAppState({
    required this.isDark,
    required this.isFirstStart,
    this.isAppNotReady = true,
  });

  SettingsAppState copyWith({
    bool? isDark,
    bool? isFirstStart,
    bool? isAppNotReady,
  }) {
    return SettingsAppState(
      isDark: isDark ?? this.isDark,
      isFirstStart: isFirstStart ?? this.isFirstStart,
      isAppNotReady: isAppNotReady ?? this.isAppNotReady,
    );
  }

  @override
  List<Object> get props => [isDark, isFirstStart, isAppNotReady];
}
