import 'package:places/data/model/place.dart';
import 'package:places/data/model/search_filter.dart';

/// Базовые функции для репозиториев
abstract class Repository {
  /// получить отфильтрованные места
  Future<List<Place>> getPlaces({SearchFilter filter});

  /// получить место по id
  Future<Place> getPlaceDetail(int id);

  /// добавить новое место
  Future<Place> addNewPlace(Place place);

  /// удалить место
  Future<void> removePlace(int id);

  /// обновить место
  Future<void> updatePlace(Place place);
}