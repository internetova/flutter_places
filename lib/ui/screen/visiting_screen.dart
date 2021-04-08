import 'package:flutter/material.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/card_type.dart';
import 'package:places/main.dart';
import 'package:places/ui/screen/components/bottom_navigationbar.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/widgets/empty_page.dart';
import 'package:places/ui/screen/widgets/place_card_visiting.dart';

/// экран с избранными карточками - Хочу посетить / Посетил
class VisitingScreen extends StatefulWidget {
  /// для обновления стэйта после удаления карточки из дочерних виджетов
  static _VisitingScreenState? of(BuildContext context) =>
      context.findAncestorStateOfType<_VisitingScreenState>();

  @override
  _VisitingScreenState createState() => _VisitingScreenState();
}

class _VisitingScreenState extends State<VisitingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    /// обновляем данные при переходе на соответствующую вкладку
    _tabController.addListener(() {
      setState(() {});

      if (_tabController.index == 0) {
        favoritePlacesInteractor.getPlannedPlaces();
        print('_tabController0 ${_tabController.index}');
      } else {
        favoritePlacesInteractor.getVisitedPlaces();
        print('_tabController1 ${_tabController.index}');
      }
    });

    favoritePlacesInteractor.getPlannedPlaces();

    super.initState();
  }

  /// todo удаление карточек через интерактор
  /// обновить базу данных после удаления карточки
  /// буду вызывать из дочернего виджета
  void updateState() {
    setState(() {
      // _userDataPlanned = _getCurrentData(
      //   data: favoritesSight,
      //   typeCard: CardType.planned,
      // );
      //
      // _userDataVisited = _getCurrentData(
      //   data: favoritesSight,
      //   typeCard: CardType.visited,
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: titleScreenFavorites,
        backgroundColor: Colors.transparent,
        toolbarHeight: 156,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            margin: const EdgeInsets.only(
              left: 16.0,
              bottom: 30.0,
              right: 16.0,
            ),
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
              borderRadius: BorderRadius.circular(40),
            ),
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  text: tabPlanned,
                ),
                Tab(
                  text: tabVisited,
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          StreamBuilder<List<Place>>(
              stream: favoritePlacesInteractor.listFavorites,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return _buildExceptionInfo();
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return _buildFavorites(
                  data: snapshot.data,
                  typeCard: CardType.planned,
                );
              }),
          StreamBuilder<List<Place>>(
              stream: favoritePlacesInteractor.listFavorites,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return _buildExceptionInfo();
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return _buildFavorites(
                  data: snapshot.data,
                  typeCard: CardType.visited,
                );
              }),
        ],
      ),
      bottomNavigationBar: const MainBottomNavigationBar(current: 2),
    );
  }

  /// если есть ошибка
  Widget _buildExceptionInfo() => Center(
        child: EmptyPage(
            icon: appNetworkException['emptyScreenIcon']!,
            header: appNetworkException['emptyScreenHeader']!,
            text: appNetworkException['emptyScreenText']!),
      );

  /// строим карточки для Избранного
  /// в зависимости от типа избранного
  Widget _buildFavorites({
    required List<Place>? data,
    required CardType typeCard,
  }) {
    Widget favTabBarView;

    /// если нет таких, то показываем заглушку
    if (data!.isEmpty) {
      final screenContent = favoritesEmptyScreen
          .where((item) => item['typeCard'] == typeCard)
          .toList();

      favTabBarView = EmptyPage(
        icon: screenContent[0]['emptyScreenIcon'],
        header: screenContent[0]['emptyScreenHeader'],
        text: screenContent[0]['emptyScreenText'],
      );
    } else {
      favTabBarView = ReorderableListView(
        children: data
            .map((card) => PlaceCardVisiting(
                  key: ValueKey(card),
                  card: card,
                  cardType: typeCard,
                ))
            .toList(),
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }

            final newCard = data.removeAt(oldIndex);
            data.insert(newIndex, newCard);
          });
        },
      );
    }

    return favTabBarView;
  }
}
