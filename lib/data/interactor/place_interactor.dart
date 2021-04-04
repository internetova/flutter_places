import 'package:places/data/model/card_type.dart';
import 'package:places/data/api/api_client.dart';
import 'package:places/data/dto/place_dto.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/data/local_storage/local_storage.dart';
import 'package:places/data/repository/api_place_repository.dart';
import 'package:places/data/repository/local_place_repository.dart';

/// бизнес-логика для работы с местами
/// [apiRepository] данные из сети
/// [localRepository] локальные данные
class PlaceInteractor {
  PlaceInteractor();

  final ApiPlaceRepository apiRepository = ApiPlaceRepository(ApiClient());
  final LocalPlaceRepository localRepository = LocalPlaceRepository();

  /// фильтрованный список интересных мест
  Future<List<Place>> getPlaces({SearchFilter? userFilter}) async {
    /// получили данные из Api
    final places = await (apiRepository.getPlaces(userFilter: userFilter));
    print('Interactor getPlaces (${places.length} шт.): $places');

    /// трансформировали и записали в кэш
    List<Place> uiPlaces = await _transformApiPlaces(places);

    /// отсортировали по удаленности, дистанцию отдал сервер
    if (uiPlaces.length > 1) {
      uiPlaces.sort((a, b) => a.distance!.compareTo(b.distance!));
    }

    print('Interactor uiPlaces из кэша (${uiPlaces.length} шт.): $uiPlaces');

    return uiPlaces;
  }

  /// ➡ вспомогательный метод
  /// отмечаем избранные карточки в общем списке
  /// сравниваем с локальной базой: если в ней есть, то ставим отметку
  /// записываем данные типа в кэш
  /// дальше в программе работаем с UiPlace
  Future<List<Place>> _transformApiPlaces(List<PlaceDto> apiPlaces) async {
    final localPlaces = await localRepository.getPlaces();
    List<Place> uiPlaces = [];

    /// если в локальной базе карточек нет, то для дальнейшей работы
    /// просто переводим все карточки в UiPlace
    if (localPlaces.length == 0) {
      uiPlaces = apiPlaces.map((place) => Place.fromApi(place)).toList();
    } else {
      /// если есть, то проставляем отметки Избранное / или нет
      uiPlaces =
          apiPlaces.map((place) => _markFavorites(localPlaces, place)).toList();
    }

    /// если в кэше уже есть карточки, очищаем кэш для обновленных данных
    if (LocalStorage.cacheUIPlaces.length > 0) {
      LocalStorage.cacheUIPlaces.clear();
    }

    /// сохраняем данные с сервера в локальную память типа кэш
    LocalStorage.cacheUIPlaces.addAll(uiPlaces);

    /// вернём данные из кэша для дальнейшей работы
    return LocalStorage.cacheUIPlaces;
  }

  /// ➡ вспомогательный метод:
  /// при запросе данных с сервера проверяет в локальном списке избранных
  /// есть ли там аналогичная карточка
  Place _markFavorites(List<Place> listFavorites, PlaceDto place) {
    for (var i = 0; i < listFavorites.length; i++) {
      if (listFavorites[i].id == place.id) {
        return Place.fromApi(place, isFavorite: true);
      }
    }

    return Place.fromApi(place);
  }

  /// детализация места
  Future<PlaceDto> getPlaceDetails(int id) async {
    final place = await apiRepository.getPlaceDetail(id);
    print('Interactor getPlaceDetails: $place');

    return place;
  }

  /// добавить новое место на сервер
  Future<void> addNewPlace(PlaceDto place) async {
    final newPlace = await apiRepository.addNewPlace(place);
    print('Interactor addNewPlace: $newPlace');
  }

  /// список избранных мест
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
    List<Place> places = await localRepository.getPlaces()
      ..where((place) => place.cardType == CardType.planned).toList();

    print('Interactor getPlannedPlaces $places');

    return places;
  }

  /// Избранное вкладка Посещённые места
  Future<List<Place>> getVisitedPlaces() async {
    List<Place> places = await localRepository.getPlaces()
      ..where((place) => place.cardType == CardType.visited).toList();

    print('Interactor getVisitedPlaces $places');

    return places;
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
    Place updatedPlace =
        Place.updateFromApi(place: place, apiPlace: apiPlace);

    /// запишем в базу данных
    await localRepository.updatePlace(updatedPlace);

    print('Interactor getFavoritePlaceDetails: $updatedPlace');

    return updatedPlace;
  }

  /// добавить место в список избранного
  /// ❓ а может void? дальше посмотрю
  Future<Place> addToFavorites(Place place) async {
    final newPlace = await localRepository.addNewPlace(place);
    print('Interactor addToFavorites: $newPlace');

    return newPlace;
  }

  /// удалить место из списка избранного
  Future<void> removeFromFavorites(int id) async {
    await localRepository.removePlace(id);

    print('Interactor removeFromFavorites: $id');
  }

  /// переключатель кнопки Избранное
  /// true - в избранном
  Future<bool> toggleFavorites(Place place) async {
    return await localRepository.toggleFavorite(place);
  }

  /// показать посещенные места
  Future<List<Place>> getVisitPlaces() async {
    final places = await getFavoritesPlaces()
      ..where((element) => element.cardType == CardType.visited);

    return places;
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

  /// ПОИСК
  /// сохранить поисковое выражение в историю запросов
  Future<void> saveKeywords(String keywords) async {
    localRepository.saveKeywords(keywords);
  }

  /// удалить запрос
  Future<void> removeKeywords(int i) async {
    localRepository.removeKeywords(i);
  }

  /// очистить историю
  Future<void> clearSearchHistory() async {
    localRepository.clearSearchHistory();
  }

  /// получить историю запросов
  Future<List<String>> getSearchHistory() async {
    return localRepository.getSearchHistory();
  }
}
