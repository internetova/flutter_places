import 'package:places/data/local_storage/local_storage.dart';
import 'package:places/data/repository/local_place_repository.dart';

/// логика для работы с настройками пользователя
/// сохранение текущей темы приложения
class SettingsInteractor {
  SettingsInteractor._();

  /// доступ к локальной базе данных где сохраняются настройки
  /// сейчас это имитация - класс [LocalStorage]
  final LocalPlaceRepository localRepository = LocalPlaceRepository();

  static Future<void> toggleTheme() async {
    bool currentTheme = await LocalStorage.userSetting['isDarkTheme'];
    LocalStorage.userSetting['isDarkTheme'] = !currentTheme;

    print('isDarkTheme: ${LocalStorage.userSetting['isDarkTheme']}');
  }
}
