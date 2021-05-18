import 'package:flutter/material.dart';
import 'package:places/ui/components/icon_svg.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/sizes.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/themes.dart';

/// виджет поисковой строки для главного экрана
/// декоративный - выполняет роль перехода на другие экраны:
/// поиск и настройка фильтра
class SearchBarStatic extends StatelessWidget {
  final VoidCallback? onTapSearch;
  final VoidCallback? onPressedFilter;

  const SearchBarStatic({
    Key? key,
    this.onTapSearch,
    this.onPressedFilter,
  }) : super(key: key);

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
                  size: 24,
                  color: Theme.of(context).colorScheme.inactiveBlack,
                ),
                sizedBoxW12,
                Text(
                  searchHintText,
                  style: Theme.of(context).primaryTextTheme.subtitle1!.copyWith(
                      color: Theme.of(context).colorScheme.inactiveBlack),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onTapSearch,
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
              onPressed: onPressedFilter,
              splashRadius: splashRadiusSmall,
              splashColor: Theme.of(context).accentColor.withOpacity(0.25),
            ),
          ),
        ],
      ),
    );
  }
}