import 'package:flutter/material.dart';
import 'package:places/ui/screen/onboarding_screen.dart';
import 'package:places/ui/screen/res/themes.dart';
import 'package:places/ui/screen/settings_screen.dart';
import 'package:places/ui/screen/sight_list_screen.dart';
import 'package:places/ui/screen/visiting_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(App());
}

final ThemeData _lightTheme = AppTheme.buildTheme();
final ThemeData _darkTheme = AppTheme.buildThemeDark();

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Places',
            theme: notifier.darkTheme ? _darkTheme : _lightTheme,
            routes: {
              '/': (context) => SightListScreen(),
              '/visiting': (context) => VisitingScreen(),
              '/settings': (context) => SettingsScreen(),
              '/onboarding': (context) => OnboardingScreen(),
            },
          );
        },
      ),
    );
  }
}
