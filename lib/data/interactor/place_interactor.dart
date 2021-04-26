import 'dart:async';

import 'package:dio/dio.dart';
import 'package:places/data/api/api_client.dart';
import 'package:places/data/dto/place_dto.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/data/local_storage/local_storage.dart';
import 'package:places/data/repository/api_place_repository.dart';
import 'package:places/data/repository/local_place_repository.dart';

/// интерактор для работы с местами
/// ГЛАВНАЯ СТРАНИЦА
/// [apiRepository] данные из сети
/// [localRepository] локальные данные
class PlaceInteractor {
  PlaceInteractor();

  final ApiPlaceRepository apiRepository = ApiPlaceRepository(ApiClient());
  final LocalPlaceRepository localRepository = LocalPlaceRepository();

  /// стрим контроллер для отфильтрованных мест
  final StreamController<List<Place>> _streamController =
      StreamController.broadcast();

  /// стрим для списка отфильтрованных мест
  /// добавим сюда данные после обработки "чистого" результата [getFilteredPlace]
  /// вызовем на главной странице
  Stream<List<Place>> get listPlaces => _streamController.stream;

  /// закрыть стрим
  void dispose() {
    _streamController.close();
  }

  /// фильтрованный список интересных мест в формате Dto
  /// на странице фильтра на кнопке надо выводить только количество найденных мест
  /// без какой-либо обработки, поэтому используем "чистый" результат
  Future<List<PlaceDto>> getPlaces({required SearchFilter filter}) async {
    /// получили данные из Api
    final placesDto = await (apiRepository.getPlaces(filter: filter));
    print('Interactor getPlaces (${placesDto.length} шт.): $placesDto');

    return placesDto;
  }

  /// производим обработку "чистого" результата: переводим данные из Dto в
  /// данные программы, сравниваем наличие мест в списке избранных и проставляем
  /// метки, всё это сохраняем в память типа кэш (база данных ❓) и отображаем
  /// на главной странице
  /// запрос только по фильтру
  /// (поиск по ключевым словам перенесен в [SearchInteractor])
  Future<List<Place>> getFilteredPlace(
      {required SearchFilter filter}) async {
    try {
      /// получили данные из Api
      final placesDto =
          await (apiRepository.getPlaces(filter: filter));
      print('Interactor getPlaces (${placesDto.length} шт.): $placesDto');

      /// трансформировали и записали в кэш
      List<Place> places = await _transformApiPlaces(placesDto);

      /// отсортировали по удаленности, дистанцию отдал сервер
      if (places.length > 1) {
        places.sort((a, b) => a.distance!.compareTo(b.distance!));
      }

      print('Interactor places из кэша (${places.length} шт.): $places');

      /// пушим в стрим
      _streamController.sink.add(places);

      return places;
    } on DioError catch (e) {
      throw apiRepository.getNetworkException(e,
          streamController: _streamController);
    }
  }

  /// ➡ вспомогательный метод
  /// отмечаем избранные карточки в общем списке
  /// сравниваем с локальной базой: если в ней есть, то ставим отметку
  /// записываем данные типа в кэш
  /// дальше в программе работаем с Place
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
    if (LocalStorage.cachePlaces.length > 0) {
      LocalStorage.cachePlaces.clear();
    }

    /// сохраняем данные с сервера в локальную память типа кэш
    LocalStorage.cachePlaces.addAll(uiPlaces);

    /// вернём данные из кэша для дальнейшей работы
    return LocalStorage.cachePlaces;
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
}
