import 'package:flutter/material.dart';
import 'package:places/components/icon_svg.dart';
import 'package:places/ui/screen/filters_screen.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/themes.dart';
import 'package:places/ui/screen/sight_search_screen.dart';

/// константы
const hintText = 'Поиск';

/// виджет поисковой строки для главного экрана
/// декоративный - выполняет роль перехода на другие экраны:
/// поиск и настройка фильтра
class SearchBarStatic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(radiusSearchInput),
      clipBehavior: Clip.antiAlias,
      color: Theme.of(context).primaryColorLight,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: heightInput,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                sizedBoxW12,
                IconSvg(
                  icon: icSearch,
                  width: 24,
                  height: 24,
                  color: Theme.of(context).colorScheme.inactiveBlack,
                ),
                sizedBoxW12,
                Text(
                  hintText,
                  style: Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                      color: Theme.of(context).colorScheme.inactiveBlack),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SightSearchScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 4,
            bottom: 4,
            right: 0,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: IconSvg(
                icon: icFilter,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FiltersScreen(),
                  ),
                );
              },
              splashRadius: 20,
              splashColor: Theme.of(context).accentColor.withOpacity(0.25),
            ),
          ),
        ],
      ),
    );
  }
}
