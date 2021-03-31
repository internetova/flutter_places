import 'package:places/data/model/place.dart';
import 'package:places/domain/card_type.dart';

/// карточки, отображаемые в программе
/// добавляем поля:
/// [cardType] - флаг для кнопок действий на карточке (на поиске, в избранном)
/// [date] - дата планирования или когда посетил, может быть null
/// сохраняем в локальной базе данных
class UiPlace extends Place {
  final int id;
  final double lat;
  final double lng;
  final String name;
  final List<String> urls;
  final String placeType;
  final String description;
  final double? distance;
  final bool isFavorite;
  final CardType cardType;
  final DateTime? date;

  UiPlace({
    required this.id,
    required this.lat,
    required this.lng,
    required this.name,
    required this.urls,
    required this.placeType,
    required this.description,
    this.distance,
    this.isFavorite = false,
    this.cardType = CardType.search,
    this.date,
  }) : super(
          id: id,
          lat: lat,
          lng: lng,
          name: name,
          urls: urls,
          placeType: placeType,
          description: description,
        );

  /// место из api переводим в места для ui
  static UiPlace fromPlace(Place place, {bool? isFavorite, CardType? cardType}) {
    return UiPlace(
      id: place.id,
      lat: place.lat,
      lng: place.lng,
      name: place.name,
      urls: place.urls,
      placeType: place.placeType,
      description: place.description,
      distance: place.distance,
      isFavorite: isFavorite != null ? isFavorite : false,
      cardType: cardType != null ? cardType : CardType.search,
    );
  }

  /// копируем место при добавлении в избранное
  /// изменяем isFavorite на тру
  static UiPlace addFavorites(UiPlace place) {
    return UiPlace(
      id: place.id,
      lat: place.lat,
      lng: place.lng,
      name: place.name,
      urls: place.urls,
      placeType: place.placeType,
      description: place.description,
      distance: place.distance,
      isFavorite: true,
      cardType: CardType.planned,
    );
  }

  /// для обновления мест в избранном на случай изменений данных на сервере
  /// ❓❓ надо ли обновлять расстояние до места если оно может
  /// постоянно меняться? 👀 пока оставлю старое
  /// todo: вопрос с дистанцией
  static UiPlace updateFromApi({
    required UiPlace localPlace,
    required Place apiPlace,
  }) {
    return UiPlace(
      id: localPlace.id,
      lat: apiPlace.lat,
      lng: apiPlace.lng,
      name: apiPlace.name,
      urls: apiPlace.urls,
      placeType: apiPlace.placeType,
      description: apiPlace.description,
      distance: localPlace.distance,
      isFavorite: localPlace.isFavorite,
      cardType: localPlace.cardType,
      date: localPlace.date,
    );
  }

  @override
  String toString() {
    String result = 'id: $id, isFavorite: $isFavorite, name: $name';
    if (distance != null) result += ' distance: $distance м';

    return result;
  }
}
