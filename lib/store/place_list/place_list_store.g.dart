// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_list_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PlaceListStore on PlaceListStoreBase, Store {
  final _$listPlacesFutureAtom =
      Atom(name: 'PlaceListStoreBase.listPlacesFuture');

  @override
  ObservableFuture<List<Place>>? get listPlacesFuture {
    _$listPlacesFutureAtom.reportRead();
    return super.listPlacesFuture;
  }

  @override
  set listPlacesFuture(ObservableFuture<List<Place>>? value) {
    _$listPlacesFutureAtom.reportWrite(value, super.listPlacesFuture, () {
      super.listPlacesFuture = value;
    });
  }

  final _$getFilteredPlaceAsyncAction =
      AsyncAction('PlaceListStoreBase.getFilteredPlace');

  @override
  Future<void> getFilteredPlace(
      {required SearchFilter filter, String? keywords}) {
    return _$getFilteredPlaceAsyncAction
        .run(() => super.getFilteredPlace(filter: filter, keywords: keywords));
  }

  @override
  String toString() {
    return '''
listPlacesFuture: ${listPlacesFuture}
    ''';
  }
}
