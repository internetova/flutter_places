import 'package:dio/dio.dart';
import 'package:places/data/res/http_strings.dart';

/// печать ошибок в случае неудачи
class ApiError {
  static printError(DioError e) {
    switch (e.response.statusCode) {
      case 400:
        print('${ErrorResponseStrings.e400} Код: ${e.response.statusCode}');
        print('${e.response.data}');
        break;
      case 404:
        print('${ErrorResponseStrings.e404} Код: ${e.response.statusCode}');
        print('${e.response.data}');
        break;
      case 409:
        print('${ErrorResponseStrings.e409} Код: ${e.response.statusCode}');
        print('${e.response.data}');
        break;
      default:
        print(e.message);
        print('${e.response.data}');
    }
  }
}