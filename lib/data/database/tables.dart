import 'package:moor/moor.dart';

/// таблицы базы данных
/// История запросов
/// [id] для сортировки результатов
/// [request] поисковый запрос
@DataClassName('SearchHistory')
class TableSearchHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get request => text()();
}