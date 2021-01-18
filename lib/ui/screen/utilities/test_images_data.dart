import 'dart:math';

/// генерация тестовых данных для добавления фотографий
/// на экране создания нового места
class TestImagesData {
  static const _testData = <String>[
    '1.jpg',
    '2.jpg',
    '3.jpg',
    '4.jpg',
    '5.jpg',
    '6.jpg',
    '7.jpg',
    '8.jpg',
    '9.jpg',
    '10.jpg',
    '11.jpg',
  ];

  // получаем рандомную картинку из тестовых данных
  static String getRandomItem(_testData) {
    final int random = Random().nextInt(_testData.length);
    return _testData[random];
  }
}
