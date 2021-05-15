import 'package:places/data/model/search_filter.dart';
import 'package:places/data/repository/local_settings_repository.dart';

/// логика для работы с настройками пользователя
/// 1. тема
/// 2. фильтр
class SettingsInteractor {
  final LocalSettingsRepository _settingsRepository =
      LocalSettingsRepository();

  /// 1. тема: переключение текущей темы приложения
  Future<void> toggleTheme() => _settingsRepository.toggleTheme();

  /// 2.   фильтр
  /// 2.1. получить фильтр для поиска
  Future<SearchFilter> getSearchFilter() => _settingsRepository.getFilter();

  /// 2.2. обновить фильтр
  Future<void> updateSearchFilter({required SearchFilter newFilter}) =>
      _settingsRepository.updateFilter(newFilter: newFilter);
}
