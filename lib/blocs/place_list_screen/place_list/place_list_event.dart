part of 'place_list_bloc.dart';

/// события для [PlaceListScreen]
abstract class PlaceListEvent extends Equatable {
  const PlaceListEvent();
}

/// запрошены данные из сети
class PlaceListRequested extends PlaceListEvent {
  final SearchFilter filter;

  PlaceListRequested({required this.filter});

  @override
  List<Object?> get props => [filter];
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
