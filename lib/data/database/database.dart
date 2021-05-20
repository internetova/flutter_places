import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import 'package:places/data/database/tables.dart';
import 'package:places/data/model/card_type.dart';
import 'package:places/data/model/place.dart';

part 'database.g.dart';

/// база пользовательских данных, методы работы с данными
@UseMoor(
  tables: [TableSearchHistory, TableFavorites, TableCachePlaces],
)
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  ///---- ИСТОРИЯ ЗАПРОСОВ ------
  /// получить все запросы
  /// последние выводятся первыми
  Future<List<SearchHistory>> getSearchHistory() => (select(tableSearchHistory)
        ..orderBy([
          (u) => OrderingTerm(
                expression: u.id,
                mode: OrderingMode.desc,
              )
        ]))
      .get();

  /// сохранить новый запрос
  Future<void> saveSearchRequest(String request) => into(tableSearchHistory)
      .insert(TableSearchHistoryCompanion(request: Value(request)));

  /// удалить запрос из истории
  Future<void> deleteSearchRequest(int id) =>
      (delete(tableSearchHistory)..where((row) => row.id.equals(id))).go();

  /// очистить историю запросов
  Future<void> clearSearchHistory() => delete(tableSearchHistory).go();

  /// найти запрос в базе данных
  /// если такой запрос уже есть, то новый добавлять не будем
  /// в базу я добавляю только удачные запросы - те, по результатам которых
  /// юзер перешёл
  Future<List<SearchHistory>> checkSearchRequest(String request) =>
      (select(tableSearchHistory)..where((row) => row.request.equals(request)))
          .get();

  ///---- РАЗДЕЛ КЭШ ДЛЯ ГЛАВНОЙ СТРАНИЦЫ ------
  /// получить кэш мест
  Future<List<CachePlaces>> getCachePlaces() => select(tableCachePlaces).get();

  /// очистить кэш
  Future<void> clearCachePlaces() => delete(tableCachePlaces).go();

  /// добавить место в кэш
  Future<void> addCachePlacesItem(Place place) =>
      into(tableCachePlaces).insert(TableCachePlacesCompanion(
        placeId: Value(place.id),
        place: Value(place),
      ));

  /// обновить место в кэше (когда добавили / удалили Избранное)
  Future updateCachePlacesItem(Place place) =>
      update(tableCachePlaces).replace(TableCachePlacesCompanion(
        placeId: Value(place.id),
        place: Value(place),
      ));

  /// добавить список мест
  Future<void> addCachePlacesAll(List<Place> places) async {
    await batch((batch) {
      batch.insertAll(
        tableCachePlaces,
        places
            .map((place) => TableCachePlacesCompanion.insert(
                  placeId: Value(place.id),
                  place: place,
                ))
            .toList(),
      );
    });
  }

  ///---- РАЗДЕЛ ИЗБРАННОЕ ------
  /// получить все места Избранного (планирую + посетил)
  Future<List<Favorites>> getFavoritesPlaces() => select(tableFavorites).get();

  /// enum CardType { search - 0, planned - 1, visited -2 }
  /// получить места Планирую посетить
  Future<List<Favorites>> getPlannedPlaces() =>
      (select(tableFavorites)..where((row) => row.cardType.equals(1))).get();

  /// получить карточки Посетил
  Future<List<Favorites>> getVisitedPlaces() =>
      (select(tableFavorites)..where((row) => row.cardType.equals(2))).get();

  /// добавить место в Избранные
  /// безопасное добавление - перезапишет существующую запись либо добавит новую
  Future<void> addToFavorites(Place place) =>
      into(tableFavorites).insertOnConflictUpdate(TableFavoritesCompanion(
        placeId: Value(place.id),
        place: Value(place),
        cardType: Value<CardType>(CardType.planned),
      ));

  /// удалить из Избранного
  Future<void> removeFromFavorites(Place place) =>
      (delete(tableFavorites)..where((row) => row.placeId.equals(place.id)))
          .go();

  /// изменить место (запланировать дату, обновить данные, перенести в Посетил)
  Future<void> updateFavoritesPlace(Place place) =>
      update(tableFavorites).replace(TableFavoritesCompanion(
        placeId: Value(place.id),
        place: Value(place),
        cardType: Value<CardType>(place.cardType),
      ));

  /// получить место по id
  Future<Favorites> getFavoritesItem(int id) =>
      (select(tableFavorites)..where((row) => row.placeId.equals(id)))
          .getSingle();
}

/// открытие соединения и создание базы данных
LazyDatabase _openConnection() {
  return LazyDatabase(
    () async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'db.sqlite'));
      return VmDatabase(file);
    },
  );
}
