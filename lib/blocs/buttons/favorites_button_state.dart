part of 'favorites_button_cubit.dart';

/// кнопка Избранное
class FavoritesButtonState extends Equatable {
  final bool isFavorite;

  FavoritesButtonState(this.isFavorite);

  @override
  List<Object?> get props => [isFavorite];
}
