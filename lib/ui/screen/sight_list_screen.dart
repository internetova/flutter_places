import 'package:flutter/material.dart';
import '../../constant.dart';

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

const appBarTitle = <TextSpan>[
  TextSpan(
    text: 'С',
    style: TextStyle(color: kColorWhiteGreen),
  ),
  TextSpan(
    text: 'писок\n',
  ),
  TextSpan(
    text: 'и',
    style: TextStyle(color: kColorWhiteYellow),
  ),
  TextSpan(
    text: 'нтересных мест',
  ),
];
