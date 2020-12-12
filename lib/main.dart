import 'package:flutter/material.dart';
import 'package:places/ui/screen/visiting_screen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Places',
      // home: SightListScreen(), // список мест
      // home: SightDetails(card: mocks[1]), // подробности -описание места
      home: VisitingScreen(), // хочу посетить / посещенные места
    );
  }
}
