import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:places/blocs/add_place_screen/fields/fields_bloc.dart';
import 'package:places/blocs/add_place_screen/user_images/user_images_cubit.dart';
import 'package:places/data/dto/place_dto.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place_type.dart';
import 'package:places/ui/screen/add_place_screen/widgets/inform_dialog_widget.dart';

part 'add_form_event.dart';

part 'add_form_state.dart';

class AddFormBloc extends Bloc<AddFormEvent, AddFormState> {
  final PlaceInteractor placeInteractor;

  AddFormBloc(this.placeInteractor) : super(AddFormInitial());

  @override
  Stream<AddFormState> mapEventToState(
    AddFormEvent event,
  ) async* {
    if (event is FormEventSubmitted) {
      yield AddFormSubmitting();

      try {
        // todo потом удалить
        await Future.delayed(Duration(seconds: 1));

        /// TODO: загрузка фото
        /// временно
        /// данные о фото берём из [UserImagesState imagesState]
        const _images = [
          'https://picsum.photos/1000/600?random=1',
          'https://picsum.photos/1000/600?random=2',
        ];

        /// сюда сохраним данные полей формы
        PlaceDto newPlace = PlaceDto(
          placeType: PlaceType.getCode(event.fieldsState.fieldCategory),
          name: event.fieldsState.fieldName,
          lat: double.tryParse(event.fieldsState.fieldLat) as double,
          lng: double.tryParse(event.fieldsState.fieldLng) as double,
          description: event.fieldsState.fieldDescription,
          urls: _images,
        );

        /// и потом отправим на сервер
        /// todo раскоментировать
        /// закоментировала чтобы не сорить на сервере
        // await placeInteractor.addNewPlace(newPlace);

        /// подтверждаем сохранение данных
        showDialog(
            context: event.context,
            builder: (_) {
              return InformDialogWidget(
                category: event.fieldsState.fieldCategory,
                name: newPlace.name,
                lat: newPlace.lat,
                lng: newPlace.lng,
                description: newPlace.description,
              );
            });

        yield AddFormSubmissionSuccess();
      } catch (e) {
        yield AddFormSubmissionFailed(e as Exception);
        rethrow;
      }
    }
  }
}
