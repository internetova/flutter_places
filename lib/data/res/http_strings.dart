/// ответ сервера
class ErrorResponseStrings {
  ErrorResponseStrings._();

  static const String e400 = 'Неверный запрос.';
  static const String e404 = 'Объект не найден.';
  static const String e409 = 'Объект уже существует.';
}

/// удалить после сдачи задания
/// запросы к серверу
/// для теста Dio
class RequestHttpStrings {
  RequestHttpStrings._();
  static const String dioBaseUrl = 'https://jsonplaceholder.typicode.com';
  static const String dioUsersUrl = '/users';
}