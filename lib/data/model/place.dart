import 'package:flutter/material.dart';

/// хранит данные по интересному месту
/// [id] - ид места
/// [lat] - широта
/// [lng] - долгота
/// [name] - имя
/// [urls] - список фото
/// [placeType] - тип места
/// [description] - описание
/// [distance] - расстояние до локации юзера - шлёт сервер
class Place {
  final int id;
  final double lat;
  final double lng;
  final String name;
  final List<String> urls;
  final String placeType;
  final String description;
  final double distance;

  Place({
    this.id,
    @required this.lat,
    @required this.lng,
    @required this.name,
    @required this.urls,
    @required this.placeType,
    @required this.description,
    this.distance,
  })  : assert(lat != null),
        assert(lng != null),
        assert(name != null),
        assert(urls != null),
        assert(placeType != null),
        assert(description != null);

  Place.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        lat = json['lat'] as double,
        lng = json['lng'] as double,
        name = json['name'] as String,
        urls = (json['urls'] as List<dynamic>).whereType<String>().toList(),
        placeType = json['placeType'] as String,
        description = json['description'] as String,
        distance = json['distance'] != null ? json['distance'] as double : null;

  Map<String, dynamic> toJson({bool addId = false}) => {
        /// данные на сервер для создания нового места отправляются без ID
        if (addId) 'id': id,
        'lat': lat,
        'lng': lng,
        'name': name,
        'urls': urls,
        'placeType': placeType,
        'description': description,
      };

  @override
  String toString() {
    String result = 'id: $id, name: $name';
    if (distance != null) result += ' distance: $distance м';

    return result;
  }
}
