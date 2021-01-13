import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/components/button_save.dart';
import 'package:places/components/icon_leading_appbar.dart';
import 'package:places/domain/categories.dart';
import 'package:places/domain/sight.dart';
import 'package:places/mocks.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/utilities/filter_utility.dart';

/// экран фильтра для поиска
class FiltersScreen extends StatefulWidget {
  final FilterSettings filter;

  const FiltersScreen({Key key, this.filter}) : super(key: key);

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  /// кнопка Показать отключена если нет результатов
  bool _isButtonEnabled = false;
  VoidCallback _onPressed;

  /// для построения индикаторов выбранных категорий
  List<Map> _selectedCategories;

  /// только выбранные категории для функции поиска и передачи на другой экран
  List<Map> _filteredCategories = [];

  /// данные слайдера
  double _startValue = 100;
  double _endValue = 10000;
  RangeValues _currentRangeValues;

  /// стартовая точка поиска
  /// красная площадь для теста
  final _startSearchPoint = CenterPoint(
    lat: 55.753564,
    lon: 37.621085,
    name: 'Москва, Красная площадь',
  );

  /// деревня для теста
  // final _startSearchPoint = CenterPoint(
  //   lat: 55.994511,
  //   lon: 37.604592,
  //   name: 'Чиверёво',
  // );

  /// нефильтрованные данные если юзер не настраивал фильтр
  final List<Sight> _fullData = mocks;
  /// отфильтрованные результаты
  List<Sight> _filteredData = [];

  @override
  void initState() {
    if (widget.filter != null) {
      _filteredCategories = widget.filter.categories;
      _currentRangeValues = widget.filter.distance;
      _selectedCategories = _currentStatusCategories(
          _startCategories(categories), widget.filter.categories);
      _filteredData = filterData(
          data: _fullData,
          categories: _filteredCategories,
          centerPoint: _startSearchPoint,
          distance: _currentRangeValues);
    } else {
      _selectedCategories = _startCategories(categories);
      _currentRangeValues = _startDataSlider();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_filteredData.isNotEmpty) {
      _isButtonEnabled = true;

      _onPressed = () {
        final _filterSettings = FilterSettings(
            categories: _filteredCategories,
            distance: _currentRangeValues,
            centerPoint: _startSearchPoint);

        Navigator.pop(context, _filterSettings);
      };
    } else {
      _isButtonEnabled = false;
      _onPressed = null;
    }

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
      floatingActionButton: ButtonSave(
        title: _buildTitleButton(),
        isButtonEnabled: _isButtonEnabled,
        onPressed: _onPressed,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  String _buildTitleButton() {
    if (_filteredData.isEmpty) {
      return 'ПОКАЗАТЬ';
    } else {
      return 'ПОКАЗАТЬ (${_filteredData.length})';
    }
  }

  /// AppBar
  Widget _buildFilterAppBar() => AppBar(
        toolbarHeight: toolbarHeightStandard,
        leading: SmallLeadingIcon(
          icon: icArrow,
          onPressed: _back,
        ),
        leadingWidth: 64,
        title: Align(
          alignment: Alignment.centerRight,
          child: FlatButton(
            onPressed: _onClearFilter,
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
                              _filteredCategories =
                                  _filterCategories(_selectedCategories);
                              _filteredData = filterData(
                                  data: _fullData,
                                  categories: _filteredCategories,
                                  centerPoint: _startSearchPoint,
                                  distance: _currentRangeValues);
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
            _filteredData = filterData(
                data: _fullData, // база карточек
                categories: _filteredCategories, // выбранные категории
                centerPoint: _startSearchPoint, // точка отсчёта расстояния
                distance: _currentRangeValues);
          });
        },
      );

  /// оставляем только выбранные категории и передаем их в поиск
  List<Map> _filterCategories(List<Map> categories) {
    return categories.where((cat) => cat['isSelected'] == true).toList();
  }

  /// создаем массив с id и метками выделенных категорий
  /// со старта все false если ничего не было выбрано ранее
  /// ‼️❓пока на всякий случай добавила id и type категории
  List<Map> _startCategories(List<Categories> categories) {
    return categories
        .map((e) => {'id': e.id, 'type': e.name, 'isSelected': false})
        .toList();
  }

  /// если пришли настройки фильтра с предыдущего экрана применяем выбранные категори
  List<Map> _currentStatusCategories(
      List<Map> categories, List<Map> filteredCategories) {
    for (var cat in categories) {
      for (var filteredCat in filteredCategories) {
        if (cat['type'] == filteredCat['type']) cat['isSelected'] = true;
      }
    }
    return categories;
  }

  /// очистка фильтра по кнопке Очистить
  void _onClearFilter() {
    setState(() {
      _selectedCategories = _clearCategories(categories);
      _currentRangeValues = _startDataSlider();
      _filteredData.clear();
      _isButtonEnabled = false;
      _onPressed = null;
    });
  }

  /// очистка выбранных категорий
  List<Map> _clearCategories(List<Categories> categories) {
    _filteredCategories.clear();

    return categories
        .map((e) => {'id': e.id, 'type': e.name, 'isSelected': false})
        .toList();
  }

  /// вернуться на предыдущий экран без сохранения
  void _back() {
    Navigator.pop(context, widget.filter);
  }
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
