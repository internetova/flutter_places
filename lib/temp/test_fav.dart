import 'dart:async';

import 'package:flutter/material.dart';
import 'package:places/ui/screen/components/icon_action_button.dart';
import 'package:places/ui/screen/res/assets.dart';

/// тестирование кнопки избранное
class TestFav extends StatefulWidget {
  @override
  _TestFavState createState() => _TestFavState();
}

class _TestFavState extends State<TestFav> {
  bool testItemId = true;

  var _favController = StreamController<bool>();

  @override
  void dispose() {
    _favController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Кнопка Избранное'),
      ),
      body: Center(
        child: StreamBuilder<bool>(
          stream: _favController.stream,
          initialData: testItemId,
          builder: (context, snapshot) {

            if (snapshot.hasData) {
              final bool isFav = snapshot.data!;

              return Container(
                width: 80,
                height: 80,
                color: Colors.teal,
                child: IconActionButton(
                  onPressed: () {
                    testItemId = !testItemId;
                    _favController.sink.add(testItemId);
                    print('onPressed Избранное $testItemId');
                  },
                  icon: isFav ? icFavoritesFull : icFavorites,
                  width: 60,
                  height: 60,
                ),
              );
            }

            return const SizedBox.shrink();
          }
        ),
      ),
    );
  }
}
