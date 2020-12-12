import 'package:flutter/material.dart';

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
