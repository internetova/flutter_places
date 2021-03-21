import 'package:flutter/material.dart';
import 'package:places/data/model/place.dart';

/// избранное место
/// добавляем поля:
/// [isVisited] - посещенное или нет
/// [date] - дата планирования или когда посетил, может быть null
/// сохраняем в локальной базе данных
class FavoritePlace extends Place {
  final int id;
  final double lat;
  final double lng;
  final String name;
  final List<String> urls;
  final String placeType;
  final String description;
  final double distance;
  final bool isVisited;
  final DateTime date;

  FavoritePlace({
    @required this.id,
    @required this.lat,
    @required this.lng,
    @required this.name,
    @required this.urls,
    @required this.placeType,
    @required this.description,
    this.distance,
    this.isVisited = false,
    this.date,
  }) : super(
          id: id,
          lat: lat,
          lng: lng,
          name: name,
          urls: urls,
          placeType: placeType,
          description: description,
        );

  @override
  String toString() {
    String result = 'id: $id, isVisited: $isVisited, name: $name';
    if (distance != null) result += ' distance: $distance м';

    return result;
  }
}
