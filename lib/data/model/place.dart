import 'package:equatable/equatable.dart';
import 'package:places/data/dto/place_dto.dart';
import 'package:places/data/model/card_type.dart';
import 'package:places/data/model/place_type.dart';

/// карточки, отображаемые в программе
/// добавляем поля:
/// [cardType] - флаг для кнопок действий на карточке (на поиске, в избранном)
/// [date] - дата планирования или когда посетил, может быть null
/// сохраняем в локальной базе данных
class Place extends Equatable {
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

  /// для сохранения в базу данных
  Place.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        lat = json['lat'] as double,
        lng = json['lng'] as double,
        name = json['name'] as String,
        urls = (json['urls'] as List<dynamic>).whereType<String>().toList(),
        placeType = json['placeType'] as String,
        description = json['description'] as String,
        distance =
            json['distance'] != null ? json['distance'] as double? : null,
        isFavorite = json['isFavorite'] as bool,
        cardType = CardType.values.elementAt(json['cardType']),
        date = json['date'] != null ? json['date'] : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'lat': lat,
        'lng': lng,
        'name': name,
        'urls': urls,
        'placeType': placeType,
        'description': description,
        'distance': distance,
        'isFavorite': isFavorite,
        'cardType': cardType.index,
        'date': date,
      };

  /// место из api переводим в места для ui
  /// если место у юзера в избранных, то ставим соответствующие отметки
  static Place fromApi(PlaceDto place, {bool? isFavorite, CardType? cardType}) {
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
  /// дистанцию оставляю старую с сервера, возможно потом будет пересчёт
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
  static Place switchFavoriteStatusPlanned(
      {required Place place, required bool isFav}) {
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
      cardType: isFav ? CardType.planned : CardType.search,
      date: place.date,
    );
  }

  /// переносим место в посещённые
  static Place switchFavoriteStatusVisited(
      {required Place place}) {
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
      cardType: CardType.visited,
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

  @override
  List<Object?> get props => [
        id,
        lat,
        lng,
        name,
        urls,
        placeType,
        description,
        distance,
        isFavorite,
        cardType,
        date,
      ];
}
