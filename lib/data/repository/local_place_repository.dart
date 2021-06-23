import 'package:places/data/database/database.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/search_history_item.dart';
import 'package:places/data/repository/place_repository.dart';

/// ЛОКАЛЬНЫЙ РЕПОЗИТОРИЙ МЕСТ
/// [AppDb] база с пользовательскими данными
class LocalPlaceRepository implements PlaceRepository<Place> {
  final AppDb _appDb;

  LocalPlaceRepository(this._appDb);

  /// получить все избранные (хочу посетить / посетил)
  Future<List<Place>> getFavoritesPlaces() async {
    List<Favorites> rows = await _appDb.getFavoritesPlaces();
    List<Place> places = [];

    rows.forEach((row) => places.add(row.place));

    return places;
  }

  /// получить кэшированный список мест
  /// это данные, которые были сохранены локально после обращения к серверу
  Future<List<Place>> getCachePlaces() async {
    List<CachePlaces> rows = await _appDb.getCachePlaces();
    List<Place> places = [];

    rows.forEach((row) => places.add(row.place));

    return places;
  }

  /// добавить список мест в кэш
  Future<void> addCachePlacesAll(List<Place> places) =>
      _appDb.addCachePlacesAll(places);

  /// очистить кэшированный список мест
  Future<void> clearCachePlaces() => _appDb.clearCachePlaces();

  /// получить запланированные места
  Future<List<Place>> getPlannedPlaces() async {
    List<Favorites> rows = await _appDb.getPlannedPlaces();
    List<Place> places = [];

    rows.forEach((row) => places.add(row.place));

    return places;
  }

  /// получить посещенные места
  Future<List<Place>> getVisitedPlaces() async {
    List<Favorites> rows = await _appDb.getVisitedPlaces();
    List<Place> places = [];

    rows.forEach((row) => places.add(row.place));

    return places;
  }

  /// получить избранное место по id
  @override
  Future<Place> getPlaceDetail(int id) async {
    Favorites placeRow = await _appDb.getFavoritesItem(id);
    final Place place = placeRow.place;

    return place;
  }

  /// добавить в избранное Хочу посетить
  @override
  Future<void> addNewPlace(Place place) async {
    await _appDb.addToFavorites(place);
    await _appDb.updateCachePlacesItem(place);
  }

  /// удалить из избранного
  @override
  Future<void> removePlace(Place place) async {
    await _appDb.removeFromFavorites(place);
    await _appDb.updateCachePlacesItem(place);
  }

  /// переключатель кнопки Избранное
  Future<bool> toggleFavorite(Place place) async {
    if (place.isFavorite) {
      await addNewPlace(place);
      return false;
    } else {
      await removePlace(place);
      return true;
    }
  }

  /// обновить избранное (например, дату посещения перепланировать,
  /// перенести в посещённые)
  @override
  Future<void> updatePlace(Place place) => _appDb.updateFavoritesPlace(place);

  /// ПОИСК
  /// сохранить поисковое выражение в историю запросов
  Future<void> saveSearchRequest(String request) async {
    List<SearchHistory> rows = await _appDb.checkSearchRequest(request);

    if (rows.isEmpty) {
      _appDb.saveSearchRequest(request);
    }
  }

  /// удалить запрос
  Future<void> deleteSearchRequest(int id) => _appDb.deleteSearchRequest(id);

  /// очистить историю
  Future<void> clearSearchHistory() async => _appDb.clearSearchHistory();

  /// получить историю запросов
  Future<List<SearchHistoryItem>> getSearchHistory() async {
    List<SearchHistory> rows = await _appDb.getSearchHistory();

    return rows
        .map((row) => SearchHistoryItem(id: row.id, request: row.request))
        .toList();
  }
}
