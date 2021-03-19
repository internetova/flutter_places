import 'package:places/data/model/coordinates.dart';

/// ‼️ временно
/// имитация локального хранилища
/// сохраним тут текущую локацию пользователя
/// сохраним тут список избранных мест
/// сохраним тут настройки пользователя
class LocalStorage {
  static Coordinates userLocation = Coordinates(lat: 55.994909, lng: 37.606793);
}
