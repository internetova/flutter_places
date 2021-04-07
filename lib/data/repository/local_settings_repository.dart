import 'package:places/data/local_storage/local_storage.dart';
import 'package:places/data/model/search_filter.dart';

/// ЛОКАЛЬНЫЙ РЕПОЗИТОРИЙ НАСТРОЕК ПРОГРАММЫ
/// для имитации локального хранилища используется класс [LocalStorage]
/// используется для:
/// 1. переключение темы приложения
/// 2. фильтр поиска
class LocalSettingsRepository {
  /// 1. настройка темы приложения
  /// сохранить настройки и переключить тему
  Future<void> toggleTheme() async {
    bool currentTheme = await LocalStorage.userSetting['isDarkTheme'];
    LocalStorage.userSetting['isDarkTheme'] = !currentTheme;

    print('isDarkTheme: ${LocalStorage.userSetting['isDarkTheme']}');
  }

  /// 2.   фильтр поиска
  /// 2.1. получить фильтр из базы
  Future<SearchFilter> getFilter() async {
    return LocalStorage.searchFilter;
  }

  /// 2.2. обновим дефолтные настройки на данные юзера
  Future<void> updateFilter({required SearchFilter newFilter}) async {
    LocalStorage.searchFilter = newFilter;
  }
}
