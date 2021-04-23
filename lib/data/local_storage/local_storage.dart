import 'package:flutter/material.dart';
import 'package:places/data/model/coordinates.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/card_type.dart';

/// ‼️ временно
/// имитация локального хранилища
/// храним:
/// 1. текущую геолокацию пользователя
/// 2. настройки поискового фильтра если юзер пока не задал свой
/// 3. кэшированные и обработанные данные(isFavorite)
/// 4. список избранных мест
/// 5. историю поиска пользователя
/// 6. настройки пользователя тема
class LocalStorage {
  LocalStorage._();

  /// 1. Геолокация пользователя
  static Coordinates userLocation = Coordinates(lat: 55.994909, lng: 37.606793);

  /// 2. Фильтр для поиска по умолчанию
  /// при изменении пересохраняется в момент отправки нового запроса
  static SearchFilter searchFilter = SearchFilter(
    radius: RangeValues(100.0, 10000.0), //  в метрах
    typeFilter: [
      'park',
      'cafe',
      'other',
      'museum',
      'restaurant',
      'hotel',
    ],
  );

  /// 3. Сохранённые данные с сервера и обрабатанные в соответствии
  /// со списком избранных мест для отображения на Главной странице
  static List<Place> cachePlaces = [];

  /// 4. Список избранных мест
  static List<Place> favoritesPlaces = [
    Place(
      id: 134,
      lat: 55.988344,
      lng: 37.608042,
      name: 'Часовня Смоленской иконы Божией Матери в Чиверево',
      urls: [
        'https://avatars.mds.yandex.net/get-altay/788991/2a0000016287a63a89a1347acfd675732266/XXXL',
        'https://avatars.mds.yandex.net/get-altay/961502/2a0000016287a63f56d5a2178a1b30783308/XXXL',
        'https://avatars.mds.yandex.net/get-altay/905403/2a0000016287a63ea32b14c510cb356d0e90/XXXL'
      ],
      placeType: 'other',
      description:
          'Первая деревянная часовня здесь была построена в 1844 году. Впоследствии она сгорела и на ее месте в 1902 году по проекту епархиального архитектора Николая Николаевича Благовещенского была построена кирпичная часовня.',
      distance: 734.1159758962041,
      isFavorite: true,
      cardType: CardType.planned,
    ),
    Place(
      id: 217,
      lat: 56.001115,
      lng: 37.649036,
      name: 'Супермаркет «Магнит»',
      urls: [
        "https://avatars.mds.yandex.net/get-altay/2051686/2a0000016fc3597e332dde12d891c06b8a9a/XXXL",
        'https://avatars.mds.yandex.net/get-altay/4079181/2a000001775a3af85fcdeaf5bff44d03cf94/XXXL',
      ],
      placeType: 'other',
      description:
          'Самый крупный магазин на три деревни Чиверёво, Осташково, Жостово. Так как там большая проходимость нарваться на несвежие продукты шансов мало.',
      distance: 3233.583792759015,
      isFavorite: true,
      cardType: CardType.visited,
    )
  ];

  /// 5. История поиска
  static List<String> searchHistory = [];

  /// 6. Настройки пользователя
  static Map<String, dynamic> userSetting = {
    'isDarkTheme': false, // тема
    'isFirstStart': false, // первый запуск приложения
  };
}
