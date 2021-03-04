import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:places/data/res/http_strings.dart';

/// учебное тестирование dio
class DioTest extends StatefulWidget {
  final String title = 'Dio Test';

  @override
  _DioTestState createState() => _DioTestState();
}

class _DioTestState extends State<DioTest> {
  final UserRepository userRepository = UserRepository();

  /// для теста
  final int userId = 2;
  final Map<String, dynamic> newUser = {
    'name': 'Ivan',
    'email': 'qqq@qqq.ru',
    'phone': '000 123-45-67'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('jsonplaceholder.typicode.com'),
            SizedBox(height: 24),
            TextButton(
              child: Text('POST [ /users ]'),
              onPressed: () async {
                await userRepository.post(RequestHttpStrings.dioUsersUrl,
                    data: newUser);
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Color(0xff49CC90),
                minimumSize: Size(200, 40),
              ),
            ),
            SizedBox(height: 8),
            TextButton(
              child: Text('GET [ /users ]'),
              onPressed: () async {
                await userRepository.get(url: RequestHttpStrings.dioUsersUrl);
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Color(0xff60AFFE),
                minimumSize: Size(200, 40),
              ),
            ),
            SizedBox(height: 8),
            TextButton(
              child: Text('GET [ /users/$userId ]'),
              onPressed: () async {
                await userRepository.get(
                    url: '${RequestHttpStrings.dioUsersUrl}/$userId');
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Color(0xff60AFFE),
                minimumSize: Size(200, 40),
              ),
            ),
            SizedBox(height: 8),
            TextButton(
              child: Text('DELETE [ /users/$userId ]'),
              onPressed: () async {
                await userRepository
                    .delete('${RequestHttpStrings.dioUsersUrl}/$userId');
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Color(0xffF93E3F),
                minimumSize: Size(200, 40),
              ),
            ),
            SizedBox(height: 8),
            TextButton(
              child: Text('PUT [ /users/$userId ]'),
              onPressed: () async {
                await userRepository.put(
                    '${RequestHttpStrings.dioUsersUrl}/$userId',
                    data: newUser);
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Color(0xffFCA131),
                minimumSize: Size(200, 40),
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class UserRepository {
  final _dio = Dio(
    BaseOptions(
      baseUrl: RequestHttpStrings.dioBaseUrl,
      connectTimeout: 5000,
      receiveTimeout: 5000,
      sendTimeout: 5000,
      responseType: ResponseType.json,
    ),
  );

  void initInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (DioError e) {
        print('Получена ошибка: $e');
      },
      onRequest: (options) {
        print('Отправлен запрос: ${options.baseUrl}${options.path}');
      },
      onResponse: (response) {
        print('Получен ответ: $response');
      },
    ));
  }

  /// получить данные
  Future<dynamic> get(
      {@required String url, Map<String, dynamic> queryParameters}) async {
    initInterceptors();

    var objectData;

    try {
      final response = await _dio.get(url, queryParameters: queryParameters);
      final jsonData = response.data;

      if (jsonData is List) {
        objectData = jsonData.map((jsonItem) => User.fromJson(jsonItem));
      } else if (jsonData is Map) {
        objectData = User.fromJson(jsonData);
      }

      print(objectData);
      return objectData;
    } on DioError catch (e) {
      printError(e);
    }
  }

  /// отправить данные
  Future<dynamic> post(String url,
      {@required Map<String, dynamic> data}) async {
    initInterceptors();

    try {
      final response = await _dio.post(url, data: data);
      return response;
    } on DioError catch (e) {
      printError(e);
    }
  }

  /// редактировать данные
  Future<dynamic> put(String url, {@required Map<String, dynamic> data}) async {
    initInterceptors();

    try {
      final response = await _dio.put(url, data: data);
      print(response.data);
      return response;
    } on DioError catch (e) {
      printError(e);
    }
  }

  /// удалить данные
  Future<dynamic> delete(String url) async {
    initInterceptors();

    try {
      Response response = await _dio.delete(url);
      print('Удалено. Response.statusCode ${response.statusCode}');
      return response;
    } on DioError catch (e) {
      printError(e);
    }
  }

  /// обработка ошибок
  void printError(DioError e) {
    switch (e.response.statusCode) {
      case 400:
        print('${ErrorResponseStrings.e400} Код: ${e.response.statusCode}');
        break;
      case 404:
        print('${ErrorResponseStrings.e404} Код: ${e.response.statusCode}');
        break;
      case 409:
        print('${ErrorResponseStrings.e409} Код: ${e.response.statusCode}');
        break;
      default:
        print(e.message);
    }
  }
}

/// модель данных Пользователь
class User {
  final int id;
  final String name;
  final String email;
  final String phone;

  User(
    this.id,
    this.name,
    this.email,
    this.phone,
  );

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        phone = json['phone'];
}

/// модель данных Пост
class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post(
    this.userId,
    this.id,
    this.title,
    this.body,
  );

  Post.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        id = json['id'],
        title = json['title'],
        body = json['body'];
}
