import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/blocs/onboarding_screen/onboarding_cubit.dart';
import 'package:places/blocs/settings_app/settings_app_cubit.dart';
import 'package:places/ui/screen/components/icon_svg.dart';
import 'package:places/ui/screen/onboarding_screen.dart';
import 'package:places/ui/screen/res/app_routes.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/themes.dart';

/// сплэш-экран приложения
class SplashScreen extends StatefulWidget {
  /// первый старт приложения
  final SettingsAppState settingsAppState;

  const SplashScreen({
    Key? key,
    required this.settingsAppState,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  /// анимация логотипа
  late final AnimationController _animationController;
  late final Animation<double> _rotateAnimation;

  @override
  void initState() {
    _navigateToNext();

    _animationController = AnimationController(
      vsync: this,
      duration: milliseconds1500,
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

  /// Данные о первом входе получаем из конструктора, а туда передали из
  /// экземпляра [SettingsAppCubit], при создании которого инициализировали
  /// получение текущих настроек пользователя из локального хранилища.
  /// Логика перехода либо на онбординг, если был первый вход,
  /// либо на главный экран
  Future<void> _navigateToNext() async {
    /// ждём когда завершится инициализация приложения - выполнится ивент
    /// по инициализации настроек и обновится виджет с флагом [isAppReady]
    /// показываем анимацию
    await Future.delayed(seconds4);

    if (widget.settingsAppState.isAppReady) {
      if (widget.settingsAppState.isFirstStart) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => BlocProvider<OnboardingCubit>(
              create: (_) => OnboardingCubit(),
              child: OnboardingScreen(
                isFirstStart: widget.settingsAppState.isFirstStart,
              ),
            ),
          ),
        );
      } else {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    }
  }
}
