import 'package:places/domain/card_type.dart';

/// поле favorites - для определения где показываем карточку
/// date - дата запланированного посещения или когда посетил
/// в новой карточке этих полей нет
/// ‼️‼️ пока логика такая, дальше наверняка будет иначе, отрефакторю

class Sight {
  Sight({
    required this.id,
    required this.name,
    required this.lat,
    required this.lon,
    this.url,
    required this.details,
    required this.type,
    required this.imgPreview,
    required this.images,
    this.favorites = CardType.search,
    this.date,
  });

  final int id;
  final String name;
  final double lat;
  final double lon;
  final String? url;
  final String details;
  final String type;
  final String imgPreview;
  final List<String> images;
  final CardType favorites;
  String? date;
}
