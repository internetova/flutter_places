/// Обработка сетевых ошибок ошибок
/// "В запросе 'base_url/places' возникла ошибка: 500 internal server error"
class NetworkException implements Exception {
  final String? request;
  final int? errorCode;
  final String errorText;

  NetworkException({
    this.request,
    this.errorCode,
    required this.errorText,
  });

  @override
  String toString() {
    String msg = request != null
        ? 'В запросе $request возникла ошибка:'
        : 'Возникла ошибка:';
    msg += errorCode != null ? ' $errorCode $errorText' : ' $errorText';
    return msg;
  }
}
