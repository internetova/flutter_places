import 'package:flutter/material.dart';
import 'package:places/ui/screen/components/icon_svg.dart';
import 'package:places/ui/screen/res/app_routes.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/themes.dart';

/// сплэш-экран приложения
class SplashScreen extends StatefulWidget {
  /// первый старт приложения
  final bool isFirstStart;

  /// пока поставлю true
  const SplashScreen({Key key, this.isFirstStart = true})
      : assert(isFirstStart != null),
        super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  /// чтобы отследить завершение инициализации приложения
  Future<bool> _isInitialized;

  @override
  void initState() {
    _isInitialized = _initializeApp();
    _navigateToNext();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.yellow2,
            Theme.of(context).colorScheme.green2,
          ],
        ),
      ),
      child: Center(
        child: IconSvg(
          icon: icSplashLogo,
          size: splashLogo,
        ),
      ),
    );
  }

  /// инициализация приложения
  /// имитируем подготовку данных и возвращаем готовность
  Future<bool> _initializeApp() async {
    return Future.delayed(const Duration(seconds: 2), () => true);
  }

  /// логика перехода либо на онбординг, если был первый вход,
  /// либо на главный экран
  Future<void> _navigateToNext() async {
    /// 1. завершена инициализация
    /// 2. прошло минимальное время отображения сплэш-экрана.
    try {
      await Future.wait([
        _isInitialized,
        Future.delayed(const Duration(seconds: 2)),
      ]);

      Navigator.of(context).pushReplacementNamed(
          widget.isFirstStart ? AppRoutes.onboarding : AppRoutes.home);
    } catch (e) {
      print('Ошибка: $e');
    }
  }
}
