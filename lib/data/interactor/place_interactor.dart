import 'package:places/data/api/api_client.dart';
import 'package:places/data/model/favorite_place.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/data/repository/api_place_repository.dart';
import 'package:places/data/repository/local_place_repository.dart';

/// бизнес-логика для работы с готовыми данными
/// [apiRepository] данные из сети
/// [localRepository] локальные данные
class PlaceInteractor {
  PlaceInteractor._();

  static final ApiPlaceRepository apiRepository = ApiPlaceRepository(ApiClient());
  static final LocalPlaceRepository localRepository = LocalPlaceRepository();

  /// фильтрованный список интересных мест
  static Future<List<Place>> getPlaces(SearchFilter filter) async {
    final places = await apiRepository.getPlaces(filter: filter);
    print('Interactor getPlaces: $places');

    return places;
  }

  /// детализация места
  static Future<Place> getPlaceDetails(int id) async {
    final place = await apiRepository.getPlaceDetail(id);
    print('Interactor getPlaceDetails: $place');

    return place;
  }

  static Future<void> addNewPlace(Place place) async {
    final newPlace = await apiRepository.addNewPlace(place);
    print('Interactor addNewPlace: $newPlace');

    return newPlace;
  }

  /// список избранных мест
  static Future<List<FavoritePlace>> getFavoritesPlaces() async {
    final places = await localRepository.getPlaces();
    print('Interactor getFavoritesPlaces: $places');

    return places;
  }

  /// детализация избранного места
  /// отличается от обычного места дополнительными полями
  /// и хранится в памяти пользователя
  static Future<Place> getFavoritePlaceDetails(int id) async {
    final place = await localRepository.getPlaceDetail(id);
    print('Interactor getFavoritePlaceDetails: $place');

    return place;
  }

  /// добавить место в список избранного
  static Future<FavoritePlace> addToFavorites(Place place) async {
    final newPlace = await localRepository.addNewPlace(place);
    print('Interactor addToFavorites: $newPlace');

    return newPlace;
  }

  /// удалить место из списка избранного
  static Future<void> removeFromFavorites(int id) async {
    await localRepository.removePlace(id);

    print('Interactor removeFromFavorites: $id');
  }

  /// показать посещенные места
  static Future<List<FavoritePlace>> getVisitPlaces() async {
    final places = await getFavoritesPlaces();
    places.where((element) => element.isVisited == true);

    return places;
  }

  /// добавить в посещенные
  static Future<void> addToVisitingPlaces(FavoritePlace place) async {
    final visitingPlace = FavoritePlace(
      id: place.id,
      lat: place.lat,
      lng: place.lng,
      name: place.name,
      urls: place.urls,
      placeType: place.placeType,
      description: place.description,
      distance: place.distance,
      isVisited: true,
      date: DateTime.now(),
    );

   await localRepository.updatePlace(visitingPlace);

   print('Interactor addToVisitingPlaces: $visitingPlace');
  }
}
