import 'package:flutter/material.dart';

import 'package:places/mocks.dart';
import 'package:places/domain/sight.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/sight_card.dart';
import 'package:places/components/bottom_navigationbar.dart';
import 'package:places/ui/screen/widgets/empty_page.dart';

/// экран с избранными карточками - Хочу посетить / Посетил
class VisitingScreen extends StatefulWidget {
  @override
  _VisitingScreenState createState() => _VisitingScreenState();
}

class _VisitingScreenState extends State<VisitingScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: titleScreenFavorites,
          backgroundColor: Colors.transparent,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
            buildFavorites(
              data: mocks,
              typeCard: WhereShowCard.planned,
            ),
            buildFavorites(
              data: mocks,
              typeCard: WhereShowCard.visited,
            ),
          ],
        ),
        bottomNavigationBar: const MainBottomNavigationBar(current: 2),
      ),
    );
  }
}

/// строим карточки для Избранного
/// в зависимости от типа избранного
Widget buildFavorites({
  @required List<Sight> data,
  @required WhereShowCard typeCard,
}) {
  Widget favTabBarView;
  var favorites = <Sight>[];

  /// ищем в базе карточки с соответствующим типом
  favorites = data.where((item) => item.favorites == typeCard).toList();

  /// если нет таких, то показываем заглушку
  if (favorites.isEmpty) {
    final screenContent = favoritesBlankScreenContent
        .where((item) => item['typeCard'] == typeCard)
        .toList();

    favTabBarView = EmptyPage(
      icon: screenContent[0]['blankScreenIcon'],
      header: screenContent[0]['blankScreenHeader'],
      text: screenContent[0]['blankScreenText'],
    );
  } else {
    /// иначе выводим карточки
    favTabBarView = BuildCardScreen(
      data: favorites,
      whereShowCard: typeCard,
    );
  }

  return favTabBarView;
}
