import 'package:flutter/material.dart';

import 'package:places/domain/sight.dart';
import 'sight_card.dart';

import '../../mocks.dart';

import '../../constant.dart';
import 'sight_list_screen_constant.dart';

class SightListScreen extends StatefulWidget {
  @override
  _SightListScreenState createState() => _SightListScreenState();
}

class _SightListScreenState extends State<SightListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorWhiteWhite,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 16, top: 40, right: 16),
          child: appBarTitle,
        ),
        toolbarHeight: 112.0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: buildCard(mocks),
        ),
      ),
    );
  }
}

List<SightCard> buildCard(List<Sight> data) {
  var cards = <SightCard>[];

  for (var item in data) {
    cards.add(SightCard(card: item));
  }

  return cards;
}
