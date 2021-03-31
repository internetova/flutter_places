import 'package:places/data/model/coordinates.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/data/model/ui_place.dart';
import 'package:places/domain/card_type.dart';

/// ‼️ временно
/// имитация локального хранилища
/// храним:
/// 1. текущую геолокацию пользователя
/// 2. настройки поискового фильтра если юзер пока не задал свой
/// 3. кэшированные и обработанные данные(isFavorite)
/// 4. список избранных мест
/// 5. историю поиска пользователя
/// 6. настройки пользователя
/// 7. Блок для тестирования, позже удалить
class LocalStorage {
  LocalStorage._();

  /// 1. Геолокация пользователя
  static Coordinates userLocation = Coordinates(lat: 55.994909, lng: 37.606793);

  /// 2. Фильтр для поиска по умолчанию
  static SearchFilter defaultSearchFilter = SearchFilter(
    radius: 10000.0,
    typeFilter: ['park', 'cafe', 'other'],
  );

  /// 3. Сохранённые данные с сервера и обрабатанные в соответствии
  /// со списком избранных мест для отображения на Главной странице
  static List<UiPlace> cacheUIPlaces = [];

  /// 4. Список избранных мест
  static List<UiPlace> favoritesPlaces = [
    UiPlace(
      id: 134,
      lat: 55.988344,
      lng: 37.608042,
      name: 'Часовня Смоленской иконы Божией Матери в Чиверево',
      urls: [
        'https://sobory.ru/pic/09160/09168_20081121_230953.jpg',
        'https://picsum.photos/1000/600?random=1',
        'https://picsum.photos/1000/600?random=2',
        'https://picsum.photos/1000/600?random=3',
        'https://picsum.photos/1000/600?random=4',
        'https://picsum.photos/1000/600?random=5',
        'https://picsum.photos/1000/600?random=6'
      ],
      placeType: 'other',
      description:
          'Первая деревянная часовня здесь была построена в 1844 году. Впоследствии она сгорела и на ее месте в 1902 году по проекту епархиального архитектора Николая Николаевича Благовещенского была построена кирпичная часовня.',
      distance: 734.1159758962041,
      isFavorite: true,
      cardType: CardType.planned,
    ),
  ];

  /// 5. История поиска
  static List<String> searchHistory = [];

  /// 6. Настройки пользователя (тема приложения)
  static Map<String, dynamic> userSetting = {
    'isDarkTheme': false,
  };

  /// 7. Блок для тестирования, позже удалить
  /// карточке для добавления удаления в избранное пока не подключена работа с
  /// данными из сети
  static UiPlace testToggleFavorites = UiPlace(
    id: 136,
    lat: 55.993677,
    lng: 37.611009,
    name: 'Кафе Натюрморт',
    urls: [
      'https://img2.fonwall.ru/o/ht/cake-dessert-food-sweet.jpeg',
      'https://picsum.photos/1000/600?random=1',
      'https://picsum.photos/1000/600?random=2',
      'https://picsum.photos/1000/600?random=3',
      'https://picsum.photos/1000/600?random=4',
      'https://picsum.photos/1000/600?random=5',
      'https://picsum.photos/1000/600?random=6'
    ],
    placeType: 'cafe',
    description:
        'Банальные, но неопровержимые выводы, а также предприниматели в сети интернет являются только методом политического участия и смешаны с не уникальными данными до степени совершенной неузнаваемости, из-за чего возрастает их статус бесполезности. Интерактивные прототипы призваны к ответу.',
    distance: 295.8190911475786,
    isFavorite: true,
    cardType: CardType.search,
  );

  /// добавить новое место на сервер
  static Place testAddNewPlace = Place(
    id: 0, // это поле передавать на сервер не будем, скроем при трансформации
    lat: 55.993677,
    lng: 37.611009,
    name: 'Тест',
    urls: [
      'https://picsum.photos/1000/600?random=1',
    ],
    placeType: 'cafe',
    description: 'Тест Interactor. Интерактивные прототипы призваны к ответу.',
  );
}
