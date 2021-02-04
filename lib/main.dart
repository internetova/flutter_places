import 'package:flutter/material.dart';
import 'package:places/mocks.dart';
import 'package:places/ui/screen/res/themes.dart';
import 'package:places/ui/screen/sight_details.dart';
import 'package:places/ui/screen/sight_list_screen.dart';
import 'package:places/ui/screen/splash_screen.dart';
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
            // пока отключила чтобы было удобнее переключать и смотреть верстку
            // theme: notifier.darkTheme ? _darkTheme : _lightTheme,
            theme: _lightTheme,
            darkTheme: _darkTheme,
            themeMode: ThemeMode.system,
            // home: SightListScreen(), // список мест
            // home: VisitingScreen(), // хочу посетить / посещенные места
            // home: SettingsScreen(), // страница с фильтрами поиска
            // home: AddSightScreen(),
            // home: SightSearchScreen(),
            // home: FiltersScreen(),
            // home: OnboardingScreen(),
            // home: SightDetails(card: mocks[1]),
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
