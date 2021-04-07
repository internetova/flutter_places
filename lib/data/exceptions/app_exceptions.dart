import 'dart:io';

import 'package:dio/dio.dart';
import 'package:places/data/exceptions/network_exception.dart';
import 'package:places/ui/screen/res/strings.dart';

/// обработка ошибок
class AppExceptions {
  final Object error;

  const AppExceptions(this.error);

  static NetworkException getExceptions(error) {
    if (error is DioError) {
      return NetworkException(
        request: '${error.requestOptions.baseUrl}${error.requestOptions.path}',
        errorCode: error.response?.statusCode,
        errorText: error.message,
      );
    } else if (error is SocketException) {
      return NetworkException(
        errorText: appExceptionNoInternetConnection,
      );
    } else if (error is FormatException) {
      return NetworkException(
        errorText: error.message,
      );
    } else {
      return NetworkException(
        errorText: appExceptionUnknownError,
      );
    }
  }
}
