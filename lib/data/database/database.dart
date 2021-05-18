import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import 'package:places/data/database/tables.dart';

part 'database.g.dart';

/// база пользовательских данных, методы работы с данными
@UseMoor(
  tables: [TableSearchHistory],
)
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;

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
      (delete(tableSearchHistory)..where((item) => item.id.equals(id))).go();

  /// очистить историю запросов
  Future<void> clearSearchHistory() => delete(tableSearchHistory).go();
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
