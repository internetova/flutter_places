/// Запрос списка интересных мест с фильтром
/// параметры запроса
/// Модель данных с параметрами фильтра. Все поля не обязательные,
/// но параметры "lat", "lat" и "radius" зависят друг от друга, поэтому
/// если указан один из них, то остальные два становятся обязательными
/// чтобы в ответе получить дистанцию необходимо отправлять все обязательные поля!!
/// если геоплзиция отключена, то выполняем поиск по всей базе по ключевому слову
class PlacesFilterRequestDto {
  final double? lat;
  final double? lng;
  final double? radius;
  final List<String>? typeFilter;
  final String? nameFilter;

  PlacesFilterRequestDto({
    this.lat,
    this.lng,
    this.radius,
    this.typeFilter,
    this.nameFilter,
  });

  Map<String, dynamic> toJson() => {
        if (lat != null) 'lat': lat,
        if (lng != null) 'lng': lng,
        if (radius != null) 'radius': radius,
        if (typeFilter != null) 'typeFilter': typeFilter,
        if (nameFilter != null) 'nameFilter': nameFilter,
      };
}
