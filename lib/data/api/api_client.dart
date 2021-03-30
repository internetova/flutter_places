import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:places/data/api/api_constants.dart';

class ApiClient {
  /// базовые настройки клиента
  static BaseOptions _options = BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: 5000,
    receiveTimeout: 5000,
    sendTimeout: 5000,
    responseType: ResponseType.json,
  );

  /// создаём клиент
  static Dio createDio() {
    return Dio(_options);
  }

  /// добавляем перехватчики запросов Interceptors
  static Dio addInterceptors(Dio dio) {
    return dio
      ..interceptors.add(
        InterceptorsWrapper(
          onError: (DioError e) async {
            return e.response.data;
          },
          onRequest: (options) {
            print('Отправлен запрос: ${options.baseUrl}${options.path}');
          },
          onResponse: (response) {
            print('Получен ответ: $response');
          },
        ),
      );
  }

  /// создаём клиент dio
  static final _dio = createDio();

  /// добавляем к нему Interceptors
  static final _client = addInterceptors(_dio);

  /// получить с сервера
  Future<Response> get(String url) async => await _client.get(url);

  /// отправить на сервер
  Future<Response> post(String url, {dynamic data}) async =>
      await _client.post(url, data: data);

  /// обновить существующую позицию
  Future<Response> put(String url, {@required dynamic data}) async =>
      await _client.put(url, data: data);

  /// удалить
  Future<Response> delete(String url) async => await _client.delete(url);
}
