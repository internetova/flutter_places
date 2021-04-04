import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:places/data/api/api_client.dart';
import 'package:places/data/api/api_constants.dart';
import 'package:places/data/api/api_error.dart';
import 'package:places/data/local_storage/local_storage.dart';
import 'package:places/data/dto/place_dto.dart';
import 'package:places/data/dto/places_filter_request_dto.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/data/repository/place_repository.dart';

/// УДАЛЁННЫЙ РЕПОЗИТОРИЙ
/// запрос данных с сервера
/// преобразование в объекты программы
/// возвращаем оъекты или ошибку
class ApiPlaceRepository implements PlaceRepository<PlaceDto> {
  final ApiClient _client;

  ApiPlaceRepository(this._client);

  /// все несортированные для теста
  Future<List<PlaceDto>> getAllPlaces() async {
    try {
      final response = await _client.get(ApiConstants.placesUrl);
      final places =
          (response.data as List).map((e) => PlaceDto.fromJson(e)).toList();
      print('ApiRepository getAllPlaces (${places.length} шт.): $places');

      return places;
    } on DioError catch (e) {
      throw Exception(ApiError.printError(e));
    }
  }

  /// запрашивает данные согласно фильтру юзера
  /// [nameFilter] может быть null - текстовый поиск по полю name
  /// [keywords] - ключевые слова для поиска
  @override
  Future<List<PlaceDto>> getPlaces(
      {SearchFilter? userFilter, String? keywords}) async {
    /// если юзер не задал фильтр, то берём дефолтный
    SearchFilter filter =
        userFilter == null ? LocalStorage.searchFilter : userFilter;

    try {
      final data = PlacesFilterRequestDto(
        lat: filter.userLocation.lat,
        lng: filter.userLocation.lng,
        radius: filter.radius.end,
        typeFilter: filter.typeFilter,
        nameFilter: keywords != null ? keywords.trim() : null,
      ).toJson();

      print('ApiRepository запрос: PlacesFilterRequestDto $data');

      final response = await _client.post(
        ApiConstants.filteredPlacesUrl,
        data: jsonEncode(data),
      );
      final places =
          (response.data as List).map((e) => PlaceDto.fromJson(e)).toList();

      print(
          'ApiRepository ответ filtered places (${places.length} шт.): $places');

      return places;
    } on DioError catch (e) {
      ApiError.printError(e);

      throw Exception(e.message);
    }
  }

  /// получить место по id
  @override
  Future<PlaceDto> getPlaceDetail(int id) async {
    try {
      final response = await _client.get('${ApiConstants.placesUrl}/$id');
      final place = PlaceDto.fromJson((response.data as Map<String, dynamic>));
      print('ApiRepository place: $place');

      return place;
    } on DioError catch (e) {
      ApiError.printError(e);

      throw Exception(e.message);
    }
  }

  /// добавить новое место
  @override
  Future<PlaceDto> addNewPlace(PlaceDto place) async {
    try {
      final response = await _client.post(
        ApiConstants.placesUrl,
        data: jsonEncode(place.toJson()),
      );
      final newPlace = PlaceDto.fromJson((response.data as Map<String, dynamic>));

      return newPlace;
    } on DioError catch (e) {
      ApiError.printError(e);

      throw Exception(e.message);
    }
  }

  /// добавить список мест для теста с моковыми данными
  /// todo это для теста, потом удалить
  Future<void> addPlacesList(List<PlaceDto> data) async {
    data.forEach(addNewPlace);
  }

  /// ‼️❓ ДЛЯ теста
  /// удалить место
  @override
  Future<void> removePlace(int id) async {
    try {
      await _client.delete('${ApiConstants.placesUrl}/$id');

      print('ApiRepository: Удалено!');
    } on DioError catch (e) {
      throw Exception(ApiError.printError(e));
    }
  }

  /// обновить место
  @override
  Future<void> updatePlace(PlaceDto place) async {
    try {
      final url = '${ApiConstants.placesUrl}/${place.id}';

      await _client.put(
        url,
        data: jsonEncode(place.toJson()),
      );

      print('ApiRepository: Обновлено!');
    } on DioError catch (e) {
      ApiError.printError(e);
    }
  }
}
