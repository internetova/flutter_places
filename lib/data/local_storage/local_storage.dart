import 'package:places/data/model/coordinates.dart';
/// todo удалить после реализации
/// ‼️ временно
/// имитация локального хранилища
/// храним:
/// 1. текущую геолокацию пользователя
/// Всё остальное перенесла в базу данных
class LocalStorage {
  LocalStorage._();

  /// 1. Геолокация пользователя
  static Coordinates userLocation = Coordinates(lat: 55.994909, lng: 37.606793);
}
