import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/repository/place_repository.dart';
import 'package:places/ui/screen/components/bottom_navigationbar.dart';
import 'package:places/ui/screen/res/sizes.dart';

/// тестирование запросов
class TestBackend extends StatefulWidget {
  final String title = 'Тестирование запросов';

  @override
  _TestBackendState createState() => _TestBackendState();
}

class _TestBackendState extends State<TestBackend> {
  PlaceRepository placeRepository = PlaceRepository();

  /// тестирование Пост запроса
  Map<String, dynamic> testDataPost = {
    'id': 1,
    'lat': 55.737064,
    'lng': 37.520018,
    'name': 'Триумфальная арка',
    'urls': ['https://architectureguru.ru/triumfalnaya-arka-v-moskve/'],
    'placeType': 'sight',
    'description': 'Триумфальная арка или Триумфальные ворота в Москве – объект культурного наследия, расположенный на Кутузовском проспекте. Памятник воздвигнут в честь победы русского народа над Наполеоном в 1812 году. Достопримечательность относится к самым известным триумфальным воротам и аркам мира.',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              child: Text('POST [/filtered_places]'),
              onPressed: () {},
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Color(0xff49CC90),
                minimumSize: Size(200, 40),
              ),
            ),
            sizedBoxH8,
            TextButton(
              child: Text('POST [/place]'),
              onPressed: () async {
                await placeRepository.postHTTP(testDataPost);
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Color(0xff49CC90),
                minimumSize: Size(200, 40),
              ),
            ),
            sizedBoxH8,
            TextButton(
              child: Text('GET [/place]'),
              onPressed: () async {
                await placeRepository.get();
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Color(0xff60AFFE),
                minimumSize: Size(200, 40),
              ),
            ),
            sizedBoxH8,
            TextButton(
              child: Text('GET [/place/{id}]'),
              onPressed: () async {
                await placeRepository.getItem();
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Color(0xff60AFFE),
                minimumSize: Size(200, 40),
              ),
            ),
            sizedBoxH8,
            TextButton(
              child: Text('DELETE [/place/{id}]'),
              onPressed: () {},
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Color(0xffF93E3F),
                minimumSize: Size(200, 40),
              ),
            ),
            sizedBoxH8,
            TextButton(
              child: Text('PUT [/place/{id}]'),
              onPressed: () {},
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Color(0xffFCA131),
                minimumSize: Size(200, 40),
              ),
            ),
            sizedBoxH8,
          ],
        ),
      ),
      bottomNavigationBar: MainBottomNavigationBar(
        current: 1,
      ),
    );
  }

  Widget _buildItem(Place place) => Card(
        margin: EdgeInsets.all(8.0),
        color: Colors.yellow[50],
        child: ListTile(
          title: Text(place.name),
          subtitle: Text(place.description),
          trailing: Text(place.placeType),
        ),
      );
}
