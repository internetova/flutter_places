import 'package:flutter/material.dart' hide Action;
import 'package:mwwm/mwwm.dart';
import 'package:places/data/dto/place_dto.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place_type.dart';
import 'package:places/ui/screen/add_place_screen/select_category_screen.dart';
import 'package:places/ui/screen/add_place_screen/widgets/inform_dialog_widget.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/utilities/test_images_data.dart';
import 'package:relation/relation.dart';

/// регулярные выражения
final _namePattern = RegExp(r'^[a-zа-яA-ZА-Я0-9 ]+$');
final _coordinatesPattern = RegExp(r'^-?[0-9]{1,3}(?:\.[0-9]{1,10})?$');

/// WidgetModel экрана Добавить новое место [AddPlaceScreen]
/// сюда выносим все состояния и методы виджета AddPlaceScreen
class AddPlaceWidgetModel extends WidgetModel {
  final PlaceInteractor placeInteractor;
  final NavigatorState navigator;

  AddPlaceWidgetModel(
    WidgetModelDependencies baseDependencies, {
    required this.placeInteractor,
    required this.navigator,
  }) : super(baseDependencies);

  /// ключ для формы
  final formKey = GlobalKey<FormState>();

  /// Изменяемые состояния элементов экрана
  ///
  /// кнопка создания нового места при старте отключена
  /// делается доступной когда все поля заполнены
  final isButtonEnabledState = StreamedState<bool>(false);

  /// список добавленных фото для загрузки
  final userListImgState = StreamedState<List<TestImage>>([]);

  /// Действия на экране
  ///
  /// выбрать категорию
  final Action selectCategory = Action<void>();

  /// добавить фотографию
  final Action addImg = Action<void>();

  /// удалить фотографию
  final Action removeImg = Action<void>();

  /// отправка заполненных данных формы
  final Action submitForm = Action<void>();

  /// сюда сохраним данные из формы
  late String selectedCategory;
  late String name;
  late double lat;
  late double lng;
  late String description;

  /// сюда сохраним тестовые фотографии для загрузки
  List<TestImage> _userImages = [];

  /// поля формы
  final TextEditingAction fieldCategory = TextEditingAction();
  final TextEditingAction fieldName = TextEditingAction();
  final TextEditingAction fieldLat = TextEditingAction();
  final TextEditingAction fieldLng = TextEditingAction();
  final TextEditingAction fieldDescription = TextEditingAction();

  /// фокус
  final FocusNode fieldCategoryFocus = FocusNode();
  final FocusNode fieldNameFocus = FocusNode();
  final FocusNode fieldLatFocus = FocusNode();
  final FocusNode fieldLngFocus = FocusNode();
  final FocusNode fieldDescriptionFocus = FocusNode();

  @override
  void dispose() {
    fieldCategoryFocus.dispose();
    fieldNameFocus.dispose();
    fieldLatFocus.dispose();
    fieldLngFocus.dispose();
    fieldDescriptionFocus.dispose();

    super.dispose();
  }

  @override
  void onLoad() {
    super.onLoad();

    /// при старте в категории 'Не выбрано'
    fieldCategory.controller.text = emptyCategory;
    _setFocus(fieldCategoryFocus);
  }

  @override
  void onBind() {
    super.onBind();
    subscribe(selectCategory.stream, _onSelectCategory);
    subscribe(submitForm.stream,
        (context) => _submitForm(context as BuildContext) as dynamic);

    /// работа с фото добавить / удалить
    subscribe(addImg.stream, _addImg);
    subscribe(removeImg.stream, (index) => _removeImg(index as int));
  }

  /// выбрать категорию (onTap)
  Future<void> _onSelectCategory(_) async {
    final result = await navigator.push(
      MaterialPageRoute(
        builder: (context) => SelectCategoryScreen(
            selectedCategory: fieldCategory.controller.text),
      ),
    ) as String;

    fieldCategory.controller.text = result;
    _setFocus(fieldNameFocus);
  }

  /// установка текущего фокуса
  void _setFocus(FocusNode focus) {
    focus.requestFocus();
  }

  /// перевод фокуса по клавиатуре на следующее поле
  void fieldFocusChange(FocusNode nextFocus) {
    nextFocus.requestFocus(nextFocus);
  }

  /// очистить фокус
  void clearFocus(FocusNode currentFocus) {
    currentFocus.unfocus();
    // currentFocusState.accept(null);
  }

  /// валидация полей
  String? validateCategory(String? value) {
    _checkFieldsFilled();
    if (value!.isEmpty || value == emptyCategory) return errorEmptyCategory;

    return null;
  }

  String? validateName(String? value) {
    _checkFieldsFilled();
    final _nameExp = _namePattern;
    if (value!.isEmpty) return errorEmptyName;
    if (value.length < 5) return errorShortName;
    if (value.length > 80) return errorLongName;
    if (!_nameExp.hasMatch(value)) return errorIncorrectName;

    return null;
  }

  String? validateCoordinates(String? value) {
    _checkFieldsFilled();
    final _coordinatesExp = _coordinatesPattern;
    if (value!.isEmpty) return errorEmptyCoordinates;
    if (!_coordinatesExp.hasMatch(value)) return errorIncorrectCoordinates;

    return null;
  }

  String? validateDetails(String? value) {
    _checkFieldsFilled();
    if (value!.isEmpty) return errorEmptyDetails;
    if (value.length < 100) return errorShortDetails;
    if (value.length > 300) return errorLongDetails;

    return null;
  }

  /// конец валидации

  /// если поля заполнены активируем кнопку
  void _checkFieldsFilled() {
    isButtonEnabledState.accept(fieldCategory.controller.text.isNotEmpty &&
        fieldName.controller.text.isNotEmpty &&
        fieldLat.controller.text.isNotEmpty &&
        fieldLng.controller.text.isNotEmpty &&
        fieldDescription.controller.text.isNotEmpty);
  }

  /// сохраненение данных из полей если форма валидна
  void saveSelectedCategory(String? value) {
    selectedCategory = value!;
  }

  void saveName(String? value) {
    name = value!;
  }

  void saveLat(String? value) {
    lat = double.tryParse(value!) as double;
  }

  void saveLng(String? value) {
    lng = double.tryParse(value!) as double;
  }

  void saveDescription(String? value) {
    description = value!;
  }

  /// клик по кнопке Создать
  Future<void> _submitForm(BuildContext context) async {
    final isValid = formKey.currentState!.validate();

    if (isValid) {
      formKey.currentState!.save();

      _savePlace();

      /// проверка в консоль TODO удалить позже
      print('''
        category: $selectedCategory ${PlaceType.getCode(selectedCategory)},
        name: $name,
        lat: $lat,
        lng: $lng,
        description: $description
        ''');

      /// подтверждаем сохранение данных
      return showDialog(
          context: context,
          builder: (_) {
            return InformDialogWidget(
              category: selectedCategory,
              name: name,
              lat: lat,
              lng: lng,
              description: description,
            );
          });
    }
  }

  /// сохраняем на сервер
  Future<void> _savePlace() async {
    /// TODO: загрузка фото
    /// временно
    const _images = [
      'https://picsum.photos/1000/600?random=1',
      'https://picsum.photos/1000/600?random=2',
    ];

    /// сюда сохраним данные полей формы
    PlaceDto newPlace = PlaceDto(
      placeType: PlaceType.getCode(selectedCategory),
      name: name,
      lat: lat,
      lng: lng,
      description: description,
      urls: _images,
    );

    /// и потом отправим на сервер
    /// закоментировала чтобы не сорить на сервере//todo раскоментировать
    // placeInteractor.addNewPlace(newPlace);
  }

  /// onTap по кнопке Добавить фото (+)
  void _addImg(_) {
    _userImages.add(TestImagesData.getRandomItem());
    userListImgState.accept(_userImages);
  }

  /// onTap или смахивание вверх по карточке с фото
  void _removeImg(int index) {
    _userImages.removeAt(index);
    userListImgState.accept(_userImages);
  }
}
