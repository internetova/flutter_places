import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Модуль 3 задача 5',
      home: MySecondWidget(
        title: 'MyFirstWidget',
      ),
    );
  }
}

class MyFirstWidget extends StatelessWidget {
  const MyFirstWidget({Key key, this.title}) : super(key: key);
  final title;

  // void getContext() => print(context.runtimeType); // ошибка Undefined name 'context'

  @override
  Widget build(BuildContext context) {
    int _counter = 0;
    _counter++;
    print('счётчик: $_counter');

    return Container(
      child: Center(
        child: Text('Hello'),
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

  void getContext() => print('контекст: ${context.runtimeType}');

  @override
  Widget build(BuildContext context) {
    _incrementCounter();
    print('счётчик: $_counter');
    getContext();

    return Container(
      child: Center(
        child: Text('Hello!'),
      ),
    );
  }
}
