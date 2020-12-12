import 'package:flutter/material.dart';

import 'package:places/constant.dart';

import 'package:places/mocks.dart';
import 'package:places/domain/sight.dart';

import 'package:places/ui/screen/sight_card.dart';
import 'package:places/ui/screen/sight_list_screen_constant.dart';

class SightListScreen extends StatefulWidget {
  @override
  _SightListScreenState createState() => _SightListScreenState();
}

class _SightListScreenState extends State<SightListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhiteWhite,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(152),
        child: AppBar(
          flexibleSpace: Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: appBarTitle,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: buildCard(mocks),
          ),
        ),
      ),
    );
  }
}

/// строит массив виджетов для отображения списка карточек интересных мест
/// карточка и разделитель
List<Widget> buildCard(List<Sight> data) {
  var cards = <Widget>[];

  for (var item in data) {
    cards.add(SightCard(card: item));
    cards.add(SizedBox(height: 16));
  }

  return cards;
}
