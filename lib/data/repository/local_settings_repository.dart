import 'package:places/data/local_storage/SharedPreferencesStorage.dart';
import 'package:places/data/model/search_filter.dart';

/// ЛОКАЛЬНЫЙ РЕПОЗИТОРИЙ НАСТРОЕК ПРОГРАММЫ
/// используется для:
/// 1. переключение темы приложения
/// 2. фильтр поиска
/// 3. первый запуск приложения
class LocalSettingsRepository {
  /// хранилище ключ-значение фильтра и др. настроек
  final SharedPreferencesStorage _preferencesStorage =
      SharedPreferencesStorage();

  /// 1.1. получить тему
  Future<bool> getTheme() async => _preferencesStorage.getTheme();

  /// 1.2. сохранить тему
  Future<void> setTheme({required bool isDark}) async =>
      _preferencesStorage.setTheme(isDark);

  /// 1.3. переключить тему
  Future<void> toggleTheme({required bool isDark}) async {
    if (isDark) {
      await setTheme(isDark: isDark);
    } else {
      await setTheme(isDark: !isDark);
    }
    print('isDark $isDark');
  }

  /// 2.   фильтр поиска
  /// 2.1. получить фильтр из базы
  Future<SearchFilter> getFilter() async =>
      _preferencesStorage.getSearchFilter();

  /// 2.2. обновим дефолтные настройки на данные юзера
  Future<void> updateFilter({required SearchFilter newFilter}) async =>
      _preferencesStorage.setSearchFilter(newFilter);

  /// 3.   первый запуск приложения
  /// 3.1. получить данные
  Future<bool> getIsFirstStart() async => _preferencesStorage.getIsFirstStart();

  /// 3.2. сохранить данные
  Future<void> setIsFirstStart(bool isFirstRun) async =>
      _preferencesStorage.setIsFirstStart(isFirstRun);
}
