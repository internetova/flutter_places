import 'package:bloc/bloc.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:flutter/cupertino.dart';

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
        Place.switchFavoriteStatus(place: place, isFav: currentStatus));

    emit(FavoritesButtonState(currentStatus));
  }
}
