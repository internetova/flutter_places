part of 'location_bloc.dart';

/// состояние определения геопозиции
@immutable
abstract class LocationState {}

class LocationInitial extends LocationState {}

/// данные загружаются
class LocationLoadInProgress extends LocationState {}

/// данные загружены
class LocationLoadSuccess extends LocationState {
  final Position position;

  LocationLoadSuccess({required this.position});
}

/// неудача
class LocationFailure extends LocationState {
  final String errorMessage;

  LocationFailure(this.errorMessage);
}
