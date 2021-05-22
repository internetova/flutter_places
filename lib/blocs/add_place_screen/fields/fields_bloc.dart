import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:places/ui/res/strings.dart';

part 'fields_event.dart';

part 'fields_state.dart';

/// блок для полей формы добавления нового места
class FieldsBloc extends Bloc<FieldsEvent, FieldsState> {
  FieldsBloc() : super(FieldsState());

  @override
  Stream<FieldsState> mapEventToState(
    FieldsEvent event,
  ) async* {
    // поле Категория изменена, меняем состояние формы
    if (event is CategoryChanged) {
      yield state.copyWith(fieldCategory: event.fieldCategory);

      // поле Название изменено
    } else if (event is NameChanged) {
      yield state.copyWith(fieldName: event.fieldName);

      // поле Lat изменено
    } else if (event is LatChanged) {
      yield state.copyWith(fieldLat: event.fieldLat);

      // поле Lng изменено
    } else if (event is LngChanged) {
      yield state.copyWith(fieldLng: event.fieldLng);

      // поле Описание изменено
    } else if (event is DescriptionChanged) {
      yield state.copyWith(fieldDescription: event.fieldDescription);
    }
  }
}