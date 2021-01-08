import 'package:flutter/material.dart';
import 'package:places/components/icon_svg.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/themes.dart';

/// виджет поисковой строки для главного экрана и экрана поиска
/// [isFieldEnabled] - доступность поля для редактирования
/// [iconAction] - открывает фильтр или очищает поле
class SearchBar extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SizedBox(
        height: heightInput,
        child: Theme(
          data: ThemeData(
            inputDecorationTheme: InputDecorationTheme(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              hintStyle: Theme.of(context)
                  .primaryTextTheme
                  .subtitle1
                  .copyWith(color: Theme.of(context).colorScheme.inactiveBlack),
              fillColor: Theme.of(context).primaryColorLight,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radiusSearchInput),
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radiusSearchInput),
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          child: TextField(
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'Поиск',
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: IconSvg(
                  icon: icSearch,
                  width: 24,
                  height: 24,
                  color: Theme.of(context).colorScheme.inactiveBlack,
                ),
              ),
            ),
            // onTap: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => SightSearchScreen(),
            //     ),
            //   );
            // },
          ),
        ),
      ),
      Positioned.fill(
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () {
              print('onTap: ');
            },
          ),
        ),
      ),
      // Positioned(
      //   top: 8,
      //   right: 12,
      //   child: SizedBox(
      //     width: 24,
      //     height: 24,
      //     child: IconButton(
      //       padding: EdgeInsets.zero,
      //       icon: IconSvg(
      //         icon: icFilter,
      //         color: Theme.of(context).accentColor,
      //       ),
      //       onPressed: () {
      //         // Navigator.push(
      //         //   context,
      //         //   MaterialPageRoute(
      //         //     builder: (context) => FiltersScreen(),
      //         //   ),
      //         // );
      //       },
      //       splashRadius: 24,
      //       splashColor: Theme.of(context).accentColor.withOpacity(0.05),
      //     ),
      //   ),
      // ),
    ]);
  }
}
