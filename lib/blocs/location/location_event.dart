part of 'location_bloc.dart';

/// события для определения геопозиции
@immutable
abstract class LocationEvent {}

/// определение позиции
/// если нет - делаем разовый запрос
class LocationStarted extends LocationEvent {}

/// текущие данные позиции
class LocationChanged extends LocationEvent {
  final Position position;

  LocationChanged({required this.position});
}
