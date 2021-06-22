import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:places/data/dto/place_dto.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/data/model/object_position.dart';
import 'package:places/data/repository/api_place_repository.dart';
import 'package:places/data/repository/local_place_repository.dart';

/// интерактор для работы с местами
/// ГЛАВНАЯ СТРАНИЦА
/// [apiRepository] данные из сети
/// [localRepository] локальные данные
class PlaceInteractor {
  final ApiPlaceRepository apiRepository;
  final LocalPlaceRepository localRepository;

  PlaceInteractor({
    required this.apiRepository,
    required this.localRepository,
  });

  /// фильтрованный список интересных мест в формате Dto
  /// на странице фильтра на кнопке надо выводить только количество найденных мест
  /// без какой-либо обработки, поэтому используем "чистый" результат
  Future<List<PlaceDto>> getPlaces({
    required ObjectPosition userLocation,
    required SearchFilter filter,
  }) =>
      apiRepository.getPlaces(
        userLocation: userLocation,
        filter: filter,
      );

  /// производим обработку "чистого" результата: переводим данные из Dto в
  /// данные программы, сравниваем наличие мест в списке избранных и проставляем
  /// метки, всё это сохраняем в память типа кэш (база данных ❓) и отображаем
  /// на главной странице
  /// запрос только по фильтру
  /// (поиск по ключевым словам перенесен в [SearchInteractor])
  Future<List<Place>> getFilteredPlace({
    required ObjectPosition userLocation,
    required SearchFilter filter,
  }) async {
    try {
      /// получили данные из Api
      final placesDto = await apiRepository.getPlaces(
        userLocation: userLocation,
        filter: filter,
      );

      /// трансформировали и записали в кэш
      List<Place> places = await _transformApiPlaces(placesDto);

      /// отсортировали по удаленности, дистанцию отдал сервер
      if (places.length > 1) {
        places.sort((a, b) => a.distance!.compareTo(b.distance!));
      }

      return places;
    } on DioError catch (e) {
      throw apiRepository.getNetworkException(e);
    }
  }

  /// запросить все места без фильтра если нет доступа к геолокации
  Future<List<Place>> getAllPlace() async {
    try {
      /// получили данные из Api
      final placesDto = await apiRepository.getAllPlaces();

      /// трансформировали и записали в кэш
      List<Place> places = await _transformApiPlaces(placesDto);

      return places;
    } on DioError catch (e) {
      throw apiRepository.getNetworkException(e);
    }
  }

  /// ➡ вспомогательный метод
  /// отмечаем избранные карточки в общем списке
  /// сравниваем с локальной базой: если в ней есть, то ставим отметку
  /// записываем данные типа в кэш
  /// дальше в программе работаем с Place
  Future<List<Place>> _transformApiPlaces(List<PlaceDto> apiPlaces) async {
    final favoritesPlaces = await localRepository.getFavoritesPlaces();
    List<Place> uiPlaces = [];

    /// если в локальной базе карточек нет, то для дальнейшей работы
    /// просто переводим все карточки в UiPlace
    if (favoritesPlaces.isEmpty) {
      uiPlaces = apiPlaces.map((place) => Place.fromApi(place)).toList();
    } else {
      /// если есть, то проставляем отметки Избранное / или нет
      uiPlaces = apiPlaces
          .map((place) => _markFavorites(favoritesPlaces, place))
          .toList();
    }

    /// если в кэше уже есть карточки, очищаем кэш для обновленных данных
    final List<Place> cachePlaces = await localRepository.getCachePlaces();

    if (cachePlaces.isNotEmpty) {
      await localRepository.clearCachePlaces();
    }

    /// todo это для тестирования карточки Посетил, потом удалить
    /// ‼️ беру рандомную карточку из загруженных с сервера и добавляю ее
    /// в избранные Посетил
    // final int randomPlace = Random().nextInt(uiPlaces.length);
    // await localRepository.addNewPlace(
    //     Place.switchFavoriteStatusVisited(place: uiPlaces[randomPlace]));

    /// сохраняем данные с сервера в локальную память типа кэш
    await localRepository.addCachePlacesAll(uiPlaces);

    /// вернём данные из кэша для дальнейшей работы
    return localRepository.getCachePlaces();
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

  /// метод для показа списка отфильтрованных мест из локального хранилища
  /// применяем на главном экране после закрытия боттомшита с детальной
  /// информацией, т.к. в боттомшите мы можем добавлять и удалять карточки в
  /// Избранном
  Future<List<Place>> getCachePlaces() => localRepository.getCachePlaces();

  /// детализация места
  Future<PlaceDto> getPlaceDetails(int id) => apiRepository.getPlaceDetail(id);

  /// добавить новое место на сервер
  Future<void> addNewPlace(PlaceDto place) => apiRepository.addNewPlace(place);

  /// добавить место в список избранного
  Future<void> addToFavorites(Place place) =>
      localRepository.addNewPlace(place);

  /// удалить место из списка избранного
  Future<void> removeFromFavorites(Place place) =>
      localRepository.removePlace(place);

  /// переключатель кнопки Избранное
  /// true - в избранном
  Future<bool> toggleFavorites(Place place) =>
      localRepository.toggleFavorite(place);

  /// загрузка фото
  Future<String> uploadFile(File image) => apiRepository.uploadFile(image);
}
