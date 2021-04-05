import 'package:flutter/material.dart';
import 'package:places/data/interactor/settings_interactor.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/card_type.dart';
import 'package:places/main.dart';
import 'package:places/ui/screen/components/bottom_navigationbar.dart';
import 'package:places/ui/screen/components/button_gradient.dart';
import 'package:places/ui/screen/filters_screen.dart';
import 'package:places/ui/screen/add_place_screen/add_place_screen.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/widgets/list_cards.dart';
import 'package:places/ui/screen/components/search_bar_static.dart';
import 'package:places/ui/screen/sight_search_screen.dart';

/// список интересных мест
/// главная страница
class PlaceListScreen extends StatefulWidget {
  static _PlaceListScreenState? of(BuildContext context) =>
      context.findAncestorStateOfType<_PlaceListScreenState>();

  @override
  _PlaceListScreenState createState() => _PlaceListScreenState();
}

class _PlaceListScreenState extends State<PlaceListScreen> {
  /// фильтр для поиска
  /// при первом запуске берётся дефолтный из настроек программы
  /// при изменении перезаписывается на пользовательский
  late SearchFilter _searchFilter;

  /// фильтр - получаем из раздела настроек локальной базы данных
  void _getStartData() async {
    _searchFilter = await SettingsInteractor.getSearchFilter();
    placeInteractor.getFilteredPlace(filter: _searchFilter);
  }

  @override
  void initState() {
    _getStartData();

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
                  sliver: StreamBuilder<List<Place>>(
                    stream: placeInteractor.listPlaces,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
                      }

                      return _buildListCard(orientation, data: snapshot.data);
                    },
                  ),
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
  Widget _buildListCard(Orientation orientation,
      {required List<Place> data}) {
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
        builder: (context) => AddPlaceScreen(),
      ),
    );
  }

  /// передаем текущий фильтр на экран поиска
  void _onTapSearch() async {
    final SearchFilter _newFilter = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SightSearchScreen(filter: _searchFilter),
      ),
    );
    setState(() {
      /// при возврате заменяем на новый
      _searchFilter = _newFilter;
    });
  }

  /// переход на экран фильтра
  /// настройки фильтра возвращаем сюда и фильтруем данные
  _onPressedFilter() async {
    final SearchFilter _newFilter = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FiltersScreen(filter: _searchFilter),
      ),
    );
    setState(() {
      _searchFilter = _newFilter;
    });
  }
}

/// appBar портретная ориентация
class _SliverAppBarPortrait extends StatelessWidget {
  final VoidCallback onTapSearch;
  final VoidCallback onPressedFilter;

  const _SliverAppBarPortrait({
    Key? key,
    required this.onTapSearch,
    required this.onPressedFilter,
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
  final VoidCallback onTapSearch;
  final VoidCallback onPressedFilter;

  const _SliverAppBarLandscape({
    Key? key,
    required this.onTapSearch,
    required this.onPressedFilter,
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
