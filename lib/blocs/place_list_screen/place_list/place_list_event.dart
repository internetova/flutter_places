part of 'place_list_bloc.dart';

/// события для [PlaceListScreen]
abstract class PlaceListEvent extends Equatable {
  const PlaceListEvent();
}

/// запрошены данные из сети
/// если геопозиция запрещена, то запрашиваем все данные
/// иначе делаем запрос с фильтром
class PlaceListRequested extends PlaceListEvent {
  final UserLocation? userLocation;
  final SearchFilter? filter;
  final bool isNewRequest;

  PlaceListRequested({this.userLocation, this.filter, this.isNewRequest = true});

  @override
  List<Object?> get props => [userLocation, filter];
}

// запрошены данные из кэша
class LocalPlaceListRequested extends PlaceListEvent {
  LocalPlaceListRequested();

  @override
  List<Object?> get props => [];
}

/// нажата кнопка Избранное
class PlaceListPressedFavorites extends PlaceListEvent {
  final Place place;

  PlaceListPressedFavorites(this.place);

  @override
  List<Object?> get props => [place];
}
