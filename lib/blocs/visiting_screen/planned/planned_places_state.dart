part of 'planned_places_bloc.dart';

/// состояние Избранное - Хочу посетить
abstract class PlannedPlacesState extends Equatable {
  const PlannedPlacesState();
}

class PlannedPlacesInitial extends PlannedPlacesState {
  @override
  List<Object> get props => [];
}

/// состояние загрузки
class PlannedPlacesLoadInProgress extends PlannedPlacesState {
  @override
  List<Object> get props => [];
}

/// загружено
class PlannedPlacesLoadSuccess extends PlannedPlacesState {
  final List<Place> placesList;

  PlannedPlacesLoadSuccess(this.placesList);

  @override
  List<Object> get props => [placesList];

  @override
  String toString() => 'PlannedPlacesLoadSuccess $placesList';
}

/// состояние ошибки
class PlannedPlacesLoadFailure extends PlannedPlacesState {

  @override
  List<Object> get props => [];
}