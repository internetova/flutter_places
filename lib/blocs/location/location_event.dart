part of 'location_bloc.dart';

/// события для определения геопозиции
@immutable
abstract class LocationEvent {}

/// определение позиции
/// [isObserver] - если true, то следим за изменением геопозиции,
/// если нет - делаем разовый запрос
class LocationStarted extends LocationEvent {
  final bool isObserver;

  LocationStarted({this.isObserver = false});
}

/// текущие данные позиции
class LocationChanged extends LocationEvent {
  final Position position;

  LocationChanged({required this.position});
}
