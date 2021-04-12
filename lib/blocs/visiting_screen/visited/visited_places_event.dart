part of 'visited_places_bloc.dart';

/// Избранное: таб Посетил
abstract class VisitedPlacesEvent extends Equatable {
  const VisitedPlacesEvent();
}

/// начало загрузки данных
class VisitedPlacesLoad extends VisitedPlacesEvent {
  @override
  List<Object> get props => [];
}

/// клик по кнопке удалить
class VisitedPlacesRemovePlace extends VisitedPlacesEvent {
  final Place place;

  VisitedPlacesRemovePlace(this.place);

  @override
  List<Object> get props => [];
}
