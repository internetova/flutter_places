import 'package:flutter/material.dart';

/// для хранения координат
/// текущая локация пользователя
class Coordinates {
  final double lat;
  final double lng;

  Coordinates({
    @required this.lat,
    @required this.lng,
  });
}
