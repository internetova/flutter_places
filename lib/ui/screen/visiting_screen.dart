import 'package:flutter/material.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/card_type.dart';
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

class _VisitingScreenState extends State<VisitingScreen> {
  List<Place> _userDataPlanned = [];
  List<Place> _userDataVisited = [];

  @override
  void initState() {
    // _userDataPlanned = _getCurrentData(
    //   data: favoritesSight,
    //   typeCard: CardType.planned,
    // );
    //
    // _userDataVisited = _getCurrentData(
    //   data: favoritesSight,
    //   typeCard: CardType.visited,
    // );

    /// тест Interactor
    PlaceInteractor().getFavoritesPlaces();
    PlaceInteractor().getPlannedPlaces();
    PlaceInteractor().getVisitedPlaces();

    super.initState();
  }

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
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
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
          children: [
            _buildFavorites(
              data: _userDataPlanned,
              typeCard: CardType.planned,
            ),
            _buildFavorites(
              data: _userDataVisited,
              typeCard: CardType.visited,
            ),
          ],
        ),
        bottomNavigationBar: const MainBottomNavigationBar(current: 2),
      ),
    );
  }

  /// строим карточки для Избранного
  /// в зависимости от типа избранного
  Widget _buildFavorites({
    required List<Place> data,
    required CardType typeCard,
  }) {
    Widget favTabBarView;

    /// если нет таких, то показываем заглушку
    if (data.isEmpty) {
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

  /// получить текущую базу соответствующей вкладки
  // List<UiPlace> _getCurrentData({
  //   required List<UiPlace> data,
  //   required CardType typeCard,
  // }) =>
  //     data.where((item) => item.favorites == typeCard).toList();
}
