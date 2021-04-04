import 'package:places/data/model/search_filter.dart';
import 'package:places/data/repository/local_settings_repository.dart';

/// логика для работы с настройками пользователя
/// 1. тема
/// 2. фильтр
class SettingsInteractor {
  SettingsInteractor._();

  static final LocalSettingsRepository _settingsRepository =
      LocalSettingsRepository();

  /// 1. тема: переключение текущей темы приложения
  static Future<void> toggleTheme() async =>
      await _settingsRepository.toggleTheme();

  /// 2.   фильтр
  /// 2.1. получить фильтр для поиска
  static Future<SearchFilter> getSearchFilter() async =>
      await _settingsRepository.getFilter();

  /// 2.2. обновить фильтр
  static Future<void> updateSearchFilter(
          {required SearchFilter newFilter}) async =>
      await _settingsRepository.updateFilter(newFilter: newFilter);
}
