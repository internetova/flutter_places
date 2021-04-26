part of 'place_list_bloc.dart';

/// состояния для [PlaceListScreen]
abstract class PlaceListState extends Equatable {
  const PlaceListState();

  @override
  List<Object> get props => [];
}

/// показываем индикатор загрузки данных
class PlaceListInitial extends PlaceListState {}

/// данные загружены
class PlaceListLoadSuccess extends PlaceListState {
  final List<Place> placesList;

  PlaceListLoadSuccess(this.placesList);

  @override
  List<Object> get props => [placesList];

  @override
  String toString() => 'PlaceListLoadSuccess $placesList';
}

/// состояние ошибки
class PlaceListLoadFailure extends PlaceListState {}
