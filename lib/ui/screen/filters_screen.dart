import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/components/icon_leading_appbar.dart';
import 'package:places/domain/categories.dart';
import 'package:places/domain/sight.dart';
import 'package:places/mocks.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/strings.dart';

/// экран фильтра для поиска
class FiltersScreen extends StatefulWidget {
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  /// индикаторы выбранных категорий
  List<Map> _selectedCategories = _clearSelected(categories);

  /// данные слайдера
  double _startValue = 100;
  double _endValue = 10000;
  RangeValues _currentRangeValues = _startDataSlider();

  /// центральная точка поиска
  /// красная площадь для теста
  final _moscowPoint = CenterPoint(
    lat: 55.753564,
    lon: 37.621085,
    name: 'Москва, Красная площадь',
  );

  /// деревня для теста
  // final _moPoint = CenterPoint(
  //   lat: 55.994511,
  //   lon: 37.604592,
  //   name: 'Чиверёво',
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildFilterAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildCategories(categories, _selectedCategories),
              _buildHeaderSlider(),
              _buildSlider(),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildButtonResults(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  /// AppBar
  Widget _buildFilterAppBar() => AppBar(
        toolbarHeight: toolbarHeightStandard,
        leading: SmallLeadingIcon(
          icon: icArrow,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        leadingWidth: 64,
        title: Align(
          alignment: Alignment.centerRight,
          child: FlatButton(
            onPressed: () {
              setState(() {
                _selectedCategories = _clearSelected(categories);
                _currentRangeValues = _startDataSlider();
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
      );

  /// стартовые элементы для построения карточки категории
  Widget _buildCategories(List<Categories> catalog, List<Map> selectedCat) =>
      Center(
        child: Wrap(
          spacing: 12.0,
          runSpacing: 40.0,
          children: [
            for (var index = 0; index < catalog.length; index++)
              Stack(
                children: [
                  const SizedBox(
                    width: 96,
                    height: 92,
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      width: 64,
                      height: 64,
                      child: Ink(
                        decoration: ShapeDecoration(
                          color:
                              Theme.of(context).accentColor.withOpacity(0.16),
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          icon: SvgPicture.asset(
                            catalog[index].icon,
                            color: Theme.of(context).accentColor,
                          ),
                          onPressed: () {
                            setState(() {
                              selectedCat[index]['isSelected'] =
                                  !selectedCat[index]['isSelected'];
                            });
                          },
                          splashColor:
                              Theme.of(context).accentColor.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Text(
                      catalog[index].name,
                      style: Theme.of(context).textTheme.caption,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (selectedCat[index]['isSelected']) _showSelected(),
                ],
              ),
          ],
        ),
      );

  /// показывает метку на выбранной категории
  Widget _showSelected() {
    return Positioned(
      top: 46,
      right: 16,
      child: Stack(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: ShapeDecoration(
              shape: CircleBorder(),
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: SvgPicture.asset(
              icTick,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  /// заголовок для слайдера
  Widget _buildHeaderSlider() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              titleSlider,
              style: Theme.of(context).primaryTextTheme.subtitle1,
            ),
            Text(
              'от ${_convertMeterToKm(_currentRangeValues.start)} до ${_convertMeterToKm(_currentRangeValues.end)}',
              style: Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                  color: Theme.of(context).colorScheme.secondaryVariant),
            ),
          ],
        ),
      );

  /// слайдер
  Widget _buildSlider() => RangeSlider(
        min: _startValue,
        max: _endValue,
        values: _currentRangeValues,
        onChanged: (RangeValues values) {
          setState(() {
            _currentRangeValues = values;
          });
        },
      );

  /// кнопка с результатами
  Widget _buildButtonResults() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        child: FloatingActionButton.extended(
          onPressed: () {
            print('onPressed Показать результаты');
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(radiusButton),
            ),
          ),
          label: Text(
            _filterCard(
                data: mocks, // база карточек
                categories: _selectedCategories, // выбранные категории
                centerPoint: _moscowPoint, // точка отсчёта расстояния
                distance: _currentRangeValues), // удалённость от точки отсчёта
            style: Theme.of(context).textTheme.button,
          ),
        ),
      );
}

/// результат в массив с id найденных карточек
String _filterCard(
    {@required List<Sight> data,
    @required List<Map> categories,
    @required CenterPoint centerPoint,
    @required RangeValues distance}) {
  List result = [];
  int countCheckCategory = 0;

  for (var i = 0; i < categories.length; i++) {
    /// если есть выбранные категории
    if (categories[i]['isSelected']) {
      for (var k = 0; k < data.length; k++) {
        if (data[k].type == categories[i]['type'] &&
            _arePointsNear(
                checkPointLat: data[k].lat,
                checkPointLon: data[k].lon,
                centerPoint: centerPoint,
                distance: distance)) {
          result.add(data[k].id);
        }
      }
      countCheckCategory++;
    }
  }

  /// если нет выбранных категорий
  if (countCheckCategory == 0) {
    for (var k = 0; k < data.length; k++) {
      if (_arePointsNear(
          checkPointLat: data[k].lat,
          checkPointLon: data[k].lon,
          centerPoint: centerPoint,
          distance: distance)) {
        result.add(data[k].id);
      }
    }
  }

  return '$titleButton (${result.length})';
}

/// создаем массив с id и метками выделенных категорий
/// со старта все false
/// также используем при очистке выбранных категорий
/// ‼️❓пока на всякий случай добавила id и type категории
List<Map> _clearSelected(List<Categories> categories) {
  return categories
      .map((e) =>
          {'id': e.id, 'type': e.name.toLowerCase(), 'isSelected': false})
      .toList();
}

/// для слайдера строка Расстояние метры в километры
String _convertMeterToKm(double value) {
  if (value < 1000) {
    return '${value.toStringAsFixed(0)} м';
  } else {
    return '${(value / 1000).toStringAsFixed(2)} км';
  }
}

/// стартовые данные для слайдера в метрах
RangeValues _startDataSlider() => RangeValues(100, 3000);

/// поиск карточек по расстоянию
/// https://stackoverflow.com/questions/24680247/check-if-a-latitude-and-longitude-is-within-a-circle-google-maps
/// distance в метрах, переводим в км
bool _arePointsNear(
    {@required double checkPointLat,
    @required double checkPointLon,
    @required CenterPoint centerPoint,
    @required RangeValues distance}) {
  const ky = 40000 / 360;
  final kx = cos(pi * centerPoint.lat / 180.0) * ky;
  final dx = (centerPoint.lon - checkPointLon).abs() * kx;
  final dy = (centerPoint.lat - checkPointLat).abs() * ky;
  final d = sqrt(dx * dx + dy * dy);
  final minDistance = (distance.start / 1000).round();
  final maxDistance = (distance.end / 1000).round();

  return d >= minDistance && d <= maxDistance;
}

/// стартовая точка поиска с названием и координатами
class CenterPoint {
  CenterPoint({@required this.lat, @required this.lon, @required this.name});

  final double lat;
  final double lon;
  final String name;
}
