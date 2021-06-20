import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/blocs/settings_app/settings_app_cubit.dart';
import 'package:places/ui/res/app_routes.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// BottomNavigationBar приложения
class AppBottomNavigationBar extends StatelessWidget {
  final int current;

  const AppBottomNavigationBar({Key? key, required this.current})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: current,
      onTap: (current) {
        switch (current) {
          case 0:
            AppRoutes.goPlaceListScreen(
              context,
              searchFilter: context.read<SettingsAppCubit>().state.searchFilter,
            );
            break;
          case 1:
            AppRoutes.goMapScreen(
              context,
              searchFilter: context.read<SettingsAppCubit>().state.searchFilter,
            );
            break;
          case 2:
            AppRoutes.goVisitingScreen(context);
            break;
          case 3:
            AppRoutes.goSettingsScreen(context);
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
