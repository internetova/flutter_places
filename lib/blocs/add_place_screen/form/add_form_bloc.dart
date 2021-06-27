import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:places/blocs/add_place_screen/fields/fields_cubit.dart';
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
        await Future.delayed(Duration(seconds: 3));

        /// когда все поля формы заполнены
        /// 1. Загружаем фото на сервер
        /// 2. Записываем адреса в список загруженных фото
        /// 3. Формируем место PlaceDto
        /// 4. Добавляем место на сервер

        /// данные о фото берём из [UserImagesState imagesState]
        final _imagesToUpload = event.imagesState.userImages;

        /// загруженные фото
        List<String> _imagesUploaded = [];

        /// загружаем фото на сервер и возвращаем адреса
        /// todo раскоментировать
        /// закоментировала чтобы не сорить на сервере
        // for (var i = 0; i < _imagesToUpload.length; i++) {
        //   _imagesUploaded
        //       .add(await placeInteractor.uploadFile(_imagesToUpload[i]));
        // }

        /// сюда сохраним данные полей формы
        PlaceDto newPlace = PlaceDto(
          placeType: PlaceType.getCode(event.fieldsState.fieldCategory),
          name: event.fieldsState.fieldName,
          lat: double.tryParse(event.fieldsState.fieldLat) as double,
          lng: double.tryParse(event.fieldsState.fieldLng) as double,
          description: event.fieldsState.fieldDescription,
          urls: _imagesUploaded,
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
