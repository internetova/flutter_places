import 'package:moor/moor.dart';
import 'package:places/data/model/card_type.dart';

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
/// [placeId] - id места
/// [distance] - дистанция, вернёт сервер (для сортировки по удалённости)
/// [cardType] - CardType.planned, CardType.visited
/// [date] - дата запланировано или когда посетил
@DataClassName('FavoritesPlaces')
class TableFavoritesPlaces extends Table {
  IntColumn get placeId => integer()();
  RealColumn get distance => real()();
  IntColumn get cardType => intEnum<CardType>()();
  DateTimeColumn get date => dateTime().nullable()();

  Set<Column>? get primaryKey => {placeId};
}