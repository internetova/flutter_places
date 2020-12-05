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
        title: Text(
          'Список\nинтересных мест',
          style: TextStyle(
            color: kColorWhiteSecondary,
            fontFamily: 'Roboto',
            fontSize: 32.0,
            height: 1.125,
            fontWeight: FontWeight.w700,
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
