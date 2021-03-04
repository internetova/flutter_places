import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/res/http_strings.dart';

/// Реализует сетевые запросы
/// Выполняет парсинг данных
/// Возвращает готовые к использованию объекты
class PlaceRepository {
  static const String baseUrl = 'https://test-backend-flutter.surfstudio.ru';
  static const String placesUrl = '/place';
  static const String filteredPlacesUrl = '/filtered_places';

  final _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 5000,
      receiveTimeout: 5000,
      sendTimeout: 5000,
      responseType: ResponseType.json,
    ),
  );

  void initInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (err) {},
      onRequest: (options) {
        print('Отправлен запрос: ${options.baseUrl}${options.path}');
      },
      onResponse: (response) {
        print('Получен ответ: $response');
      },
    ));
  }

  /// получить все интересные места
  Future<void> get() async {
    initInterceptors();

    final response = await _dio.get(placesUrl);

    if (response.statusCode == 200) {
      final jsonData = response.data as List<dynamic>;
      final objectData =
      jsonData.map((item) => Place.fromJson(item)).toList();

      print(objectData);

      return;
    }
    throw Exception(
      'Ошибка http запроса. Код ошибки: ${response.statusCode}',
    );
  }

  Future<void> getItem() async {
    initInterceptors();

    final response = await _dio.get(placesUrl, queryParameters: {'id': 22});

    if (response.statusCode == 200) {
      final jsonData = response.data as List<dynamic>;
      final objectData =
          jsonData.map((item) => Place.fromJson(item)).toList();

      print(objectData);
      return;
    } else if (response.statusCode == 404) {
      print(ErrorResponseStrings.e404);
      return;
    }

    throw Exception(
      'Ошибка http запроса. Код ошибки: ${response.statusCode}',
    );
  }

  Future<void> postHTTP(dynamic data) async {
    try {
      Response response = await _dio.post(placesUrl, data: data);

      print(response);
    } on DioError catch(e) {
      print(e);
    }
  }
}
