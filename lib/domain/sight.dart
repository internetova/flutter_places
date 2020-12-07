import 'package:flutter/material.dart';

class Sight {
  Sight({
    @required this.nameSights,
    @required this.lat,
    @required this.lon,
    @required this.url,
    @required this.details,
    @required this.type,
  });
  final String nameSights;
  final double lat;
  final double lon;
  final String url;
  final String details;
  final String type;
}
