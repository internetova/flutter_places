import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';

part 'favorites_button_state.dart';

/// кнопка Избранное
class FavoritesButtonCubit extends Cubit<FavoritesButtonState> {
  final Place place;
  final PlaceInteractor _interactor;

  FavoritesButtonCubit(
    this._interactor, {
    required this.place,
  }) : super(FavoritesButtonState(place.isFavorite));

  void pressButton(bool isFavorite) {
    bool currentStatus = !isFavorite;
    /// вносит изменения в базах данных
    _interactor.toggleFavorites(
        Place.switchFavoriteStatusPlanned(place: place, isFav: currentStatus));

    emit(FavoritesButtonState(currentStatus));
  }
}
