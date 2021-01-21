import 'package:flutter/material.dart';
import 'package:places/data.dart';

import 'package:places/domain/sight.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/components/bottom_navigationbar.dart';
import 'package:places/ui/screen/widgets/empty_page.dart';
import 'package:places/ui/screen/widgets/sight_card_visiting.dart';

/// экран с избранными карточками - Хочу посетить / Посетил
class VisitingScreen extends StatefulWidget {
  /// для обновления стэйта после удаления карточки из дочерних виджетов
  static _VisitingScreenState of(BuildContext context) =>
      context.findAncestorStateOfType<_VisitingScreenState>();

  @override
  _VisitingScreenState createState() => _VisitingScreenState();
}

class _VisitingScreenState extends State<VisitingScreen> {
  List<Sight> _userDataPlanned = [];
  List<Sight> _userDataVisited = [];

  @override
  void initState() {
    _userDataPlanned = _getCurrentData(
      data: favoritesSight,
      typeCard: WhereShowCard.planned,
    );

    _userDataVisited = _getCurrentData(
      data: favoritesSight,
      typeCard: WhereShowCard.visited,
    );

    super.initState();
  }

  /// обновить базу данных после удаления карточки
  /// буду вызывать из дочернего виджета
  void updateState() {
    setState(() {
      _userDataPlanned = _getCurrentData(
        data: favoritesSight,
        typeCard: WhereShowCard.planned,
      );

      _userDataVisited = _getCurrentData(
        data: favoritesSight,
        typeCard: WhereShowCard.visited,
      );
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
        ),
        body: TabBarView(
          children: [
            _buildFavorites(
              data: _userDataPlanned,
              typeCard: WhereShowCard.planned,
            ),
            _buildFavorites(
              data: _userDataVisited,
              typeCard: WhereShowCard.visited,
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
    @required List<Sight> data,
    @required WhereShowCard typeCard,
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
        children: [
          for (var card in data) ...[
            SightCardVisiting(
              key: ValueKey(card),
              card: card,
              whereShowCard: typeCard,
            ),
          ],
        ],
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
  List<Sight> _getCurrentData(
          {@required List<Sight> data, @required WhereShowCard typeCard}) =>
      data.where((item) => item.favorites == typeCard).toList();
}
