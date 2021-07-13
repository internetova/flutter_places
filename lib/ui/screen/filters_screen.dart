import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/blocs/filters_screen/button/filter_button_cubit.dart';
import 'package:places/blocs/filters_screen/filter/filter_cubit.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/data/model/place_type.dart';
import 'package:places/data/model/object_position.dart';
import 'package:places/ui/components/button_save.dart';
import 'package:places/ui/components/icon_leading_appbar.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/sizes.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/widgets/filter_category_item.dart';

/// экран фильтра для поиска
/// выбираем типы мест и расстояние
/// сервер принимает только одно расстояние - радиус, поэтому
/// Range слайдер переделала в слайдер
class FiltersScreen extends StatefulWidget {
  final ObjectPosition userLocation;
  final SearchFilter filter;

  const FiltersScreen({
    Key? key,
    required this.userLocation,
    required this.filter,
  }) : super(key: key);

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  /// список всех типов мест - категорий
  final List<PlaceType> categories = PlaceType.getList;

  @override
  void initState() {
    super.initState();

    /// старт поиска при изменении параметров фильтра для отображения
    /// результата на кнопке Показать
    context.read<FilterButtonCubit>().startSearchFilter(widget.userLocation);
  }

  @override
  Widget build(BuildContext context) {
    /// физическая ширина и высота экрана
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;

    return BlocListener<FilterCubit, FilterState>(
      listener: (context, state) {
        if (state.filteredCategories.isNotEmpty) {
          context.read<FilterButtonCubit>().onChangedFilter(
                SearchFilter(
                  typeFilter: state.filteredCategories,
                  radius: state.radius,
                ),
              );
        } else {
          context.read<FilterButtonCubit>().clear();
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            _BuildFilterAppBar(
              onPressedBack: _back,
              onPressedClearFilter: _onClearFilter,
            ),
            // _buildFilterAppBar(),
            _BuildTitleFilter(),
            _BuildCategories(
              width: _screenWidth,
              height: _screenHeight,
              catalog: categories,
              selectedCat: context.read<FilterCubit>().state.mapCategories,
            ),
            _BuildSliderGroup(),
            _BuildButtonShowResult(onPressed: _showResult),
          ],
        ),
      ),
    );
  }

  /// для кнопки с результатами
  void _showResult() {
    final _newSearchFilter = SearchFilter(
      radius: context.read<FilterCubit>().state.radius,
      typeFilter: context.read<FilterCubit>().state.filteredCategories,
    );

    Navigator.pop(context, _newSearchFilter);
  }

  /// очистка фильтра по кнопке Очистить
  void _onClearFilter() {
    context.read<FilterCubit>().clear();
    context.read<FilterButtonCubit>().clear();
  }

  /// вернуться на предыдущий экран без сохранения
  void _back() {
    Navigator.pop(context, widget.filter);
  }
}

/// AppBar
class _BuildFilterAppBar extends StatelessWidget {
  final VoidCallback onPressedBack;
  final VoidCallback onPressedClearFilter;

  const _BuildFilterAppBar({
    Key? key,
    required this.onPressedBack,
    required this.onPressedClearFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: toolbarHeightStandard,
      leading: SmallLeadingIcon(
        icon: icArrow,
        onPressed: onPressedBack,
      ),
      leadingWidth: 64,
      elevation: 0,
      pinned: true,
      title: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: onPressedClearFilter,
          child: Text(
            filterClearFilters,
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  color: Theme.of(context).accentColor,
                ),
          ),
        ),
      ),
    );
  }
}

/// Заголовок фильтра
class _BuildTitleFilter extends StatelessWidget {
  const _BuildTitleFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 24.0,
        ),
        child: Text(
          filterTitleCategories,
          style: Theme.of(context).textTheme.caption!.copyWith(
                color: Theme.of(context).colorScheme.inactiveBlack,
              ),
        ),
      ),
    );
  }
}

/// список карточек категорий для нормальных экранов
/// показываем карточки гридами - SliverGrid
class _CategoriesNormalSize extends StatelessWidget {
  final List<PlaceType> catalog;
  final List<Map<String, dynamic>> selectedCat;

  const _CategoriesNormalSize({
    Key? key,
    required this.catalog,
    required this.selectedCat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
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
            onPressed: () {
              context.read<FilterCubit>().onTap(catalog[index].code);
            },
          );
        },
        childCount: catalog.length,
      ),
    );
  }
}

/// список карточек категорий для маленьких экранов 375 х 667 iphone 8
/// показываем категории в одну прокручиваемую строку - ListView
class _CategoriesSmallSize extends StatelessWidget {
  final List<PlaceType> catalog;
  final List<Map<String, dynamic>> selectedCat;

  const _CategoriesSmallSize({
    Key? key,
    required this.catalog,
    required this.selectedCat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      sliver: SliverToBoxAdapter(
        child: Container(
          height: 100.0,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: catalog.length,
              itemBuilder: (context, index) {
                return FilterCategoryItem(
                  placeType: catalog[index],
                  selectedCat: selectedCat[index],
                  onPressed: () {
                    context.read<FilterCubit>().onTap(catalog[index].code);
                  },
                );
              }),
        ),
      ),
    );
  }
}

/// категории в зависимости от разрешения экрана
/// по заданию на разных экранах сделать разное отображение
/// [width] - ширина экрана
/// [height] - высота экрана
/// [catalog] - список типов мест (парк, отель и т.д.)
/// [selectedCat] - карта с выбранными типами мест
class _BuildCategories extends StatelessWidget {
  final double width;
  final double height;
  final List<PlaceType> catalog;
  final List<Map<String, dynamic>> selectedCat;

  const _BuildCategories({
    Key? key,
    required this.width,
    required this.height,
    required this.catalog,
    required this.selectedCat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (_, state) {
        return width <= 375 && height <= 667 // iphone 8
            ? _CategoriesSmallSize(
                catalog: catalog,
                selectedCat: selectedCat,
              )
            : _CategoriesNormalSize(
                catalog: catalog,
                selectedCat: selectedCat,
              );
      },
    );
  }
}

/// группа Слайдер. Включает заголовок с изменяемым расстоянием и сам слайдер
class _BuildSliderGroup extends StatelessWidget {
  const _BuildSliderGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 24.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BuildHeaderSlider(),
              BlocBuilder<FilterCubit, FilterState>(
                builder: (_, state) {
                  return _BuildSlider();
                },
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

/// заголовок для слайдера
class _BuildHeaderSlider extends StatelessWidget {
  const _BuildHeaderSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            filterTitleSlider,
            style: Theme.of(context).primaryTextTheme.subtitle1,
          ),
          Text(
            'до ${_convertMeterToKm(context.watch<FilterCubit>().state.radius)}',
            style: Theme.of(context).primaryTextTheme.subtitle1!.copyWith(
                color: Theme.of(context).colorScheme.secondaryVariant),
          ),
        ],
      ),
    );
  }
}

/// для заголовка слайдера строка Расстояние метры в километры
String _convertMeterToKm(double value) {
  if (value < 1000) {
    return '${value.toStringAsFixed(0)} м';
  } else {
    return '${(value / 1000).toStringAsFixed(2)} км';
  }
}

/// слайдер
class _BuildSlider extends StatelessWidget {
  const _BuildSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, state) {
        return Slider(
          min: rangeSliderFilterDefault.start,
          max: rangeSliderFilterDefault.end,
          value: state.radius,
          onChanged: (double value) =>
              context.read<FilterCubit>().onChanged(value),
        );
      },
    );
  }
}

/// кнопка показать
class _BuildButtonShowResult extends StatelessWidget {
  final VoidCallback onPressed;

  const _BuildButtonShowResult({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: BlocBuilder<FilterButtonCubit, FilterButtonState>(
          builder: (context, state) {
            return AnimatedSwitcher(
              duration: milliseconds300,
              child: ButtonSave(
                key: ValueKey(state),
                title: state.title,
                isButtonEnabled: state.isEnabled,
                onPressed: state.isEnabled ? onPressed : null,
              ),
            );
          },
        ),
      ),
    );
  }
}
