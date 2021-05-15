import 'package:places/data/model/search_filter.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// локальное хранилище с использованием SharedPreferences
class SharedPreferencesStorage {
  /// ключи для значений фильтра
  final String _keyRadius = 'keyRadius';
  final String _keyTypeFilter = 'keyTypeFilter';

  /// фильтр сохраняем
  Future<void> saveSearchFilter(SearchFilter filter) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble(_keyRadius, filter.radius);
    await prefs.setStringList(_keyTypeFilter, filter.typeFilter);
  }

  /// фильтр получаем
  Future<SearchFilter> getSearchFilter() async {
    final prefs = await SharedPreferences.getInstance();

    return SearchFilter(
        radius: prefs.getDouble(_keyRadius) ?? searchFilterRadius,
        typeFilter: prefs.getStringList(_keyTypeFilter) ?? searchFilterTypeFilter);
  }
}
