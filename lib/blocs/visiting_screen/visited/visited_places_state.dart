part of 'visited_places_bloc.dart';

/// базовый стейт экрана Избранное
abstract class VisitedPlacesState extends Equatable {
  const VisitedPlacesState();
}

class VisitedPlacesInitial extends VisitedPlacesState {
  @override
  List<Object> get props => [];
}

/// состояние загрузки
class VisitedPlacesLoadInProgress extends VisitedPlacesState {
  @override
  List<Object> get props => [];
}

/// состояние загруженных данных
/// в зависимости от события загружаем либо список запланированных, либо
/// посещённых мест
class VisitedPlacesLoadSuccess extends VisitedPlacesState {
  final List<Place> placesList;

  VisitedPlacesLoadSuccess(this.placesList);

  @override
  List<Object> get props => [placesList];

  @override
  String toString() => 'VisitedPlacesLoadSuccess $placesList';
}

/// состояние ошибки
class VisitedPlacesLoadFailure extends VisitedPlacesState {

  @override
  List<Object> get props => [];
}
