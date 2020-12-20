import 'package:flutter/material.dart';

import 'package:places/domain/sight.dart';
import 'package:places/mocks.dart';
import 'package:places/ui/screen/sight_card.dart';
import 'package:places/ui/screen/sight_list_screen_constant.dart';
import 'package:places/components/bottom_NavigationBar.dart';

class SightListScreen extends StatefulWidget {
  @override
  _SightListScreenState createState() => _SightListScreenState();
}

class _SightListScreenState extends State<SightListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(152),
        child: AppBar(
          flexibleSpace: Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Text(
                appBarTitle,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
          ),
        ),
      ),
      body: BuildCardScreen(
        data: mocks,
        whereShowCard: WhereShowCard.search,
      ),
      bottomNavigationBar: MainBottomNavigationBar(current: 0),
    );
  }
}
