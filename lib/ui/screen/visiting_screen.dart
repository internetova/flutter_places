import 'package:flutter/material.dart';
import 'package:places/components/bottom_NavigationBar.dart';
import 'package:places/constant.dart';
import 'package:places/domain/sight.dart';
import 'package:places/ui/screen/sight_card.dart';
import 'package:places/ui/screen/visiting_screen_constant.dart';
import 'package:places/mocks.dart';

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
                color: colorSecondary,
                borderRadius: BorderRadius.circular(40),
              ),
              child: TabBar(
                tabs: [
                  Tab(
                    text: tabPlaned,
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        SizedBox(height: 24),
        header,
        SizedBox(height: 8),
        text,
      ],
    );
  }
}

/// строим карточки для избранного
/// у карточки в данных может быть поле Посетить / Посетил
/// ‼️🤓🤓 возможно функция корявая, позже придумаю что-то более изящное
Widget buildFavorites(
    {@required List<Sight> data, @required FavoritesCard typeCard}) {
  Widget favTabBarView;
  var favorites = <Widget>[];

  /// ищем в базе карточки с соответствующим типом
  if (typeCard == FavoritesCard.planned) {
    favorites = data
        .where((item) => item.planned != null)
        .map((item) =>
            SightCard(card: item, whereShowCard: WhereShowCard.planned))
        .toList();

    /// если нет таких, то показываем заглушку
    if (favorites.isEmpty) {
      favTabBarView = Center(
        child: BlankScreen(
          icon: blankScreenIconWill,
          header: blankScreenHeaderWill,
          text: blankScreenTextWill,
        ),
      );
    } else {
      /// иначе выводим карточки
      favTabBarView = SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              for (var card in favorites) ...[card, SizedBox(height: 16)],
            ],
          ),
        ),
      );
    }
  }

  if (typeCard == FavoritesCard.visited) {
    favorites = data
        .where((item) => item.visited != null)
        .map((item) =>
            SightCard(card: item, whereShowCard: WhereShowCard.visited))
        .toList();

    if (favorites.isEmpty) {
      favTabBarView = Center(
        child: BlankScreen(
          icon: blankScreenIconWas,
          header: blankScreenHeaderWas,
          text: blankScreenTextWas,
        ),
      );
    } else {
      favTabBarView = SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              for (var card in favorites) ...[card, SizedBox(height: 16)],
            ],
          ),
        ),
      );
    }
  }

  return favTabBarView;
}
