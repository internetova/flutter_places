import 'package:places/data/api/api_client.dart';
import 'package:places/data/local_storage/local_storage.dart';
import 'package:places/data/model/ui_place.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/data/repository/api_place_repository.dart';
import 'package:places/data/repository/local_place_repository.dart';
import 'package:places/domain/card_type.dart';

/// бизнес-логика для работы с местами
/// [apiRepository] данные из сети
/// [localRepository] локальные данные
class PlaceInteractor {
  PlaceInteractor();

  final ApiPlaceRepository apiRepository = ApiPlaceRepository(ApiClient());
  final LocalPlaceRepository localRepository = LocalPlaceRepository();

  /// фильтрованный список интересных мест
  /// если юзер не задал фильтр, то берём дефолтный
  Future<List<UiPlace>> getPlaces({SearchFilter userFilter}) async {
    SearchFilter filter =
        userFilter == null ? LocalStorage.defaultSearchFilter : userFilter;

    /// получили данные из Api
    final places = await apiRepository.getPlaces(filter: filter);
    print('Interactor getPlaces (${places.length} шт.): $places');

    /// трансформировали и записали в кэш
    List<UiPlace> uiPlaces = await _transformApiPlaces(places);

    /// отсортировали по удаленности, дистанцию отдал сервер
    if (uiPlaces.length > 1) {
      uiPlaces.sort((a, b) => a.distance.compareTo(b.distance));
    }

    print('Interactor uiPlaces из кэша (${uiPlaces.length} шт.): $uiPlaces');

    return uiPlaces;
  }

  /// ➡ вспомогательный метод
  /// отмечаем избранные карточки в общем списке
  /// сравниваем с локальной базой: если в ней есть, то ставим отметку
  /// записываем данные типа в кэш
  /// дальше в программе работаем с UiPlace
  Future<List<UiPlace>> _transformApiPlaces(List<Place> apiPlaces) async {
    final localPlaces = await localRepository.getPlaces();
    List<UiPlace> uiPlaces;

    /// если в локальной базе карточек нет, то для дальнейшей работы
    /// просто переводим все карточки в UiPlace
    if (localPlaces.length == 0) {
      uiPlaces = apiPlaces.map((place) => UiPlace.fromPlace(place)).toList();
    } else {
      /// если есть, то проставляем отметки Избранное / или нет
      uiPlaces = apiPlaces.map((place) {
        for (var i = 0; i < localPlaces.length; i++) {
          if (localPlaces[i].id == place.id) {
            return UiPlace.fromPlace(place, isFavorite: true);
          } else {
            return UiPlace.fromPlace(place);
          }
        }
      }).toList();
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

  /// детализация места
  Future<Place> getPlaceDetails(int id) async {
    final place = await apiRepository.getPlaceDetail(id);
    print('Interactor getPlaceDetails: $place');

    return place;
  }

  /// добавить новое место на сервер
  Future<void> addNewPlace(Place place) async {
    final newPlace = await apiRepository.addNewPlace(place);
    print('Interactor addNewPlace: $newPlace');

    return newPlace;
  }

  /// список избранных мест
  /// сортировка по удалённости, данные с сервера
  Future<List<UiPlace>> getFavoritesPlaces() async {
    List<UiPlace> places = await localRepository.getPlaces();

    if (places.length > 1) {
      places.sort((a, b) => a.distance.compareTo(b.distance));
    }

    print('Interactor getFavoritesPlaces (${places.length} шт.): $places');

    return places;
  }

  /// Избранное вкладка Хочу посетить
  Future<List<UiPlace>> getPlannedPlaces() async {
    List<UiPlace> places = await localRepository.getPlaces();
    List<UiPlace> planed =
        places.where((place) => place.cardType == CardType.planned).toList();
    print('Interactor getPlannedPlaces $planed');

    return planed;
  }

  /// Избранное вкладка Посещённые места
  Future<List<UiPlace>> getVisitedPlaces() async {
    List<UiPlace> places = await localRepository.getPlaces();
    List<UiPlace> visited =
        places.where((place) => place.cardType == CardType.visited).toList();
    print('Interactor getVisitedPlaces $visited');

    return visited;
  }

  /// детализация избранного места
  /// отличается от обычного места дополнительными полями
  /// и хранится в памяти пользователя
  /// ‼️❓❓ наверное надо обновить данные затянув новые с сервера?
  /// ❓❓ вдруг там что-то изменилось
  Future<UiPlace> getFavoritePlaceDetails(int id) async {
    final place = await localRepository.getPlaceDetail(id);
    final apiPlace = await apiRepository.getPlaceDetail(id);

    /// обновим данные на новые
    UiPlace updatedPlace =
        UiPlace.updateFromApi(localPlace: place, apiPlace: apiPlace);

    /// запишем в базу данных
    await localRepository.updatePlace(updatedPlace);

    print('Interactor getFavoritePlaceDetails: $updatedPlace');

    return updatedPlace;
  }

  /// добавить место в список избранного
  /// ❓ а может void? дальше посмотрю
  Future<UiPlace> addToFavorites(UiPlace place) async {
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
  Future<bool> toggleFavorites(UiPlace place) async {
    final response = await localRepository.getPlaceDetail(place.id);

    if (response != null) {
      await removeFromFavorites(place.id);
      print('Interactor toggleFavorites: удалено из избранного ${place.id}');

      /// пока для теста в консоли
      getFavoritesPlaces();

      return false;
    } else {
      await addToFavorites(place);
      print('Interactor toggleFavorites: добавлено в избранное ${place.id}');

      /// пока для теста в консоли
      getFavoritesPlaces();

      return true;
    }
  }

  /// показать посещенные места
  Future<List<UiPlace>> getVisitPlaces() async {
    final places = await getFavoritesPlaces();
    places.where((element) => element.cardType == CardType.visited);

    return places;
  }

  /// добавить в посещенные
  Future<void> addToVisitingPlaces(UiPlace place) async {
    final visitingPlace = UiPlace(
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
