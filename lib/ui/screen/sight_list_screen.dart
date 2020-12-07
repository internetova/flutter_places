import 'package:flutter/material.dart';

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
        title: RichText(
          text: TextSpan(
            style: kFontLargeTitle,
            children: appBarTitle,
          ),
          textAlign: TextAlign.left,
        ),
        toolbarHeight: 112.0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          'Hello !',
        ),
      ),
    );
  }
}
