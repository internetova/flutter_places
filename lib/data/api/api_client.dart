import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:places/data/api/api_constants.dart';

class ApiClient {
  final _client = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: 5000,
      receiveTimeout: 5000,
      sendTimeout: 5000,
      responseType: ResponseType.json,
    ),
  );

  void initInterceptors() {
    _client.interceptors.add(InterceptorsWrapper(
      onError: (err) {},
      onRequest: (options) {
        print('Отправлен запрос: ${options.baseUrl}${options.path}');
      },
      onResponse: (response) {
        print('Получен ответ: $response');
      },
    ));
  }

  /// получить с сервера
  Future<Response> get(String url) async {
    initInterceptors();

    final Response response = await _client.get(url);
    return response;
  }

  /// отправить на сервер
  Future<Response> post(String url, {dynamic data}) async {
    initInterceptors();

    final Response response = await _client.post(url, data: data);
    return response;
  }

  /// обновить существующую позицию
  Future<Response> put(String url, {@required dynamic data}) async {
    initInterceptors();

    final Response response = await _client.put(url, data: data);
    return response;
  }

  /// удалить
  Future<Response> delete(String url) async {
    initInterceptors();

    final Response response = await _client.delete(url);
    return response;
  }
}
