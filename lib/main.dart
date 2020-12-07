import 'package:flutter/material.dart';
// import 'ui/screen/sight_card.dart';
import 'ui/screen/sight_list_screen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Places',
      home: SightListScreen(),
    );
  }
}
