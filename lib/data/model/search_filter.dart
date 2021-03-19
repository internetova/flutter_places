import 'package:flutter/material.dart';
import 'package:places/data/local_storage/local_storage.dart';
import 'package:places/data/model/coordinates.dart';

/// настройки фильтра для поиска:
/// локация пользователя, радиус поиска, список категорий, поисковые слова
/// [searchWords] может быть null
class SearchFilter {
  final Coordinates userLocation = LocalStorage.userLocation;
  final double radius;
  final List<String> typeFilter;
  final String searchWords;

  SearchFilter({
    @required this.radius,
    @required this.typeFilter,
    this.searchWords,
  })  : assert(radius != null),
        assert(typeFilter != null);
}
