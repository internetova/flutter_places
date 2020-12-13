import 'package:flutter/material.dart';

import 'package:places/constant.dart';
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
      backgroundColor: colorWhite,
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
      body: BuildCardScreen(data: mocks, whereShowCard: WhereShowCard.search),
      bottomNavigationBar: MainBottomNavigationBar(current: 0),
    );
  }
}
