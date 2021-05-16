import 'package:places/data/model/search_filter.dart';
import 'package:places/data/repository/local_settings_repository.dart';

/// логика для работы с настройками пользователя
/// 1. тема
/// 2. фильтр
class SettingsInteractor {
  final LocalSettingsRepository _settingsRepository = LocalSettingsRepository();

  /// 1. тема: переключение текущей темы приложения
  // Future<void> toggleTheme() => _settingsRepository.toggleTheme();

  /// 1.1. получить тему
  Future<bool> getTheme() async => _settingsRepository.getTheme();

  /// 1.2. сохранить тему
  Future<void> saveTheme({required bool isDark}) async =>
      _settingsRepository.saveTheme(isDark: isDark);

  /// 1.2. переключить тему
  Future<void> toggleTheme({required bool isDark}) async =>
      _settingsRepository.saveTheme(isDark: isDark);

  /// 2.   фильтр
  /// 2.1. получить фильтр для поиска
  Future<SearchFilter> getSearchFilter() => _settingsRepository.getFilter();

  /// 2.2. обновить фильтр
  Future<void> updateSearchFilter({required SearchFilter newFilter}) =>
      _settingsRepository.updateFilter(newFilter: newFilter);
}
