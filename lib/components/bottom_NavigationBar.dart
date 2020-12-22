import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/ui/screen/res/assets.dart';

class MainBottomNavigationBar extends StatelessWidget {
  const MainBottomNavigationBar({Key key, @required this.current})
      : super(key: key);
  final int current;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: current,
      onTap: (current) {
        switch (current) {
          case 0:
            print('onTaped Список');
            break;
          case 1:
            print('onTaped Карта');
            break;
          case 2:
            print('onTaped Избранное');
            break;
          case 3:
            print('onTaped Настройки');
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            current == 0 ? icListFull : icList,
            color: _itemColor(context, current == 0),
          ),
          label: 'Список',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            current == 1 ? icMapFull : icMap,
            color: _itemColor(context, current == 1),
          ),
          label: 'Карта',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            current == 2 ? icHeartFull : icHeart,
            color: _itemColor(context, current == 2),
          ),
          label: 'Избранное',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            current == 3 ? icSettingsFull : icSettings,
            color: _itemColor(context, current == 3),
          ),
          label: 'Настройки',
        ),
      ],
    );
  }

  /// берём цвет айтема из темы
  Color _itemColor(BuildContext context, bool current) {
    return current
        ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
        : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor;
  }
}
