part of 'place_list_bloc.dart';

/// состояния для [PlaceListScreen]
abstract class PlaceListState extends Equatable {
  const PlaceListState();
}

/// показываем индикатор загрузки данных
class PlaceListLoading extends PlaceListState {
  @override
  List<Object?> get props => [];
}

/// данные загружены
class PlaceListLoadSuccess extends PlaceListState {
  final List<Place> placesList;

  PlaceListLoadSuccess(this.placesList);

  @override
  List<Object> get props => [placesList];
}

/// локальные данные загружены
class LocalPlaceListLoadSuccess extends PlaceListState {
  final List<Place> placesList;

  LocalPlaceListLoadSuccess(this.placesList);

  @override
  List<Object> get props => [placesList];
}

/// состояние ошибки
class PlaceListLoadFailure extends PlaceListState {
  @override
  List<Object?> get props => [];
}
