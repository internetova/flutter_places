import 'package:flutter/material.dart';

import 'package:places/constant.dart';
import 'package:places/mocks.dart';
import 'package:places/domain/sight.dart';
import 'package:places/ui/screen/sight_card.dart';
import 'package:places/ui/screen/visiting_screen_constant.dart';
import 'package:places/components/bottom_NavigationBar.dart';

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
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              height: 40,
              decoration: BoxDecoration(
                color: colorBackground,
                borderRadius: BorderRadius.circular(40),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: colorSecondary,
                  borderRadius: BorderRadius.circular(40),
                ),
                unselectedLabelColor: colorInactiveBlack,
                labelStyle: textStyleLabelFavorites,
                tabs: [
                  Tab(
                    text: tabPlanned,
                  ),
                  Tab(
                    text: tabVisited,
                  ),
                ],
                indicatorColor: Colors.transparent,
                indicatorWeight: 0.01,
              ),
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: TabBarView(
          children: [
            buildFavorites(data: mocks, typeCard: FavoritesCard.planned),
            buildFavorites(data: mocks, typeCard: FavoritesCard.visited),
          ],
        ),
        bottomNavigationBar: MainBottomNavigationBar(current: 2),
      ),
    );
  }
}

/// информация когда карточек нет в разделе
class BlankScreen extends StatelessWidget {
  const BlankScreen(
      {Key key,
      @required this.icon,
      @required this.header,
      @required this.text})
      : super(key: key);
  final Widget icon;
  final Text header;
  final Text text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(height: 24),
          header,
          SizedBox(height: 8),
          text,
        ],
      ),
    );
  }
}

/// строим карточки для Избранного
/// у карточки в данных может быть поле Посетить или Посетил
/// ‼️🤓🤓 знаю, что функция корявая, более изящного в голову пока не приходит
/// уверена, что она ВРЕМЕННАЯ, по ходу буду рефакторить
Widget buildFavorites(
    {@required List<Sight> data, @required FavoritesCard typeCard}) {
  Widget favTabBarView;
  var favorites = <Sight>[];

  /// ищем в базе карточки с соответствующим типом
  /// хочу посетить
  if (typeCard == FavoritesCard.planned) {
    favorites = data.where((item) => item.planned != null).toList();

    /// если нет таких, то показываем заглушку
    if (favorites.isEmpty) {
      favTabBarView = BlankScreen(
        icon: blankScreenIconPlanned,
        header: blankScreenHeaderPlanned,
        text: blankScreenTextPlanned,
      );
    } else {
      /// иначе выводим карточки
      favTabBarView = BuildCardScreen(
        data: favorites,
        whereShowCard: WhereShowCard.planned,
      );
    }
  }

  /// посетил
  if (typeCard == FavoritesCard.visited) {
    favorites = data.where((item) => item.visited != null).toList();

    if (favorites.isEmpty) {
      favTabBarView = BlankScreen(
        icon: blankScreenIconVisited,
        header: blankScreenHeaderVisited,
        text: blankScreenTextVisited,
      );
    } else {
      favTabBarView = BuildCardScreen(
        data: favorites,
        whereShowCard: WhereShowCard.visited,
      );
    }
  }

  return favTabBarView;
}
