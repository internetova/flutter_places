// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class SearchHistory extends DataClass implements Insertable<SearchHistory> {
  final int id;
  final String request;
  SearchHistory({required this.id, required this.request});
  factory SearchHistory.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return SearchHistory(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      request: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}request'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['request'] = Variable<String>(request);
    return map;
  }

  TableSearchHistoryCompanion toCompanion(bool nullToAbsent) {
    return TableSearchHistoryCompanion(
      id: Value(id),
      request: Value(request),
    );
  }

  factory SearchHistory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return SearchHistory(
      id: serializer.fromJson<int>(json['id']),
      request: serializer.fromJson<String>(json['request']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'request': serializer.toJson<String>(request),
    };
  }

  SearchHistory copyWith({int? id, String? request}) => SearchHistory(
        id: id ?? this.id,
        request: request ?? this.request,
      );
  @override
  String toString() {
    return (StringBuffer('SearchHistory(')
          ..write('id: $id, ')
          ..write('request: $request')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, request.hashCode));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SearchHistory &&
          other.id == this.id &&
          other.request == this.request);
}

class TableSearchHistoryCompanion extends UpdateCompanion<SearchHistory> {
  final Value<int> id;
  final Value<String> request;
  const TableSearchHistoryCompanion({
    this.id = const Value.absent(),
    this.request = const Value.absent(),
  });
  TableSearchHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String request,
  }) : request = Value(request);
  static Insertable<SearchHistory> custom({
    Expression<int>? id,
    Expression<String>? request,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (request != null) 'request': request,
    });
  }

  TableSearchHistoryCompanion copyWith(
      {Value<int>? id, Value<String>? request}) {
    return TableSearchHistoryCompanion(
      id: id ?? this.id,
      request: request ?? this.request,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (request.present) {
      map['request'] = Variable<String>(request.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TableSearchHistoryCompanion(')
          ..write('id: $id, ')
          ..write('request: $request')
          ..write(')'))
        .toString();
  }
}

class $TableSearchHistoryTable extends TableSearchHistory
    with TableInfo<$TableSearchHistoryTable, SearchHistory> {
  final GeneratedDatabase _db;
  final String? _alias;
  $TableSearchHistoryTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedIntColumn id = _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _requestMeta = const VerificationMeta('request');
  @override
  late final GeneratedTextColumn request = _constructRequest();
  GeneratedTextColumn _constructRequest() {
    return GeneratedTextColumn(
      'request',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, request];
  @override
  $TableSearchHistoryTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'table_search_history';
  @override
  final String actualTableName = 'table_search_history';
  @override
  VerificationContext validateIntegrity(Insertable<SearchHistory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('request')) {
      context.handle(_requestMeta,
          request.isAcceptableOrUnknown(data['request']!, _requestMeta));
    } else if (isInserting) {
      context.missing(_requestMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SearchHistory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return SearchHistory.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $TableSearchHistoryTable createAlias(String alias) {
    return $TableSearchHistoryTable(_db, alias);
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $TableSearchHistoryTable tableSearchHistory =
      $TableSearchHistoryTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [tableSearchHistory];
}
