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

  // получаем рандомные данные из тестовых данных для карточки
  static TestImage getRandomItem() {
    final int randomId = Random().nextInt(99000);
    final int randomUrl = Random().nextInt(_testData.length);
    return TestImage(id: randomId, url: _testData[randomUrl]);
  }
}

/// item карточки для удаления
class TestImage {
  final int id;
  final String url;

  TestImage({
    required this.id,
    required this.url,
  });
}

/// сюда сохраним временные фото для загрузки
List<TestImage> userImages = [];
