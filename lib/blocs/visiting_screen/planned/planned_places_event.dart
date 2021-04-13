part of 'planned_places_bloc.dart';

/// Избранное - Хочу посетить
abstract class PlannedPlacesEvent extends Equatable {
  const PlannedPlacesEvent();
}

/// загружается список мест
class PlannedPlacesLoad extends PlannedPlacesEvent {
  @override
  List<Object> get props => [];
}

/// клик по кнопке удалить
class PlannedPlacesRemovePlace extends PlannedPlacesEvent {
  final Place place;

  PlannedPlacesRemovePlace(this.place);

  @override
  List<Object> get props => [];
}
