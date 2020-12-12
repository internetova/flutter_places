import 'package:flutter/material.dart';
import 'package:places/constant.dart';

class MainBottomNavigationBar extends StatelessWidget {
  const MainBottomNavigationBar({Key key, @required this.current})
      : super(key: key);
  final int current;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: colorWhiteMain,
      unselectedItemColor: colorSecondary,
      currentIndex: current,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Список',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Карта',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Избранное',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Настройки',
        ),
      ],
    );
  }
}
