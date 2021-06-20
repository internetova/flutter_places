part of 'selected_place_cubit.dart';

/// состояние выбранного места на карте (когда кликаем по маркерам)
@immutable
class SelectedPlaceState {
  final Place? place;

  SelectedPlaceState(this.place);
}
