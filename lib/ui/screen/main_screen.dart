import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/blocs/main_screen/pages/main_pages_cubit.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/screen/map/map_screen.dart';
import 'package:places/ui/screen/place_list_screen.dart';
import 'package:places/ui/screen/settings_screen.dart';
import 'package:places/ui/screen/visiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// главный экран приложения
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainPagesCubit, MainPagesState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: state.currentPage,
            children: [
              PlaceListScreen(),
              MapScreen(),
              VisitingScreen(),
              SettingsScreen(),
            ],
          ),
          bottomNavigationBar: _BuildBottomNavigationBar(
            pageIndex: state.currentPage,
          ),
        );
      },
    );
  }
}

/// навигация по экранам
class _BuildBottomNavigationBar extends StatelessWidget {
  final int pageIndex;

  const _BuildBottomNavigationBar({
    Key? key,
    required this.pageIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            pageIndex == 0 ? icListFull : icList,
            color: _itemColor(context, pageIndex == 0),
          ),
          label: bottomNavigationBarItemLabelList,
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            pageIndex == 1 ? icMapFull : icMap,
            color: _itemColor(context, pageIndex == 1),
          ),
          label: bottomNavigationBarItemLabelMap,
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            pageIndex == 2 ? icHeartFull : icHeart,
            color: _itemColor(context, pageIndex == 2),
          ),
          label: bottomNavigationBarItemLabelFavorites,
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            pageIndex == 3 ? icSettingsFull : icSettings,
            color: _itemColor(context, pageIndex == 3),
          ),
          label: bottomNavigationBarItemLabelSettings,
        ),
      ],
      currentIndex: pageIndex,
      onTap: (index) {
        context.read<MainPagesCubit>().changedPage(index);
      },
    );
  }

  /// берём цвет айтема из темы
  Color? _itemColor(BuildContext context, bool current) {
    return current
        ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
        : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor;
  }
}
