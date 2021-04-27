import 'package:bloc/bloc.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';

/// кнопка Избранное
class FavoritesButtonCubit extends Cubit<bool> {
  final Place place;
  final PlaceInteractor _interactor;

  FavoritesButtonCubit(
    this._interactor, {
    required this.place,
  }) : super(place.isFavorite);

  void pressButton(state) {
    bool currentStatus = !state;
    /// вносит изменения в базах данных
    _interactor.toggleFavorites(
        Place.switchFavoriteStatus(place: place, isFav: currentStatus));

    emit(currentStatus);
  }
}
