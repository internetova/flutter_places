import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/components/icon_leading_appbar.dart';
import 'package:places/domain/categories.dart';
import 'package:places/mocks.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/strings.dart';

class FiltersScreen extends StatefulWidget {
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  /// индикаторы выбранных категорий
  List<bool> _selectedCategories = _clearSelected(categories);

  /// данные слайдера
  double _startValue = 100;
  double _endValue = 10000;
  RangeValues _currentRangeValues = _startDataSlider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leading: buildLeadingIcon(context, icon: icArrow),
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
      ),
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

  /// стартовые элементы для построения карточки категории
  Widget _buildCategories(List<Categories> catalog, List<bool> selectedCat) =>
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
                              selectedCat[index] = !selectedCat[index];
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
                  if (selectedCat[index]) _showSelected(),
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

  /// кнопка с результами
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
            titleButton,
            style: Theme.of(context).textTheme.button,
          ),
        ),
      );
}

/// создаем массив с метками выделенных категорий
/// со старта все false
/// также используем при очистке выбранных категорий
List<bool> _clearSelected(List categories) {
  return categories.map((e) => false).toList();
}

/// для слайдера строка Расстояние метры в километры
String _convertMeterToKm(double value) {
  if (value < 1000) {
    return '${value.toStringAsFixed(0)} м';
  } else {
    return '${(value / 1000).toStringAsFixed(2)} км';
  }
}

/// стартовые данные для слайдера
RangeValues _startDataSlider() => RangeValues(100, 3000);
