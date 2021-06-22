part of 'select_place_position_cubit.dart';

/// стейт позиции места на карте для создания нового места
@immutable
class SelectPlacePositionState {
  /// позиция места
  final ObjectPosition? placePosition;

  /// кнопка сохранения выбора на старте
  final bool isButtonEnabled;

  const SelectPlacePositionState({
    this.placePosition,
    this.isButtonEnabled = false,
  });
}
