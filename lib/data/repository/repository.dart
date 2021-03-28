import 'package:places/data/model/search_filter.dart';

/// Базовые функции для репозиториев
abstract class Repository<T> {
  /// получить отфильтрованные места
  Future<List<T>> getPlaces({SearchFilter filter});

  /// получить место по id
  Future<T> getPlaceDetail(int id);

  /// добавить новое место
  Future<T> addNewPlace(T place);

  /// удалить место
  Future<void> removePlace(int id);

  /// обновить место
  Future<void> updatePlace(T place);
}