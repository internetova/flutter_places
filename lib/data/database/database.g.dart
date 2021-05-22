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

class Favorites extends DataClass implements Insertable<Favorites> {
  final int placeId;
  final Place place;
  final CardType cardType;
  Favorites(
      {required this.placeId, required this.place, required this.cardType});
  factory Favorites.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Favorites(
      placeId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}place_id'])!,
      place: $TableFavoritesTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}place']))!,
      cardType: $TableFavoritesTable.$converter1.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}card_type']))!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['place_id'] = Variable<int>(placeId);
    {
      final converter = $TableFavoritesTable.$converter0;
      map['place'] = Variable<String>(converter.mapToSql(place)!);
    }
    {
      final converter = $TableFavoritesTable.$converter1;
      map['card_type'] = Variable<int>(converter.mapToSql(cardType)!);
    }
    return map;
  }

  TableFavoritesCompanion toCompanion(bool nullToAbsent) {
    return TableFavoritesCompanion(
      placeId: Value(placeId),
      place: Value(place),
      cardType: Value(cardType),
    );
  }

  factory Favorites.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Favorites(
      placeId: serializer.fromJson<int>(json['placeId']),
      place: serializer.fromJson<Place>(json['place']),
      cardType: serializer.fromJson<CardType>(json['cardType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'placeId': serializer.toJson<int>(placeId),
      'place': serializer.toJson<Place>(place),
      'cardType': serializer.toJson<CardType>(cardType),
    };
  }

  Favorites copyWith({int? placeId, Place? place, CardType? cardType}) =>
      Favorites(
        placeId: placeId ?? this.placeId,
        place: place ?? this.place,
        cardType: cardType ?? this.cardType,
      );
  @override
  String toString() {
    return (StringBuffer('Favorites(')
          ..write('placeId: $placeId, ')
          ..write('place: $place, ')
          ..write('cardType: $cardType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(placeId.hashCode, $mrjc(place.hashCode, cardType.hashCode)));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Favorites &&
          other.placeId == this.placeId &&
          other.place == this.place &&
          other.cardType == this.cardType);
}

class TableFavoritesCompanion extends UpdateCompanion<Favorites> {
  final Value<int> placeId;
  final Value<Place> place;
  final Value<CardType> cardType;
  const TableFavoritesCompanion({
    this.placeId = const Value.absent(),
    this.place = const Value.absent(),
    this.cardType = const Value.absent(),
  });
  TableFavoritesCompanion.insert({
    this.placeId = const Value.absent(),
    required Place place,
    required CardType cardType,
  })  : place = Value(place),
        cardType = Value(cardType);
  static Insertable<Favorites> custom({
    Expression<int>? placeId,
    Expression<Place>? place,
    Expression<CardType>? cardType,
  }) {
    return RawValuesInsertable({
      if (placeId != null) 'place_id': placeId,
      if (place != null) 'place': place,
      if (cardType != null) 'card_type': cardType,
    });
  }

  TableFavoritesCompanion copyWith(
      {Value<int>? placeId, Value<Place>? place, Value<CardType>? cardType}) {
    return TableFavoritesCompanion(
      placeId: placeId ?? this.placeId,
      place: place ?? this.place,
      cardType: cardType ?? this.cardType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (placeId.present) {
      map['place_id'] = Variable<int>(placeId.value);
    }
    if (place.present) {
      final converter = $TableFavoritesTable.$converter0;
      map['place'] = Variable<String>(converter.mapToSql(place.value)!);
    }
    if (cardType.present) {
      final converter = $TableFavoritesTable.$converter1;
      map['card_type'] = Variable<int>(converter.mapToSql(cardType.value)!);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TableFavoritesCompanion(')
          ..write('placeId: $placeId, ')
          ..write('place: $place, ')
          ..write('cardType: $cardType')
          ..write(')'))
        .toString();
  }
}

class $TableFavoritesTable extends TableFavorites
    with TableInfo<$TableFavoritesTable, Favorites> {
  final GeneratedDatabase _db;
  final String? _alias;
  $TableFavoritesTable(this._db, [this._alias]);
  final VerificationMeta _placeIdMeta = const VerificationMeta('placeId');
  @override
  late final GeneratedIntColumn placeId = _constructPlaceId();
  GeneratedIntColumn _constructPlaceId() {
    return GeneratedIntColumn(
      'place_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _placeMeta = const VerificationMeta('place');
  @override
  late final GeneratedTextColumn place = _constructPlace();
  GeneratedTextColumn _constructPlace() {
    return GeneratedTextColumn(
      'place',
      $tableName,
      false,
    );
  }

  final VerificationMeta _cardTypeMeta = const VerificationMeta('cardType');
  @override
  late final GeneratedIntColumn cardType = _constructCardType();
  GeneratedIntColumn _constructCardType() {
    return GeneratedIntColumn(
      'card_type',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [placeId, place, cardType];
  @override
  $TableFavoritesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'table_favorites';
  @override
  final String actualTableName = 'table_favorites';
  @override
  VerificationContext validateIntegrity(Insertable<Favorites> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('place_id')) {
      context.handle(_placeIdMeta,
          placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta));
    }
    context.handle(_placeMeta, const VerificationResult.success());
    context.handle(_cardTypeMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {placeId};
  @override
  Favorites map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Favorites.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $TableFavoritesTable createAlias(String alias) {
    return $TableFavoritesTable(_db, alias);
  }

  static TypeConverter<Place, String> $converter0 = const PlaceConverter();
  static TypeConverter<CardType, int> $converter1 =
      const EnumIndexConverter<CardType>(CardType.values);
}

class CachePlaces extends DataClass implements Insertable<CachePlaces> {
  final int placeId;
  final Place place;
  CachePlaces({required this.placeId, required this.place});
  factory CachePlaces.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return CachePlaces(
      placeId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}place_id'])!,
      place: $TableCachePlacesTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}place']))!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['place_id'] = Variable<int>(placeId);
    {
      final converter = $TableCachePlacesTable.$converter0;
      map['place'] = Variable<String>(converter.mapToSql(place)!);
    }
    return map;
  }

  TableCachePlacesCompanion toCompanion(bool nullToAbsent) {
    return TableCachePlacesCompanion(
      placeId: Value(placeId),
      place: Value(place),
    );
  }

  factory CachePlaces.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return CachePlaces(
      placeId: serializer.fromJson<int>(json['placeId']),
      place: serializer.fromJson<Place>(json['place']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'placeId': serializer.toJson<int>(placeId),
      'place': serializer.toJson<Place>(place),
    };
  }

  CachePlaces copyWith({int? placeId, Place? place}) => CachePlaces(
        placeId: placeId ?? this.placeId,
        place: place ?? this.place,
      );
  @override
  String toString() {
    return (StringBuffer('CachePlaces(')
          ..write('placeId: $placeId, ')
          ..write('place: $place')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(placeId.hashCode, place.hashCode));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachePlaces &&
          other.placeId == this.placeId &&
          other.place == this.place);
}

class TableCachePlacesCompanion extends UpdateCompanion<CachePlaces> {
  final Value<int> placeId;
  final Value<Place> place;
  const TableCachePlacesCompanion({
    this.placeId = const Value.absent(),
    this.place = const Value.absent(),
  });
  TableCachePlacesCompanion.insert({
    this.placeId = const Value.absent(),
    required Place place,
  }) : place = Value(place);
  static Insertable<CachePlaces> custom({
    Expression<int>? placeId,
    Expression<Place>? place,
  }) {
    return RawValuesInsertable({
      if (placeId != null) 'place_id': placeId,
      if (place != null) 'place': place,
    });
  }

  TableCachePlacesCompanion copyWith(
      {Value<int>? placeId, Value<Place>? place}) {
    return TableCachePlacesCompanion(
      placeId: placeId ?? this.placeId,
      place: place ?? this.place,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (placeId.present) {
      map['place_id'] = Variable<int>(placeId.value);
    }
    if (place.present) {
      final converter = $TableCachePlacesTable.$converter0;
      map['place'] = Variable<String>(converter.mapToSql(place.value)!);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TableCachePlacesCompanion(')
          ..write('placeId: $placeId, ')
          ..write('place: $place')
          ..write(')'))
        .toString();
  }
}

class $TableCachePlacesTable extends TableCachePlaces
    with TableInfo<$TableCachePlacesTable, CachePlaces> {
  final GeneratedDatabase _db;
  final String? _alias;
  $TableCachePlacesTable(this._db, [this._alias]);
  final VerificationMeta _placeIdMeta = const VerificationMeta('placeId');
  @override
  late final GeneratedIntColumn placeId = _constructPlaceId();
  GeneratedIntColumn _constructPlaceId() {
    return GeneratedIntColumn(
      'place_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _placeMeta = const VerificationMeta('place');
  @override
  late final GeneratedTextColumn place = _constructPlace();
  GeneratedTextColumn _constructPlace() {
    return GeneratedTextColumn(
      'place',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [placeId, place];
  @override
  $TableCachePlacesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'table_cache_places';
  @override
  final String actualTableName = 'table_cache_places';
  @override
  VerificationContext validateIntegrity(Insertable<CachePlaces> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('place_id')) {
      context.handle(_placeIdMeta,
          placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta));
    }
    context.handle(_placeMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {placeId};
  @override
  CachePlaces map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return CachePlaces.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $TableCachePlacesTable createAlias(String alias) {
    return $TableCachePlacesTable(_db, alias);
  }

  static TypeConverter<Place, String> $converter0 = const PlaceConverter();
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $TableSearchHistoryTable tableSearchHistory =
      $TableSearchHistoryTable(this);
  late final $TableFavoritesTable tableFavorites = $TableFavoritesTable(this);
  late final $TableCachePlacesTable tableCachePlaces =
      $TableCachePlacesTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [tableSearchHistory, tableFavorites, tableCachePlaces];
}
