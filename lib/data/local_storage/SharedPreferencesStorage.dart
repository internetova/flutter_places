import 'package:places/data/model/search_filter.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// локальное хранилище с использованием SharedPreferences
class SharedPreferencesStorage {
  SharedPreferences? _prefs;

  /// ключи для значений фильтра
  final String _keyRadius = 'keyRadius';
  final String _keyTypeFilter = 'keyTypeFilter';

  /// ключи для значений темы
  final String _keyThemeIsDark = 'keyThemeIsDark';

  /// первый запуск приложения
  final String _keyIsFirstStart = '_keyIsFirstStart';

  /// загружаем и анализируем данные с диска
  _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// фильтр сохраняем
  Future<void> setSearchFilter(SearchFilter filter) async {
    await _initPrefs();

    await _prefs?.setDouble(_keyRadius, filter.radius);
    await _prefs?.setStringList(_keyTypeFilter, filter.typeFilter);
  }

  /// фильтр получаем
  Future<SearchFilter> getSearchFilter() async {
    await _initPrefs();

    return SearchFilter(
        radius: _prefs?.getDouble(_keyRadius) ?? searchFilterRadius,
        typeFilter: _prefs?.getStringList(_keyTypeFilter) ?? searchFilterTypeFilter);
  }

  /// тема сохраняем
  Future<void> setTheme(bool isDark) async {
    await _initPrefs();
    await _prefs?.setBool(_keyThemeIsDark, isDark);
  }

  /// тема получаем
   Future<bool> getTheme() async {
    await _initPrefs();
    return _prefs?.getBool(_keyThemeIsDark) ?? false;
  }

  /// Первый запуск приложения [isFirstStart] сохраняем
  /// после первого запуска и просмотра туториала по кнопке ставим false, чтобы
  /// при следующем запуске туториал не показывался
  Future<void> setIsFirstStart(bool isFirstRun) async {
    await _initPrefs();
    await _prefs?.setBool(_keyIsFirstStart, isFirstRun);
  }

  /// Первый запуск приложения [isFirstStart]  получаем
  Future<bool> getIsFirstStart() async {
    await _initPrefs();
    return _prefs?.getBool(_keyIsFirstStart) ?? true;
  }
}
