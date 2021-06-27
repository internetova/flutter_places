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
            BlocBuilder<FilterCubit, FilterState>(
              builder: (_, state) {
                return _buildCategories(
                  _screenWidth,
                  _screenHeight,
                );
              },
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
                      BlocBuilder<FilterCubit, FilterState>(
                        builder: (_, state) {
                          return _buildSlider();
                        },
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            SliverFillRemaining(
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
                        onPressed: state.isEnabled ? _showResult : null,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// кнопка с результатами
  void _showResult() {
    final _newSearchFilter = SearchFilter(
      radius: context.read<FilterCubit>().state.radius,
      typeFilter: context.read<FilterCubit>().state.filteredCategories,
    );

    Navigator.pop(context, _newSearchFilter);
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
            context.read<FilterCubit>().state.mapCategories,
          )
        : SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            sliver: _categoriesNormalSize(
              categories,
              context.read<FilterCubit>().state.mapCategories,
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
              onPressed: () {
                context.read<FilterCubit>().onTap(catalog[index].code);
              },
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
                  onPressed: () {
                    context.read<FilterCubit>().onTap(catalog[index].code);
                  },
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
              'до ${_convertMeterToKm(context.watch<FilterCubit>().state.radius)}',
              style: Theme.of(context).primaryTextTheme.subtitle1!.copyWith(
                  color: Theme.of(context).colorScheme.secondaryVariant),
            ),
          ],
        ),
      );

  /// слайдер
  Widget _buildSlider() => Slider(
        min: rangeSliderFilterDefault.start,
        max: rangeSliderFilterDefault.end,
        value: context.read<FilterCubit>().state.radius,
        onChanged: (double value) {
          context.read<FilterCubit>().onChanged(value);
        },
      );

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

/// для слайдера строка Расстояние метры в километры
String _convertMeterToKm(double value) {
  if (value < 1000) {
    return '${value.toStringAsFixed(0)} м';
  } else {
    return '${(value / 1000).toStringAsFixed(2)} км';
  }
}
