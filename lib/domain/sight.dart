import 'package:flutter/material.dart';

/// пока добавила поля Хочу посетить и посетил
/// в новой карточке этих полей нет
/// в избранном одно из двух полей
/// ‼️‼️ пока логика такая, дальше наверняка будет иначе, отрефакторю
class Sight {
  Sight({
    @required this.name,
    @required this.lat,
    @required this.lon,
    @required this.url,
    @required this.details,
    @required this.type,
    @required this.imgPreview,
    this.planned,
    this.visited,
  });
  final String name;
  final double lat;
  final double lon;
  final String url;
  final String details;
  final String type;
  final String imgPreview;
  String planned;
  String visited;
}
