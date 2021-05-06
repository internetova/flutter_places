import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/search_filter.dart';

part 'place_list_event.dart';
part 'place_list_state.dart';

/// блок для [PlaceListScreen]
class PlaceListBloc extends Bloc<PlaceListEvent, PlaceListState> {
  final PlaceInteractor _interactor;

  PlaceListBloc(this._interactor) : super(PlaceListLoading());

  @override
  Stream<PlaceListState> mapEventToState(PlaceListEvent event) async* {
    if (event is PlaceListRequested) {
      yield* _mapPlaceListRequestedToState(event);
    }
  }

  /// обрабатываем запрос данных
  Stream<PlaceListState> _mapPlaceListRequestedToState(
      PlaceListRequested event) async* {
    yield PlaceListLoading();

    try {
      final placesList =
          await _interactor.getFilteredPlace(filter: event.filter);
      yield PlaceListLoadSuccess(placesList);
    } catch (_) {
      yield PlaceListLoadFailure();
      rethrow;
    }
  }
}
