import 'package:places/environment/build_config.dart';
import 'package:places/environment/build_type.dart';

/// настройка окружения в котором запускаем приложение
class Environment {
  final BuildConfig buildConfig; // конфигурация
  final BuildType buildType; // тип сборки

  static late Environment _environment;

  Environment._({
    required this.buildConfig,
    required this.buildType,
  });

  static void init(BuildConfig buildConfig, BuildType buildType) {
    _environment = Environment._(
      buildConfig: buildConfig,
      buildType: buildType,
    );
  }

  static Environment get instance => _environment;
}
