import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:places/data/model/place.dart';

part 'selected_place_state.dart';

/// кубит выбранного места на карте (когда кликаем по маркерам)
class SelectedPlaceCubit extends Cubit<SelectedPlaceState> {
  SelectedPlaceCubit() : super(SelectedPlaceState(null));

  /// обновляет выбранное место для показа / скрытия карточки
  void selectedPlace(Place? place) {
    emit(SelectedPlaceState(place));
  }
}
