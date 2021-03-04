/// хранит данные по интересному месту
/// [id] - ид места
/// [lat] - широта
/// [lng] - долгота
/// [name] - имя
/// [urls] - список фото
/// [placeType] - тип места
/// [description] - описание
class Place {
  final int id;
  final double lat;
  final double lng;
  final String name;
  final List urls;
  final String placeType;
  final String description;

  Place(
    this.id,
    this.lat,
    this.lng,
    this.name,
    this.urls,
    this.placeType,
    this.description,
  );

  Place.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        lat = json['lat'],
        lng = json['lng'],
        name = json['name'],
        urls = json['urls'],
        placeType = json['placeType'],
        description = json['description'];

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'lat': lat,
        'lng': lng,
        'name': name,
        'urls': urls,
        'placeType': placeType,
        'description': description,
      };
}
