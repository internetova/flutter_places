import 'package:places/data/local_storage/local_storage.dart';
import 'package:places/data/model/coordinates.dart';

/// настройки фильтра для поиска:
/// локация пользователя, радиус поиска, список категорий
/// эти параметры позволят получить distance с сервера
class SearchFilter {
  final Coordinates userLocation = LocalStorage.userLocation;
  final double radius;
  final List<String> typeFilter;

  SearchFilter({
    required this.radius,
    required this.typeFilter,
  });
}
