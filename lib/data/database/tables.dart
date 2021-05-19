import 'dart:convert';

import 'package:moor/moor.dart';
import 'package:places/data/model/card_type.dart';
import 'package:places/data/model/place.dart';

/// таблицы базы данных
/// История запросов
/// [id] для сортировки результатов
/// [request] поисковый запрос
@DataClassName('SearchHistory')
class TableSearchHistory extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get request => text()();
}

/// Избранные карточки
/// Сохраняю весь объект, а также храню типы карточек для быстрого доступа
/// [placeId] - id места
/// [place] - всё место - сохранённый объект
/// [cardType] - CardType.planned, CardType.visited
@DataClassName('Favorites')
class TableFavorites extends Table {
  IntColumn get placeId => integer()();

  TextColumn get place => text().map(const PlaceConverter()).nullable()();

  IntColumn get cardType => intEnum<CardType>()();

  Set<Column>? get primaryKey => {placeId};
}

/// Кэш
/// Сохранённые данные с сервера и обрабатанные в соответствии
/// со списком избранных мест для отображения на Главной странице.
/// При новом запросе с фильтром будет очищаться и заполняться новыми данными
@DataClassName('CachePlaces')
class TableCachePlaces extends Table {
  IntColumn get placeId => integer()();

  TextColumn get place => text().map(const PlaceConverter()).nullable()();

  Set<Column>? get primaryKey => {placeId};
}

/// Конвертер Места в строку для хранения в базе данных
class PlaceConverter extends TypeConverter<Place, String> {
  const PlaceConverter();

  @override
  Place? mapToDart(String? fromDb) {
    if (fromDb == null) {
      return null;
    }
    return Place.fromJson(json.decode(fromDb) as Map<String, dynamic>);
  }

  @override
  String? mapToSql(Place? value) {
    if (value == null) {
      return null;
    }

    return json.encode(value.toJson());
  }
}
