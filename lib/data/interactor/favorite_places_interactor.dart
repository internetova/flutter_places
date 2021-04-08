import 'dart:async';

import 'package:dio/dio.dart';
import 'package:places/data/api/api_client.dart';
import 'package:places/data/model/card_type.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/repository/api_place_repository.dart';
import 'package:places/data/repository/local_place_repository.dart';

/// интерактор для работы с Избранными местами
/// [apiRepository] данные из сети
/// [localRepository] локальные данные
class FavoritePlacesInteractor {
  FavoritePlacesInteractor();

  final ApiPlaceRepository apiRepository = ApiPlaceRepository(ApiClient());
  final LocalPlaceRepository localRepository = LocalPlaceRepository();

  /// стрим контроллер для избранных мест
  final StreamController<List<Place>> _streamController =
      StreamController.broadcast();

  /// стрим для списка избранных мест
  Stream<List<Place>> get listFavorites => _streamController.stream;

  /// закрыть стрим
  void dispose() {
    _streamController.close();
  }

  /// ИЗБРАННЫЕ МЕСТА
  /// сортировка по удалённости, данные с сервера
  Future<List<Place>> getFavoritesPlaces() async {
    List<Place> places = await localRepository.getPlaces();

    if (places.length > 1) {
      places.sort((a, b) => a.distance!.compareTo(b.distance!));
    }

    print('Interactor getFavoritesPlaces (${places.length} шт.): $places');

    return places;
  }

  /// Избранное вкладка Хочу посетить
  Future<List<Place>> getPlannedPlaces() async {
    try {
      List<Place> places = await localRepository.getPlannedPlaces();

      await apiRepository.testNetwork();

      print('Interactor getPlannedPlaces $places');

      /// пушим в стрим
      _streamController.sink.add(places);

      return places;
    } on DioError catch (e) {
      throw apiRepository.getNetworkException(e, streamController: _streamController);
    }
  }

  /// Избранное вкладка Посещённые места
  Future<List<Place>> getVisitedPlaces() async {
    try {
      List<Place> places = await localRepository.getVisitedPlaces();

      await apiRepository.testNetwork();

      print('Interactor getVisitedPlaces $places');

      /// пушим в стрим
      _streamController.sink.add(places);

      return places;
    } on DioError catch (e) {
      throw apiRepository.getNetworkException(e, streamController: _streamController);
    }
  }

  /// детализация избранного места
  /// отличается от обычного места дополнительными полями
  /// и хранится в памяти пользователя
  /// ‼️❓❓ наверное надо обновить данные затянув новые с сервера?
  /// ❓❓ вдруг там что-то изменилось
  Future<Place> getFavoritePlaceDetails(int id) async {
    final place = await localRepository.getPlaceDetail(id);
    final apiPlace = await apiRepository.getPlaceDetail(id);

    /// обновим данные на новые
    Place updatedPlace = Place.updateFromApi(place: place, apiPlace: apiPlace);

    /// запишем в базу данных
    await localRepository.updatePlace(updatedPlace);

    print('Interactor getFavoritePlaceDetails: $updatedPlace');

    return updatedPlace;
  }

  /// добавить в посещенные
  Future<void> addToVisitingPlaces(Place place) async {
    final visitingPlace = Place(
      id: place.id,
      lat: place.lat,
      lng: place.lng,
      name: place.name,
      urls: place.urls,
      placeType: place.placeType,
      description: place.description,
      distance: place.distance,
      isFavorite: true,
      cardType: CardType.visited,
      date: DateTime.now(),
    );

    await localRepository.updatePlace(visitingPlace);

    print('Interactor addToVisitingPlaces: $visitingPlace');
  }

  /// ➡ вспомогательный метод
  /// получить текущую дистанцию до места
  /// когда надо получить детальную информацию или обновить избранное,
  /// т.к. с сервера дистанция рассчитывается только при полностью
  /// заполненном фильтре сразу для списка мест
  double getDistance() {
    return 100.0; //todo сделать метод расчета
  }
}
