part of 'settings_app_cubit.dart';

/// состояние настроек пользователя получаем из SharedPreferences
/// тема, первый старт, настройки фильтра
class SettingsAppState extends Equatable {
  final bool isDark;
  final bool isFirstStart;
  final SearchFilter searchFilter;
  final bool isAppNotReady;

  const SettingsAppState({
    required this.isDark,
    required this.isFirstStart,
    required this.searchFilter,
    this.isAppNotReady = true,
  });

  SettingsAppState copyWith({
    bool? isDark,
    bool? isFirstStart,
    SearchFilter? searchFilter,
    bool? isAppNotReady,
  }) {
    return SettingsAppState(
      isDark: isDark ?? this.isDark,
      isFirstStart: isFirstStart ?? this.isFirstStart,
      searchFilter: searchFilter ?? this.searchFilter,
      isAppNotReady: isAppNotReady ?? this.isAppNotReady,
    );
  }

  @override
  List<Object> get props => [isDark, isFirstStart, searchFilter, isAppNotReady];
}
