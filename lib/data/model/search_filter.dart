import 'package:flutter/material.dart';
import 'package:places/data/local_storage/local_storage.dart';
import 'package:places/data/model/coordinates.dart';

/// настройки фильтра для поиска:
/// локация пользователя, радиус поиска, список категорий
/// эти параметры позволят получить distance с сервера
/// т.к. в ui используется Range слайдер, а на сервере только один радиус, то
/// на с заделом будущее сохраним два значения, а передавать на сервер будем max
class SearchFilter {
  final Coordinates userLocation = LocalStorage.userLocation;
  final RangeValues radius;
  final List<String> typeFilter;

  SearchFilter({
    required this.radius,
    required this.typeFilter,
  });
}
