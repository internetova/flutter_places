import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/ui/screen/res/app_routes.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/strings.dart';

/// BottomNavigationBar приложения
class MainBottomNavigationBar extends StatelessWidget {
  final int current;

  const MainBottomNavigationBar({Key? key, required this.current})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: current,
      onTap: (current) {
        switch (current) {
          case 0:
            Navigator.of(context).pushReplacementNamed(AppRoutes.home);
            break;
          case 1:
            print('onTaped Карта');
            break;
          case 2:
            Navigator.of(context).pushReplacementNamed(AppRoutes.visiting);
            break;
          case 3:
            Navigator.of(context).pushReplacementNamed(AppRoutes.settings);
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            current == 0 ? icListFull : icList,
            color: _itemColor(context, current == 0),
          ),
          label: bottomNavigationBarItemLabelList,
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            current == 1 ? icMapFull : icMap,
            color: _itemColor(context, current == 1),
          ),
          label: bottomNavigationBarItemLabelMap,
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            current == 2 ? icHeartFull : icHeart,
            color: _itemColor(context, current == 2),
          ),
          label: bottomNavigationBarItemLabelFavorites,
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            current == 3 ? icSettingsFull : icSettings,
            color: _itemColor(context, current == 3),
          ),
          label: bottomNavigationBarItemLabelSettings,
        ),
      ],
    );
  }

  /// берём цвет айтема из темы
  Color? _itemColor(BuildContext context, bool current) {
    return current
        ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
        : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor;
  }
}
