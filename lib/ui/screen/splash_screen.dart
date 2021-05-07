import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/blocs/onboarding_screen/onboarding_cubit.dart';
import 'package:places/ui/screen/components/icon_svg.dart';
import 'package:places/ui/screen/onboarding_screen.dart';
import 'package:places/ui/screen/res/app_routes.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/themes.dart';

/// сплэш-экран приложения
class SplashScreen extends StatefulWidget {
  /// первый старт приложения
  final bool isFirstStart;

  /// пока поставлю true
  const SplashScreen({Key? key, this.isFirstStart = true}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  /// чтобы отследить завершение инициализации приложения
  Future<bool>? _isInitialized;

  late final AnimationController _animationController;
  late final Animation<double> _rotateAnimation;

  @override
  void initState() {
    _isInitialized = _initializeApp();
    _navigateToNext();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _rotateAnimation = Tween<double>(
      begin: 0,
      end: -1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.repeat();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
        child: RotationTransition(
          turns: _rotateAnimation,
          child: IconSvg(
            icon: icSplashLogo,
            size: splashLogo,
          ),
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
        _isInitialized!,
        Future.delayed(const Duration(seconds: 2)),
      ]);

      // todo удалить
      // Navigator.of(context).pushReplacementNamed(
      //     widget.isFirstStart ? AppRoutes.onboarding : AppRoutes.home);

      if (widget.isFirstStart) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider<OnboardingCubit>(
              create: (_) => OnboardingCubit(),
              child: OnboardingScreen(),
            ),
          ),
        );
      } else {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }


    } catch (e) {
      print('Ошибка: $e');
    }
  }
}
