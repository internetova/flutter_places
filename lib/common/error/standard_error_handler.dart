import 'package:mwwm/mwwm.dart';

class StandardErrorHandler extends ErrorHandler {
  @override
  void handleError(Object e) {
    print('Обработанная ошибка $e');
  }
}