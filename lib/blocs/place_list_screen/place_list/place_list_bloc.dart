import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/data/model/object_position.dart';

part 'place_list_event.dart';

part 'place_list_state.dart';

/// блок для [PlaceListScreen]
class PlaceListBloc extends Bloc<PlaceListEvent, PlaceListState> {
  final PlaceInteractor _interactor;

  PlaceListBloc(this._interactor) : super(PlaceListLoading());

  @override
  Stream<PlaceListState> mapEventToState(PlaceListEvent event) async* {
    if (event is PlaceListRequested) {
      yield* _placeListRequested(event);
    } else if (event is LocalPlaceListRequested) {
      yield* _localPlaceListRequested();
    }
  }

  /// обрабатываем запрос данных из сети
  Stream<PlaceListState> _placeListRequested(PlaceListRequested event) async* {
    yield PlaceListLoading();

    try {
      late final List<Place> placesList;

      if (event.userLocation != null && event.filter != null) {
        placesList = await _interactor.getFilteredPlace(
          userLocation: event.userLocation!,
          filter: event.filter!,
        );
      } else {
        placesList = await _interactor.getAllPlace();
      }

      yield PlaceListLoadSuccess(placesList);
    } catch (_) {
      yield PlaceListLoadFailure();
      rethrow;
    }
  }

  /// обрабатываем запрос данных из локального хранилища
  Stream<PlaceListState> _localPlaceListRequested() async* {
    yield PlaceListLoading();

    try {
      final placesList = await _interactor.getCachePlaces();
      yield LocalPlaceListLoadSuccess(placesList);
    } catch (_) {
      yield PlaceListLoadFailure();
      rethrow;
    }
  }
}
