import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:places/data/model/object_position.dart';

part 'select_place_position_state.dart';

/// кубит для сохранения позиции отмеченного места на карте для дальнейшей
/// передачи в поля формы создания нового места
class SelectPlacePositionCubit extends Cubit<SelectPlacePositionState> {
  SelectPlacePositionCubit() : super(SelectPlacePositionState());

  void setPosition(ObjectPosition placePosition) {
    emit(SelectPlacePositionState(
      placePosition: placePosition,
      isButtonEnabled: true,
    ));
  }
}
