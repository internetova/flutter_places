import 'dart:math';

/// генерация тестовых данных для добавления фотографий
/// на экране создания нового места
class TestImagesData {
  static const _testData = <String>[
    'res/test_data/1.jpg',
    'res/test_data/2.jpg',
    'res/test_data/3.jpg',
    'res/test_data/4.jpg',
    'res/test_data/5.jpg',
    'res/test_data/6.jpg',
    'res/test_data/7.jpg',
    'res/test_data/8.jpg',
    'res/test_data/9.jpg',
    'res/test_data/10.jpg',
    'res/test_data/11.jpg',
  ];

  // получаем рандомную картинку из тестовых данных
  static String getRandomItem() {
    final int random = Random().nextInt(_testData.length);
    return _testData[random];
  }
}
