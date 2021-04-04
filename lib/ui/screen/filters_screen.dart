import 'package:flutter/material.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/data/model/place_type.dart';
import 'package:places/ui/screen/components/button_save.dart';
import 'package:places/ui/screen/components/icon_leading_appbar.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/res/themes.dart';
import 'package:places/ui/screen/widgets/filter_category_item.dart';

/// экран фильтра для поиска
/// выбираем типы мест и расстояние
/// сервер принимает только одно расстояние - радиус, поэтому для фильтра
/// беру максимальное из Range слайдера
class FiltersScreen extends StatefulWidget {
  final SearchFilter filter;

  const FiltersScreen({
    Key? key,
    required this.filter,
  }) : super(key: key);

  /// для доступа к методу обработки кликов по категориям из дочернего виджета
  static _FiltersScreenState? of(BuildContext context) =>
      context.findAncestorStateOfType<_FiltersScreenState>();

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  /// кнопка Показать отключена если нет результатов
  bool _isButtonEnabled = false;
  VoidCallback? _onPressed;

  /// список всех типов мест - категорий
  List<PlaceType> categories = PlaceType.getList;

  /// для теста удалить
  List<String> _filteredData = [
    // 'qqq',
    // 'qqq',
    // 'qqq',
    // 'qqq',
    // 'qqq',
  ];

  /// для построения индикаторов выбранных категорий
  /// создаём карту со всеми категориями в которой будем отмечать текущий
  /// статус категории: выбрано / не выбрано
  List<Map<String, dynamic>> _selectedCategories = [];

  /// только выбранные категории для передачи в фильтр поиска
  List<String> _filteredCategories = [];

  /// данные слайдера
  double _startValue = rangeSliderFilterDefault.start;
  double _endValue = rangeSliderFilterDefault.end;
  late RangeValues _currentRangeValues;

  @override
  void initState() {
    _filteredCategories = widget.filter.typeFilter;
    _currentRangeValues = widget.filter.radius;
    _selectedCategories = _currentStatusCategories(
        _startCategories(categories), widget.filter.typeFilter);
    super.initState();
  }

  /// вызываем из дочернего виджета [FilterCategoryItem]
  /// выбор / отмена категорий для фильтра, фильтрация базы данных
  void setCategories(Map<String, dynamic> selectedCat) {
    setState(() {
      selectedCat['isSelected'] = !selectedCat['isSelected'];
      _filteredCategories = _filterCategories(_selectedCategories);
      // _filteredData = filterData(
      //     data: _fullData,
      //     categories: _filteredCategories,
      //     centerPoint: _startSearchPoint,
      //     distance: _currentRangeValues);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_filteredData.isNotEmpty) {
      _isButtonEnabled = true;

      _onPressed = () {
        final _newSearchFilter = SearchFilter(
          radius: _currentRangeValues,
          typeFilter: _filteredCategories,
        );

        Navigator.pop(context, _newSearchFilter);
      };
    } else {
      _isButtonEnabled = false;
      _onPressed = null;
    }

    /// физическая ширина и высота экрана
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildFilterAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24.0,
              ),
              child: _buildTitleFilter(),
            ),
          ),
          _buildCategories(
            _screenWidth,
            _screenHeight,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderSlider(),
                    _buildSlider(),
                  ],
                ),
              ),
            ]),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ButtonSave(
                title: _buildTitleButton(),
                isButtonEnabled: _isButtonEnabled,
                onPressed: _onPressed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _buildTitleButton() {
    if (_filteredData.isEmpty) {
      return filterTitleButton;
    } else {
      return '$filterTitleButton (${_filteredData.length})';
    }
  }

  /// AppBar
  Widget _buildFilterAppBar() => SliverAppBar(
        toolbarHeight: toolbarHeightStandard,
        leading: SmallLeadingIcon(
          icon: icArrow,
          onPressed: _back,
        ),
        leadingWidth: 64,
        elevation: 0,
        pinned: true,
        title: Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _onClearFilter,
            child: Text(
              filterClearFilters,
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    color: Theme.of(context).accentColor,
                  ),
            ),
          ),
        ),
      );

  /// Заголовок
  Widget _buildTitleFilter() => Text(
        filterTitleCategories,
        style: Theme.of(context).textTheme.caption!.copyWith(
              color: Theme.of(context).colorScheme.inactiveBlack,
            ),
      );

  /// категории в зависимости от разрешения экрана
  Widget _buildCategories(double width, double height) {
    return width <= 375 && height <= 667 // iphone 8
        ? _categoriesSmallSize(
            categories,
            _selectedCategories,
          )
        : SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            sliver: _categoriesNormalSize(
              categories,
              _selectedCategories,
            ),
          );
  }

  /// список карточек категорий для нормальных экранов
  /// показываем карточки гридами
  Widget _categoriesNormalSize(
          List<PlaceType> catalog, List<Map<String, dynamic>> selectedCat) =>
      SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 40.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return FilterCategoryItem(
              placeType: catalog[index],
              selectedCat: selectedCat[index],
            );
          },
          childCount: catalog.length,
        ),
      );

  /// список карточек категорий для маленьких экранов 375 х 667 iphone 8
  /// показываем категории в одну прокручиваемую строку
  Widget _categoriesSmallSize(
          List<PlaceType> catalog, List<Map<String, dynamic>> selectedCat) =>
      SliverToBoxAdapter(
        child: Container(
          height: 100.0,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: catalog.length,
              itemBuilder: (context, index) {
                return FilterCategoryItem(
                  placeType: catalog[index],
                  selectedCat: selectedCat[index],
                );
              }),
        ),
      );

  /// заголовок для слайдера
  Widget _buildHeaderSlider() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              filterTitleSlider,
              style: Theme.of(context).primaryTextTheme.subtitle1,
            ),
            Text(
              'от ${_convertMeterToKm(_currentRangeValues.start)} до ${_convertMeterToKm(_currentRangeValues.end)}',
              style: Theme.of(context).primaryTextTheme.subtitle1!.copyWith(
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
            //   _filteredData = filterData(
            //       data: _fullData, // база карточек
            //       categories: _filteredCategories, // выбранные категории
            //       centerPoint: _startSearchPoint, // точка отсчёта расстояния
            //       distance: _currentRangeValues);
          });
        },
      );

  /// оставляем только выбранные категории и передаем их в фильтр для поиска
  List<String> _filterCategories(List<Map<String, dynamic>> categories) {
    List<String> result = [];

    categories.where((cat) => cat['isSelected'] == true).forEach((cat) {
      result.add(cat['type']);
    });

    return result;
  }

  /// создаём карту со всеми типами мест и метками текущего состояния категории
  /// выбрано / не выбрано
  /// со старта все false если ничего не было выбрано ранее
  List<Map<String, dynamic>> _startCategories(List<PlaceType> categories) {
    return categories
        .map((e) => {'type': e.code, 'isSelected': false})
        .toList();
  }

  /// если пришли настройки фильтра с предыдущего экрана применяем выбранные категории
  List<Map<String, dynamic>> _currentStatusCategories(
      List<Map<String, dynamic>> categories, List<String> filteredCategories) {
    for (var cat in categories) {
      cat['isSelected'] = filteredCategories.contains(cat['type']);
    }
    return categories;
  }

  /// очистка фильтра по кнопке Очистить
  void _onClearFilter() {
    setState(() {
      _selectedCategories = _clearCategories(categories);
      _currentRangeValues = _startDataSlider();
      // _filteredData.clear();
      _isButtonEnabled = false;
      _onPressed = null;
    });
  }

  /// очистка выбранных категорий
  List<Map<String, dynamic>> _clearCategories(List<PlaceType> categories) {
    _filteredCategories.clear();

    return categories
        .map((e) => {'type': e.code, 'isSelected': false})
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
RangeValues _startDataSlider() => rangeSliderFilterAfterReset;
