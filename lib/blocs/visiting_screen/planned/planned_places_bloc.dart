import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:places/data/interactor/favorite_interactor.dart';
import 'package:places/data/model/place.dart';

part 'planned_places_event.dart';
part 'planned_places_state.dart';

/// блок Избранное - Хочу посетить
class PlannedPlacesBloc extends Bloc<PlannedPlacesEvent, PlannedPlacesState> {
  final FavoriteInteractor _interactor;

  PlannedPlacesBloc(this._interactor) : super(PlannedPlacesLoadInProgress());

  @override
  Stream<PlannedPlacesState> mapEventToState(
    PlannedPlacesEvent event,
  ) async* {
    if (event is PlannedPlacesLoad) {
      yield* _mapLoadPlannedToState();
    } else if (event is PlannedPlacesRemovePlace) {
      yield* _mapRemovePlaceToState(event);
    }
  }

  /// список Хочу посетить
  Stream<PlannedPlacesState> _mapLoadPlannedToState() async* {
    try {
      final placesList = await _interactor.getPlannedPlaces();
      yield PlannedPlacesLoadSuccess(placesList);
    } catch (_) {
      yield PlannedPlacesLoadFailure();
      rethrow;
    }
  }

  /// удалить из избранного
  Stream<PlannedPlacesState> _mapRemovePlaceToState(
      PlannedPlacesRemovePlace event) async* {
    try {
      await _interactor.removePlace(event.place);
      add(PlannedPlacesLoad());
    } catch (_) {
      yield PlannedPlacesLoadFailure();
      rethrow;
    }
  }
}
