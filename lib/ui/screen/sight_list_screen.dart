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
          style: kFontLargeTitle,
        ),
        backgroundColor: Colors.transparent,
        toolbarHeight: 112.0,
        elevation: 0,
      ),
      body: Center(
        child: Text('Hello!'),
      ),
    );
  }
}
