import 'package:places/data/dto/place_dto.dart';
import 'package:places/data/model/card_type.dart';
import 'package:places/data/model/place_type.dart';

/// карточки, отображаемые в программе
/// добавляем поля:
/// [cardType] - флаг для кнопок действий на карточке (на поиске, в избранном)
/// [date] - дата планирования или когда посетил, может быть null
/// сохраняем в локальной базе данных
class Place {
  final int id;
  final double lat;
  final double lng;
  final String name;
  final List<String> urls;
  final String placeType;
  final String description;
  final double? distance;
  final bool isFavorite;
  final CardType cardType;
  final DateTime? date;

  Place({
    this.id = 0,
    required this.lat,
    required this.lng,
    required this.name,
    required this.urls,
    required this.placeType,
    required this.description,
    this.distance,
    this.isFavorite = false,
    this.cardType = CardType.search,
    this.date,
  });

  /// место из api переводим в места для ui
  /// если место у юзера в избранных, то ставим соответствующие отметки
  static Place fromApi(PlaceDto place,
      {bool? isFavorite, CardType? cardType}) {
    return Place(
      id: place.id,
      lat: place.lat,
      lng: place.lng,
      name: place.name,
      urls: place.urls,
      placeType: place.placeType,
      description: place.description,
      distance: place.distance,
      isFavorite: isFavorite != null ? isFavorite : false,
      cardType: cardType != null ? cardType : CardType.search,
    );
  }

  /// копируем место при добавлении в избранное
  /// изменяем isFavorite на тру
  static Place addFavorites(Place place) {
    return Place(
      id: place.id,
      lat: place.lat,
      lng: place.lng,
      name: place.name,
      urls: place.urls,
      placeType: place.placeType,
      description: place.description,
      distance: place.distance,
      isFavorite: true,
      cardType: CardType.planned,
    );
  }

  /// для обновления мест в избранном на случай изменений данных на сервере
  /// ❓❓ надо ли обновлять расстояние до места если оно может
  /// постоянно меняться? 👀 пока оставлю старое
  /// todo: вопрос с дистанцией
  static Place updateFromApi({
    required Place place,
    required PlaceDto apiPlace,
  }) {
    return Place(
      id: place.id,
      lat: apiPlace.lat,
      lng: apiPlace.lng,
      name: apiPlace.name,
      urls: apiPlace.urls,
      placeType: apiPlace.placeType,
      description: apiPlace.description,
      distance: place.distance,
      isFavorite: place.isFavorite,
      cardType: place.cardType,
      date: place.date,
    );
  }

  /// переключаем статус места - избранное / не избранное
  static Place switchFavoriteStatus({required Place place, required bool isFav}) {
    return Place(
      id: place.id,
      lat: place.lat,
      lng: place.lng,
      name: place.name,
      urls: place.urls,
      placeType: place.placeType,
      description: place.description,
      distance: place.distance,
      isFavorite: isFav,
      cardType: place.cardType,
      date: place.date,
    );
  }

  /// получить название типа места по коду
  /// т.к. сервер отдаёт только код
  String getPlaceTypeName() {
    String name;

    int result =
        PlaceType.getList.indexWhere((element) => element.code == placeType);

    if (result == -1) {
      name = PlaceType.placeTypeNameDefault;
    } else {
      name = PlaceType.getList[result].name;
    }

    return name;
  }

  @override
  String toString() {
    String result = 'id: $id, isFavorite: $isFavorite, name: $name';
    if (distance != null) result += ' distance: $distance м';

    return result;
  }
}
