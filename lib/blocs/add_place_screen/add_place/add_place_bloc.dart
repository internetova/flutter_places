import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:places/blocs/add_place_screen/add_place/form_submission_status.dart';
import 'package:places/data/dto/place_dto.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place_type.dart';
import 'package:places/ui/screen/res/strings.dart';

part 'add_place_event.dart';

part 'add_place_state.dart';

/// блок для формы добавления нового места
class AddPlaceBloc extends Bloc<AddPlaceEvent, AddPlaceState> {
  final PlaceInteractor _placeInteractor;

  AddPlaceBloc(this._placeInteractor) : super(AddPlaceState());

  @override
  Stream<AddPlaceState> mapEventToState(
    AddPlaceEvent event,
  ) async* {
    // поле Категория изменена, меняем состояние формы
    if (event is FieldCategoryChanged) {
      yield state.copyWith(fieldCategory: event.fieldCategory);

      // поле Название изменено
    } else if (event is FieldNameChanged) {
      yield state.copyWith(fieldName: event.fieldName);

      // поле Lat изменено
    } else if (event is FieldLatChanged) {
      yield state.copyWith(fieldLat: event.fieldLat);

      // поле Lng изменено
    } else if (event is FieldLngChanged) {
      yield state.copyWith(fieldLng: event.fieldLng);

      // поле Описание изменено
    } else if (event is FieldDescriptionChanged) {
      yield state.copyWith(fieldDescription: event.fieldDescription);
    } else if (event is FieldLatChanged) {
      yield state.copyWith(fieldLat: event.fieldLat);

      /// форма отправлена
    } else if (event is FormSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());

      /// 😀😀😀 todo делаю! пока отправляю так чтобы проверили то ли я вообще делаю
      print('state FormSubmitted');
      try {
        // todo форма отправляется на сервер
        _submitForm(state);

        yield state.copyWith(formStatus: SubmissionSuccess());
      } catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(e as Exception));
      }
    }
  }

  /// клик по кнопке Создать
  /// данные формы уже проверены
  Future<void> _submitForm(AddPlaceState state) async {
    /// TODO: загрузка фото
    /// временно
    const _images = [
      'https://picsum.photos/1000/600?random=1',
      'https://picsum.photos/1000/600?random=2',
    ];

    /// сюда сохраним данные полей формы
    var selectedCategory;
    PlaceDto newPlace = PlaceDto(
      placeType: PlaceType.getCode(state.fieldCategory),
      name: state.fieldName,
      lat: double.tryParse(state.fieldLat) as double,
      lng: double.tryParse(state.fieldLng) as double,
      description: state.fieldDescription,
      urls: _images,
    );

      /// проверка в консоль TODO удалить позже
      print('''
        category: ${state.fieldCategory} ${PlaceType.getCode(state.fieldCategory)},
        name: ${state.fieldName},
        lat: ${state.fieldLat},
        lng: ${state.fieldLng},
        description: ${state.fieldDescription}
        ''');

    /// и потом отправим на сервер
    /// todo раскоментировать
    /// закоментировала чтобы не сорить на сервере
    // placeInteractor.addNewPlace(newPlace);
  }
}

// todo вывести подтвержающий диалог на ui
