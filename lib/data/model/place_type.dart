import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/strings.dart';

/// тип мест для работы в программе,
/// т.к. сервер отдаёт тип только в виде кода, напромер 'park'
/// создаём свой список типов мест с расшифрокой названия и иконкой
/// а также метод приведения полученных данных с сервера к необходимым для нас
/// будем использвать на странице с фильтром и при выводе названия 'park' -> Парк,
/// а также на странице создания нового места
class PlaceType {
  final String code;
  final String name;
  final String icon;

  PlaceType({
    required this.code,
    required this.name,
    required this.icon,
  });

  /// категории для фильтра поиска
  /// на сервере:
  /// [ temple, monument, park, theatre, museum, hotel, restaurant, cafe, other ]
  static final List<PlaceType> _listPlaceTypes = [
    PlaceType(
      code: placeTypeCodeHotel,
      name: placeTypeNameHotel,
      icon: icHotel,
    ),
    PlaceType(
      code: placeTypeCodeRestaurant,
      name: placeTypeNameRestaurant,
      icon: icRestaurant,
    ),
    PlaceType(
      code: placeTypeCodeOther,
      name: placeTypeNameOther,
      icon: icParticular,
    ),
    PlaceType(
      code: placeTypeCodePark,
      name: placeTypeNamePark,
      icon: icPark,
    ),
    PlaceType(
      code: placeTypeCodeMuseum,
      name: placeTypeNameMuseum,
      icon: icMuseum,
    ),
    PlaceType(
      code: placeTypeCodeCafe,
      name: placeTypeNameCafe,
      icon: icCafe,
    ),
  ];

  /// если на сервере есть неизвестные типы помечаем карточки как other
  /// на всякий случай, т.к. по идее запрос на сервер идёт с выбранными в
  /// приложении категориями (а на сервере может оказаться больше категорий)
  static final String placeTypeNameDefault = placeTypeNameOther;

  /// получить все типы мест
  /// используется в фильтре и при добавлении нового места
  static List<PlaceType> get getList => _listPlaceTypes;

  /// получить код типа (категории) места по названию
  static String getCode(String name) =>
      _listPlaceTypes.firstWhere((type) => type.name == name).code;
}
