import 'package:flutter/material.dart';

/// поле favorites - для определения где показываем карточку
/// date - дата запланированного посещения или когда посетил
/// в новой карточке этих полей нет
/// ‼️‼️ пока логика такая, дальше наверняка будет иначе, отрефакторю

/// где показывать карточку: на странице поиска
/// и в разделах избранного
enum WhereShowCard { search, planned, visited }

class Sight {
  Sight({
    @required this.id,
    @required this.name,
    @required this.lat,
    @required this.lon,
    this.url,
    @required this.details,
    @required this.type,
    @required this.imgPreview,
    this.images,
    this.favorites,
    this.date,
  });

  final int id;
  final String name;
  final double lat;
  final double lon;
  final String url;
  final String details;
  final String type;
  final String imgPreview;
  final List<String> images;
  final WhereShowCard favorites;
  String date;
}
