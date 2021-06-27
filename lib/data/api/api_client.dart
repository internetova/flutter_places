import 'dart:async';

import 'package:dio/dio.dart';
import 'package:places/data/api/api_constants.dart';
import 'package:places/data/exceptions/network_exception.dart';

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
          onRequest: (options, handler) {
            // todo удалить позже
            // print('Interceptors Отправлен запрос: ${options.baseUrl}${options.path}');
            return handler.next(options);
          },
          onResponse: (response, handler) {
            // todo удалить позже
            // print('Interceptors Получен ответ: $response');
            return handler.next(response);
          },
          onError: (DioError e, handler) {
            // print('DioError: $e');
            return handler.next(e); //continue
          },
        ),
      );
  }

  /// создаём клиент dio
  static final _dio = createDio();

  /// добавляем к нему Interceptors
  static final _client = addInterceptors(_dio);

  /// получить с сервера
  Future<Response> get(String url, {Map<String, dynamic>? queryParameters}) =>
      _client.get(url);

  /// отправить на сервер
  Future<Response> post(String url, {dynamic data}) =>
      _client.post(url, data: data);

  /// обновить существующую позицию
  Future<Response> put(String url, {required dynamic data}) =>
      _client.put(url, data: data);

  /// удалить
  Future<Response> delete(String url) => _client.delete(url);

  /// обработка ошибок
  NetworkException getNetworkException(DioError error) {
    final exception = NetworkException(
      request: '${error.requestOptions.baseUrl}${error.requestOptions.path}',
      errorCode: error.response?.statusCode,
      errorText: error.message,
    );

    return exception;
  }
}
