import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';

part 'move_to_visited_state.dart';

/// кубит для перемещения места в посещенные после открытия карты по заданию 16.2.3
class MoveToVisitedCubit extends Cubit<MoveToVisitedState> {
  final PlaceInteractor _interactor;
  final Place place;

  MoveToVisitedCubit(this._interactor, {required this.place})
      : super(MoveToVisitedState(place));

  /// если место в запланированных, то обновим информацию в локальной бд
  void moveToVisited(Place place) {
    final Place visitedPlace = Place.switchFavoriteStatusVisited(
      place: place);

    _interactor.moveToVisited(visitedPlace);
    emit(MoveToVisitedState(visitedPlace));
  }

  /// если места в избранных нет, то добавим новое место в бд
  void addToVisited(Place place) {
    final Place visitedPlace = Place.switchFavoriteStatusVisited(
      place: place);

    _interactor.addToFavorites(visitedPlace);
    emit(MoveToVisitedState(visitedPlace));
  }
}
