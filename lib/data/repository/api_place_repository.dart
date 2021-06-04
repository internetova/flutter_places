import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:places/data/api/api_client.dart';
import 'package:places/data/api/api_constants.dart';
import 'package:places/data/dto/place_dto.dart';
import 'package:places/data/dto/places_filter_request_dto.dart';
import 'package:places/data/exceptions/network_exception.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/data/model/user_location.dart';
import 'package:places/data/repository/place_repository.dart';
import 'package:places/data/res/error_response_strings.dart';

/// УДАЛЁННЫЙ РЕПОЗИТОРИЙ
/// запрос данных с сервера
class ApiPlaceRepository implements PlaceRepository<PlaceDto> {
  final ApiClient _client;

  ApiPlaceRepository(this._client);

  /// запрашивает данные согласно фильтру юзера
  /// [nameFilter] может быть null - текстовый поиск по полю name
  /// [keywords] - ключевые слова для поиска
  Future<List<PlaceDto>> getPlaces({
    UserLocation? userLocation,
    SearchFilter? filter,
    String? keywords,
  }) async {
    late Map<String, dynamic> data;

    /// геолокация отключена - ищем по всей базе
    if (userLocation == null) {
      data = PlacesFilterRequestDto(
        nameFilter: keywords != null ? keywords.trim() : null,
      ).toJson();

      /// иначе передаем фильтр и локацию пользователя
    } else {
      data = PlacesFilterRequestDto(
        lat: userLocation.lat,
        lng: userLocation.lng,
        radius: filter?.radius,
        typeFilter: filter?.typeFilter,
        nameFilter: keywords != null ? keywords.trim() : null,
      ).toJson();
    }

    final response = await _client.post(
      ApiConstants.filteredPlacesUrl,
      data: jsonEncode(data),
    );

    final places =
        (response.data as List).map((e) => PlaceDto.fromJson(e)).toList();

    return places;
  }

  /// запросить все места без фильтра если нет доступа к геолокации
  Future<List<PlaceDto>> getAllPlaces() async {
    final response = await _client.get(ApiConstants.placesUrl);

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

  /// загрузка фото
  Future<String> uploadFile(File image) async {
    String? filename = image.path.split('/').last;

    /// тип загружаемых данных
    String? mimeType = mime(filename);
    String? mimee = mimeType?.split('/')[0];
    String? type = mimeType?.split('/')[1];

    if (mimeType != null) {
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          image.path,
          filename: filename,
          contentType: MediaType(mimee!, type!),
        ),
      });

      final response = await _client.post(
        ApiConstants.uploadFileUrl,
        data: formData,
      );

      return '${ApiConstants.baseUrl}/${response.headers['location']?.first}';
    } else {
      throw Exception(ErrorResponseStrings.eMimeType);
    }
  }

  /// удалить место
  @override
  Future<void> removePlace(PlaceDto place) =>
      _client.delete('${ApiConstants.placesUrl}/${place.id}');

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
