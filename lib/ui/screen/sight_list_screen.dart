import 'package:flutter/material.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/domain/card_type.dart';
import 'package:places/domain/sight.dart';
import 'package:places/mocks.dart';
import 'package:places/ui/screen/components/bottom_navigationbar.dart';
import 'package:places/ui/screen/components/button_gradient.dart';
import 'package:places/ui/screen/filters_screen.dart';
import 'package:places/ui/screen/add_sight_screen.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/widgets/list_cards.dart';
import 'package:places/ui/screen/components/search_bar_static.dart';
import 'package:places/ui/screen/sight_search_screen.dart';
import 'package:places/ui/screen/utilities/filter_utility.dart';

/// список интересных мест
class SightListScreen extends StatefulWidget {
  static _SightListScreenState? of(BuildContext context) =>
      context.findAncestorStateOfType<_SightListScreenState>();

  @override
  _SightListScreenState createState() => _SightListScreenState();
}

class _SightListScreenState extends State<SightListScreen> {
  /// нефильтрованные данные если юзер не настраивал фильтр
  final List<Sight> _fullData = mocks;

  /// текущие настройки фильтра, получаем их из экрана фильтрации
  FilterSettings? _currentFilter;

  /// отфильтрованные данные
  List<Sight> _filteredData = [];

  @override
  void initState() {
    PlaceInteractor().getPlaces();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                _buildSliverAppBar(orientation),
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        orientation == Orientation.portrait ? 16.0 : 34.0,
                  ),
                  sliver: _buildListCard(orientation,
                      data:
                          _filteredData.isNotEmpty ? _filteredData : _fullData),
                ),
              ],
            ),
          ),
          floatingActionButton: ButtonGradient(onPressed: _onPressedAddNewCard),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          bottomNavigationBar: const MainBottomNavigationBar(current: 0),
        );
      },
    );
  }

  /// SliverAppBar в зависимости от ориентации экрана
  Widget _buildSliverAppBar(Orientation orientation) {
    if (orientation == Orientation.portrait) {
      return _SliverAppBarPortrait(
        onTapSearch: _onTapSearch,
        onPressedFilter: _onPressedFilter,
      );
    } else {
      return _SliverAppBarLandscape(
        onTapSearch: _onTapSearch,
        onPressedFilter: _onPressedFilter,
      );
    }
  }

  /// отображение списка карточек в зависимости от ориентации экрана
  Widget _buildListCard(Orientation orientation, {required List<Sight> data}) {
    if (orientation == Orientation.portrait) {
      return ListCardsPortrait(
        data: data,
        cardType: CardType.search,
      );
    } else {
      return ListCardsLandscape(
        data: data,
        cardType: CardType.search,
      );
    }
  }

  /// нажатие на градиентную кнопку - переходим на экран добавления
  void _onPressedAddNewCard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSightScreen(),
      ),
    );
  }

  /// передаем фильтр на экран поиска
  void _onTapSearch() async {
    final FilterSettings? _filter = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SightSearchScreen(filter: _currentFilter),
      ),
    );
    setState(() {
      _currentFilter = _filter;
      _filteredData = filterData(
          data: _fullData,
          categories: _currentFilter!.categories,
          centerPoint: _currentFilter!.centerPoint,
          distance: _currentFilter!.distance);
    });
  }

  /// переход на экран фильтра
  /// настройки фильтра возвращаем сюда и фильтруем данные
  _onPressedFilter() async {
    final FilterSettings? _filter = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FiltersScreen(filter: _currentFilter),
      ),
    );
    setState(() {
      _currentFilter = _filter;
      _filteredData = filterData(
          data: _fullData,
          categories: _currentFilter!.categories,
          centerPoint: _currentFilter!.centerPoint,
          distance: _currentFilter!.distance);
    });
  }
}

/// appBar портретная ориентация
class _SliverAppBarPortrait extends StatelessWidget {
  final VoidCallback? onTapSearch;
  final VoidCallback? onPressedFilter;

  const _SliverAppBarPortrait({
    Key? key,
    this.onTapSearch,
    this.onPressedFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 216.0,
      floating: false,
      pinned: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        double top = constraints.biggest.height;
        return FlexibleSpaceBar(
          centerTitle: true,
          title: AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: top == 56.0 ? 1.0 : 0.0,
            child: Text(
              searchAppBarTitle,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          background: Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              children: [
                Positioned(
                  bottom: 104,
                  child: Text(
                    appBarTitle,
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
                Positioned(
                  bottom: 34,
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tight(
                      Size(constraints.maxWidth - 32, heightInput),
                    ),
                    child: SearchBarStatic(
                      onTapSearch: onTapSearch,
                      onPressedFilter: onPressedFilter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

/// appBar ландшафтная ориентация
class _SliverAppBarLandscape extends StatelessWidget {
  final VoidCallback? onTapSearch;
  final VoidCallback? onPressedFilter;

  const _SliverAppBarLandscape({
    Key? key,
    this.onTapSearch,
    this.onPressedFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 112.0,
      floating: false,
      pinned: true,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          searchAppBarTitle,
          style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      ),
      flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return FlexibleSpaceBar(
          background: Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 34),
            child: Stack(
              children: [
                Positioned(
                  bottom: 14,
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tight(
                      Size(constraints.maxWidth - 68, heightInput),
                    ),
                    child: SearchBarStatic(
                      onTapSearch: onTapSearch,
                      onPressedFilter: onPressedFilter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
