import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:places/app.dart';
import 'package:places/environment/build_config.dart';
import 'package:places/environment/build_type.dart';
import 'package:places/environment/environment.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  _defineEnvironment(buildConfig: _setUpConfig());
  runApp(App());
}

void _defineEnvironment({required BuildConfig buildConfig}) {
  Environment.init(buildConfig, BuildType.prod);
}

BuildConfig _setUpConfig() {
  return BuildConfig();
}
