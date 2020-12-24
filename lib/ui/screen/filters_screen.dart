import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/components/icon_leading_appbar.dart';
import 'package:places/mocks.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/strings.dart';

class FiltersScreen extends StatefulWidget {
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  /// индикаторы выбранных категорий
  List<bool> _selectedCategories = _clearSelected(categories);

  /// данные слайдера
  double startValue = 100;
  double endValue = 10000;
  RangeValues values = RangeValues(100, 10000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: 80,
            pinned: true,
            floating: false,
            leading: buildLeadingIcon(context, icon: icArrow),
            leadingWidth: 64,
            title: Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
                onPressed: () {
                  setState(() {
                    _selectedCategories = _clearSelected(categories);
                  });
                },
                child: Text(
                  clearFilters,
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        color: Theme.of(context).accentColor,
                      ),
                ),
              ),
            ),
          ),
          SliverGrid.count(
            crossAxisCount: 3,
            children: List.generate(categories.length, (index) {
              return FlatButton(
                onPressed: () {
                  setState(() {
                    _selectedCategories[index] = !_selectedCategories[index];
                  });
                },
                child: Stack(
                  children: [
                    SizedBox(
                      width: 96,
                      height: 92,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Theme.of(context).accentColor.withOpacity(0.16),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 0,
                      right: 0,
                      child: SvgPicture.asset(
                        categories[index].icon,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Text(
                        categories[index].name,
                        style: Theme.of(context).textTheme.caption,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (_selectedCategories[index]) _showSelected(),
                  ],
                ),
              );
            }),
          ),
          SliverFillRemaining(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 48, 16, 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        titleSlider,
                        style: Theme.of(context).primaryTextTheme.subtitle1,
                      ),
                      Text(
                        'от ${convertMeterToKm(values.start)} ${convertMeterToKm(values.end)}',
                        style: Theme.of(context)
                            .primaryTextTheme
                            .subtitle1
                            .copyWith(
                                color:
                                    Theme.of(context).colorScheme.secondaryVariant),
                      ),
                    ],
                  ),
                ),
                RangeSlider(
                  min: startValue,
                  max: endValue,
                  values: values,

                  onChanged: (value) {
                    setState(() {
                      values = value;
                    });
                  },
                ),
                Spacer(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: FlatButton(
                    onPressed: () {
                      print('onPressed Показать результаты');
                    },
                    color: Theme.of(context).accentColor,
                    height: 48,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      titleButton,
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// показывает метку на выбранной категории
Widget _showSelected() {
  return Positioned(
    top: 44,
    right: 12,
    child: SvgPicture.asset(icIsChose),
  );
}

/// создаем массив с метками выделенных категорий
/// со старта все false
/// также используем при очистке выбранных категорий
List<bool> _clearSelected(List categories) {
  return categories.map((e) => false).toList();
}

/// для слайдера метры в километры
String convertMeterToKm(double value) {

  if (value < 1000) {
    return '${value.toStringAsFixed(0)} м';
  } else {
    return '${(value / 1000).toStringAsFixed(2)} км';
  }
}
