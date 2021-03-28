import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:places/data/api/api_client.dart';
import 'package:places/data/api/api_constants.dart';
import 'package:places/data/api/api_error.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/places_filter_request_dto.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/data/repository/repository.dart';

/// УДАЛЁННЫЙ РЕПОЗИТОРИЙ
/// запрос данных с сервера
/// преобразование в объекты программы
/// возвращаем оъекты или ошибку (пока null)
class ApiPlaceRepository implements Repository<Place> {
  final ApiClient _client;

  ApiPlaceRepository(this._client);

  /// все несортированные для теста
  Future<List<Place>> getAllPlaces() async {
    try {
      final response = await _client.get(ApiConstants.placesUrl);
      final places =
          (response.data as List).map((e) => Place.fromJson(e)).toList();
      print('ApiRepository getAllPlaces (${places.length} шт.): $places');

      return places;
    } on DioError catch (e) {
      ApiError.printError(e);

      return null;
    }
  }

  /// запрашивает данные согласно фильтру юзера
  /// [nameFilter] может быть null - текстовый поиск по полю name
  /// [keywords] - ключевые слова для поиска
  @override
  Future<List<Place>> getPlaces(
      {@required SearchFilter filter, String keywords}) async {
    try {
      final data = PlacesFilterRequestDto(
        lat: filter.userLocation.lat,
        lng: filter.userLocation.lng,
        radius: filter.radius,
        typeFilter: filter.typeFilter,
        nameFilter: keywords != null ? keywords.trim() : null,
      ).toJson();

      print('ApiRepository запрос: PlacesFilterRequestDto $data');

      final response = await _client.post(
        ApiConstants.filteredPlacesUrl,
        data: jsonEncode(data),
      );
      final places =
          (response.data as List).map((e) => Place.fromJson(e)).toList();

      print(
          'ApiRepository ответ filtered places (${places.length} шт.): $places');

      return places;
    } on DioError catch (e) {
      ApiError.printError(e);

      return null;
    }
  }

  /// получить место по id
  @override
  Future<Place> getPlaceDetail(int id) async {
    try {
      final response = await _client.get('${ApiConstants.placesUrl}/$id');
      final place = Place.fromJson((response.data as Map<String, dynamic>));
      print('ApiRepository place: $place');

      return place;
    } on DioError catch (e) {
      ApiError.printError(e);

      return null;
    }
  }

  /// добавить новое место
  @override
  Future<Place> addNewPlace(Place place) async {
    try {
      final response = await _client.post(
        ApiConstants.placesUrl,
        data: jsonEncode(place.toJson()),
      );
      final newPlace = Place.fromJson((response.data as Map<String, dynamic>));

      return newPlace;
    } on DioError catch (e) {
      ApiError.printError(e);

      return null;
    }
  }

  /// добавить список мест для теста с моковыми данными
  Future<void> addPlacesList(List<Place> data) async {
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
      ApiError.printError(e);
    }
  }

  /// обновить место
  @override
  Future<void> updatePlace(Place place) async {
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
