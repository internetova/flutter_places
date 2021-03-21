import 'package:places/data/model/coordinates.dart';
import 'package:places/data/model/place.dart';

/// ‼️ временно
/// имитация локального хранилища
/// сохраним тут текущую локацию пользователя
/// сохраним тут список избранных мест
/// сохраним тут историю поиска пользователя
/// сохраним тут настройки пользователя
class LocalStorage {
  LocalStorage._();

  /// локация пользователя
  static Coordinates userLocation = Coordinates(lat: 55.994909, lng: 37.606793);

  /// список избранных мест
  static List<Place> favoritesPlaces = [];
}
