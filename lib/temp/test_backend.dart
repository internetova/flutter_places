import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:places/data/api/api_client.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/search_filter.dart';
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
  PlaceRepository _placeRepository;

  /// для тестирования запросов
  final _testId = 157;

  /// фильтрация
  /// [radius] в метрах
  final SearchFilter _filter = SearchFilter(
    radius: 10000.0,
    typeFilter: ['cafe', 'park', 'other'],
    searchWords: 'натюрморт',
  );

  /// тестирование Пост запроса
  final Place _testAdd = Place(
    lat: 55.737064,
    lng: 37.520018,
    name: 'Тест',
    urls: [
      'https://picsum.photos/1000/600?random=1',
    ],
    placeType: 'other',
    description:
        'Следует отметить, что повышение уровня гражданского сознания способствует подготовке и реализации приоритизации разума над эмоциями. Предварительные выводы неутешительны: разбавленное изрядной долей эмпатии, рациональное мышление прекрасно подходит для реализации соответствующих условий активизации.',
  );

  final Place _testUpdate = Place(
    id: 139,
    lat: 55.737064,
    lng: 37.520018,
    name: 'Тест 2 удалить',
    urls: [
      'https://picsum.photos/1000/600?random=1',
    ],
    placeType: 'other',
    description:
        'Следует отметить, что повышение уровня гражданского сознания способствует подготовке и реализации приоритизации разума над эмоциями. Предварительные выводы неутешительны: разбавленное изрядной долей эмпатии, рациональное мышление прекрасно подходит для реализации соответствующих условий активизации.',
  );

  @override
  void initState() {
    _placeRepository = PlaceRepository(ApiClient());

    super.initState();
  }

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              child: Text('Фильтр POST [/filtered_places]'),
              onPressed: () async {
                final response = await _placeRepository.getPlaces(_filter);
                print('UI Фильтрация мест (${response.length} шт.): $response');
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Color(0xff49CC90),
                minimumSize: Size(300, 48),
              ),
            ),
            sizedBoxH8,
            TextButton(
              child: Text('addNewPlace: POST [/place]'),
              onPressed: () async {
                await _placeRepository.addNewPlace(_testAdd);
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Color(0xff49CC90),
                minimumSize: Size(300, 48),
              ),
            ),
            sizedBoxH24,
            // TextButton( ‼️🤓 скрыла, чтобы случайно много лишнего не добавить
            //   child: Text('!!! addPlacesList: POST [/place]'),
            //   onPressed: () async {
            //     await _placeRepository.addPlacesList(dataPlacesList);
            //   },
            //   style: TextButton.styleFrom(
            //     primary: Colors.white,
            //     backgroundColor: Color(0xff49CC90),
            //     minimumSize: Size(300, 48),
            //   ),
            // ),
            // sizedBoxH24,
            TextButton(
              child: Text('Все места GET [/place]'),
              onPressed: () async {
                final response = await _placeRepository.getAllPlaces();
                print('UI Список мест (${response.length} шт.): $response');
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Color(0xff60AFFE),
                minimumSize: Size(300, 48),
              ),
            ),
            sizedBoxH8,
            TextButton(
              child: Text('Место по ID GET [/place/{$_testId}]'),
              onPressed: () async {
                final response = await _placeRepository.getPlaceDetail(_testId);
                print('UI Место: $response');
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Color(0xff60AFFE),
                minimumSize: Size(300, 48),
              ),
            ),
            sizedBoxH24,
            TextButton(
              child: Text('DELETE [/place/{$_testId}]'),
              onPressed: () async {
                await _placeRepository.removePlace(_testId);
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Color(0xffF93E3F),
                minimumSize: Size(300, 48),
              ),
            ),
            sizedBoxH8,
            TextButton(
              child: Text('Обновить PUT [/place/{$_testId}]'),
              onPressed: () async {
                await _placeRepository.updatePlace(_testUpdate);
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Color(0xffFCA131),
                minimumSize: Size(300, 48),
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
}
