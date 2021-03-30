import 'package:flutter/material.dart';

/// Запрос списка интересных мест с фильтром
/// параметры запроса
/// Модель данных с параметрами фильтра. Все поля не обязательные,
/// но параметры "lat", "lat" и "radius" зависят друг от друга, поэтому
/// если указан один из них, то остальные два становятся обязательными
/// чтобы в ответе получить дистанцию необходимо отправлять все поля!!
class PlacesFilterRequestDto {
  final double lat;
  final double lng;
  final double radius;
  final List<String> typeFilter;
  final String nameFilter;

  PlacesFilterRequestDto({
    @required this.lat,
    @required this.lng,
    @required this.radius,
    @required this.typeFilter,
    this.nameFilter,
  });

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
        'radius': radius,
        'typeFilter': typeFilter,
        if (nameFilter != null) 'nameFilter': nameFilter,
      };
}
