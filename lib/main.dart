import 'package:flutter/material.dart';
import 'package:places/ui/screen/res/themes.dart';
import 'package:places/ui/screen/sight_list_screen.dart';
import 'package:places/ui/screen/visiting_screen.dart';

void main() {
  runApp(App());
}

final ThemeData lightTheme = AppTheme.buildTheme();
final ThemeData darkTheme = AppTheme.buildThemeDark();

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Places',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      // home: SightListScreen(), // список мест
      // home: SightDetails(card: mocks[1]), // подробности -описание места
      home: VisitingScreen(), // хочу посетить / посещенные места
    );
  }
}
