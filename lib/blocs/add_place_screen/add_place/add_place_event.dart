part of 'add_place_bloc.dart';

/// события для формы
abstract class AddPlaceEvent extends Equatable {
  const AddPlaceEvent();
}

/// события изменения полей формы
class FieldCategoryChanged extends AddPlaceEvent {
  final String? fieldCategory;

  FieldCategoryChanged({this.fieldCategory});

  @override
  List<Object?> get props => [fieldCategory];
}

class FieldNameChanged extends AddPlaceEvent {
  final String? fieldName;

  FieldNameChanged({this.fieldName});

  @override
  List<Object?> get props => [fieldName];
}

class FieldLatChanged extends AddPlaceEvent {
  final String? fieldLat;

  FieldLatChanged({this.fieldLat});

  @override
  List<Object?> get props => [fieldLat];
}

class FieldLngChanged extends AddPlaceEvent {
  final String? fieldLng;

  FieldLngChanged({this.fieldLng});

  @override
  List<Object?> get props => [fieldLng];
}

class FieldDescriptionChanged extends AddPlaceEvent {
  final String? fieldDescription;

  FieldDescriptionChanged({this.fieldDescription});

  @override
  List<Object?> get props => [fieldDescription];
}

/// форма отправлена
class FormSubmitted extends AddPlaceEvent {
  @override
  List<Object?> get props => [];
}
