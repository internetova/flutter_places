import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:places/ui/screen/components/bottom_navigationbar.dart';

/// учебное тестирование dio
class DioTest extends StatefulWidget {
  final String title = 'Dio Test';

  @override
  _DioTestState createState() => _DioTestState();
}

class _DioTestState extends State<DioTest> {
  List<User> usersList = [];

  @override
  void initState() {
    testNetworkCallUsers();

    super.initState();
  }

  void testNetworkCallUsers() async {
    final response = await getUsers();

    usersList = parseUsers(response);
    print('usersList: $usersList');
  }

  /// преобразуем полученный результат json в список объектов User
  List<User> parseUsers(List<dynamic> json) {
    return json.map((userJson) => User.fromJson(userJson)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: usersList.length,
        itemBuilder: (context, index) {
          return _buildItem(usersList[index]);
        },
      ),
      bottomNavigationBar: MainBottomNavigationBar(
        current: 1,
      ),
    );
  }

  Widget _buildItem(User user) => Card(
    margin: EdgeInsets.all(8.0),
        color: Colors.yellow[50],
        child: ListTile(
          title: Text(user.name),
          subtitle: Text('${user.phone}\n${user.email}'),
          trailing: Text(user.username),
        ),
      );
}

/// клиент dio
final dio = Dio(baseOptions);

/// базовые настройки клиента
BaseOptions baseOptions = BaseOptions(
  baseUrl: 'https://jsonplaceholder.typicode.com',
  connectTimeout: 5000,
  receiveTimeout: 5000,
  sendTimeout: 5000,
  responseType: ResponseType.json,
);

/// запрос данных с сервера (список пользователей)
Future<dynamic> getUsers() async {
  initInterceptors();

  final userResponse = await dio.get('/users');

  if (userResponse.statusCode == 200) {
    return userResponse.data;
  }
  throw Exception(
    'Ошибка http запроса. Код ошибки: ${userResponse.statusCode}',
  );
}

void initInterceptors() {
  dio.interceptors.add(InterceptorsWrapper(
    onError: (err) {},
    onRequest: (options) {
      print('Отправлен запрос: ${options.baseUrl}${options.path}');
    },
    onResponse: (response) {
      print('Получен ответ: $response');
    },
  ));
}

/// модель данных Пользователь
class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;

  User(
    this.id,
    this.name,
    this.username,
    this.email,
    this.phone,
  );

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        username = json['username'],
        email = json['email'],
        phone = json['phone'];
}
