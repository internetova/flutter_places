import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyFirstWidget(title: 'Flutter Demo'),
    );
  }
}

class MyFirstWidget extends StatelessWidget {
  const MyFirstWidget({Key key, this.title}) : super(key: key);
  final title;

  @override
  Widget build(BuildContext context) {
    int _counter = 0;
    _counter++;
    print(_counter);

    return Container(
      child: Center(
        child: Text('Hello! - $_counter'),
      ),
    );
  }
}

class MySecondWidget extends StatefulWidget {
  MySecondWidget({Key key, this.title}) : super(key: key);
  final title;

  @override
  _MySecondWidgetState createState() => _MySecondWidgetState();
}

class _MySecondWidgetState extends State<MySecondWidget> {
int _counter = 0;

void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    _incrementCounter();
    print(_counter);

    return Container(
      child: Center(
        child: Text('Hello! - $_counter'),
      ),
    );
  }
}
