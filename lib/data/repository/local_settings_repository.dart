import 'package:places/data/local_storage/SharedPreferencesStorage.dart';
import 'package:places/data/model/search_filter.dart';

/// ЛОКАЛЬНЫЙ РЕПОЗИТОРИЙ НАСТРОЕК ПРОГРАММЫ
/// используется для:
/// 1. переключение темы приложения
/// 2. фильтр поиска
class LocalSettingsRepository {
  /// хранилище ключ-значение фильтра и др. настроек
  final SharedPreferencesStorage _preferencesStorage =
      SharedPreferencesStorage();

  /// 1. настройка темы приложения
  /// сохранить настройки и переключить тему
  // Future<void> toggleTheme() async {
  //   bool currentTheme = await LocalStorage.userSetting['isDarkTheme'];
  //   LocalStorage.userSetting['isDarkTheme'] = !currentTheme;
  //
  //   print('isDarkTheme: ${LocalStorage.userSetting['isDarkTheme']}');
  // }

  /// 1.1. получить тему
  Future<bool> getTheme() async => _preferencesStorage.getTheme();

  /// 1.2. сохранить тему
  Future<void> saveTheme({required bool isDark}) async =>
      _preferencesStorage.saveTheme(isDark);

  /// 1.3. переключить тему
  Future<void> toggleTheme({required bool isDark}) async {
    if (isDark) {
      await saveTheme(isDark: isDark);
    } else {
      await saveTheme(isDark: !isDark);
    }
    print('isDark $isDark');
  }

  /// 2.   фильтр поиска
  /// 2.1. получить фильтр из базы
  Future<SearchFilter> getFilter() async =>
      _preferencesStorage.getSearchFilter();

  /// 2.2. обновим дефолтные настройки на данные юзера
  Future<void> updateFilter({required SearchFilter newFilter}) async =>
      _preferencesStorage.saveSearchFilter(newFilter);
}
