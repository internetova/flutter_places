/// Базовые функции для репозиториев
abstract class PlaceRepository<T> {
  /// получить место по id
  Future<T> getPlaceDetail(int id);

  /// добавить новое место
  Future<void> addNewPlace(T place);

  /// удалить место
  Future<void> removePlace(T place);

  /// обновить место
  Future<void> updatePlace(T place);
}
