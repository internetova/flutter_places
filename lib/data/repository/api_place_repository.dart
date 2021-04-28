import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:places/data/api/api_client.dart';
import 'package:places/data/api/api_constants.dart';
import 'package:places/data/dto/place_dto.dart';
import 'package:places/data/dto/places_filter_request_dto.dart';
import 'package:places/data/exceptions/network_exception.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/data/repository/place_repository.dart';

/// УДАЛЁННЫЙ РЕПОЗИТОРИЙ
/// запрос данных с сервера
class ApiPlaceRepository implements PlaceRepository<PlaceDto> {
  final ApiClient _client;

  ApiPlaceRepository(this._client);

  /// запрашивает данные согласно фильтру юзера
  /// [nameFilter] может быть null - текстовый поиск по полю name
  /// [keywords] - ключевые слова для поиска
  Future<List<PlaceDto>> getPlaces(
      {required SearchFilter filter, String? keywords}) async {
    final data = PlacesFilterRequestDto(
      lat: filter.userLocation.lat,
      lng: filter.userLocation.lng,
      radius: filter.radius.end,
      typeFilter: filter.typeFilter,
      nameFilter: keywords != null ? keywords.trim() : null,
    ).toJson();

    final response = await _client.post(
      ApiConstants.filteredPlacesUrl,
      data: jsonEncode(data),
    );

    final places =
        (response.data as List).map((e) => PlaceDto.fromJson(e)).toList();

    return places;
  }

  /// получить место по id
  @override
  Future<PlaceDto> getPlaceDetail(int id) async {
    final response = await _client.get('${ApiConstants.placesUrl}/$id');
    final place = PlaceDto.fromJson((response.data as Map<String, dynamic>));

    return place;
  }

  /// добавить новое место
  @override
  Future<PlaceDto> addNewPlace(PlaceDto place) async {
    final response = await _client.post(
      ApiConstants.placesUrl,
      data: jsonEncode(place.toJson()),
    );
    final newPlace = PlaceDto.fromJson((response.data as Map<String, dynamic>));

    return newPlace;
  }

  /// добавить список мест для теста с моковыми данными
  /// todo это для теста, потом удалить
  Future<void> addPlacesList(List<PlaceDto> data) async {
    data.forEach(addNewPlace);
  }

  /// ‼️❓ ДЛЯ теста
  /// удалить место
  @override
  Future<void> removePlace(int id) => _client.delete('${ApiConstants.placesUrl}/$id');

  /// обновить место
  @override
  Future<void> updatePlace(PlaceDto place) async {
    final url = '${ApiConstants.placesUrl}/${place.id}';

    await _client.put(
      url,
      data: jsonEncode(place.toJson()),
    );
  }

  /// todo проверим есть ли доступ в сеть 🤓
  Future<Response> testNetwork() =>
      _client.get('${ApiConstants.placesUrl}?count=1');

  /// обработка ошибок
  NetworkException getNetworkException(DioError error) =>
      _client.getNetworkException(error);
}
