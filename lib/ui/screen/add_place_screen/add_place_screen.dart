import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:places/data/dto/place_dto.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place_type.dart';
import 'package:places/ui/screen/components/button_clear.dart';
import 'package:places/ui/screen/components/button_save.dart';
import 'package:places/ui/screen/components/button_text.dart';
import 'package:places/ui/screen/components/icon_svg.dart';
import 'package:places/ui/screen/components/title_leading_appbar.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/res/themes.dart';
import 'package:places/ui/screen/add_place_screen/select_category_screen.dart';
import 'package:places/ui/screen/place_list_screen.dart';
import 'package:places/ui/screen/utilities/test_images_data.dart';
import 'package:places/ui/screen/widgets/choice_of_loading_images.dart';
import 'package:places/ui/screen/widgets/list_cards_with_added_img.dart';

/// регулярные выражения
final _namePattern = RegExp(r'^[a-zа-яA-ZА-Я0-9 ]+$');
final _coordinatesPattern = RegExp(r'^-?[0-9]{1,3}(?:\.[0-9]{1,10})?$');

/// экран добавление нового места
class AddPlaceScreen extends StatefulWidget {
  /// для обновления стэйта после удаления карточки с фото из дочерних виджетов
  static _AddPlaceScreenState? of(BuildContext context) =>
      context.findAncestorStateOfType<_AddPlaceScreenState>();

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();

  /// кнопка сохранения при старте отключена
  bool _isButtonEnabled = false;
  VoidCallback? _submitForm;

  /// сюда сохраним данные из формы
  late String _selectedCategory;
  late String _name;
  late double _lat;
  late double _lng;
  late String _description;

  /// сюда сохраним тестовые фотографии для загрузки
  List<TestImage> _userImages = [];

  final _categoryController = TextEditingController();
  final _nameController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _categoryFocus = FocusNode();
  final _nameFocus = FocusNode();
  final _latFocus = FocusNode();
  final _lngFocus = FocusNode();
  final _descriptionFocus = FocusNode();

  /// для передачи фокуса по тапам по полям и через клавиатуру
  FocusNode? _currentFocus;

  @override
  void initState() {
    super.initState();

    _categoryController.addListener(() => setState(() {}));
    _nameController.addListener(() => setState(() {}));
    _latController.addListener(() => setState(() {}));
    _lngController.addListener(() => setState(() {}));
    _descriptionController.addListener(() => setState(() {}));
    _userImages = userImages;
    _selectedCategory = emptyCategory;
    _categoryController.text = _selectedCategory;
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _nameController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _descriptionController.dispose();

    _categoryFocus.dispose();
    _nameFocus.dispose();
    _latFocus.dispose();
    _lngFocus.dispose();
    _descriptionFocus.dispose();

    super.dispose();
  }

  /// обновить базу данных после удаления карточки
  /// буду вызывать из дочернего виджета
  void updateState() {
    setState(() {
      _userImages = userImages;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedCategory == emptyCategory) {
      _categoryController.text = emptyCategory;
    } else {
      _categoryController.text = _selectedCategory;

      /// если все поля что-то содержат, то кнопка активна
      if (_nameController.text.isNotEmpty &&
          _latController.text.isNotEmpty &&
          _lngController.text.isNotEmpty &&
          _descriptionController.text.isNotEmpty) {
        _isButtonEnabled = true;
      }
    }

    if (_isButtonEnabled) {
      _submitForm = () {
        final isValid = _formKey.currentState!.validate();

        if (isValid) {
          _formKey.currentState!.save();

          /// TODO: загрузка фото
          /// временно
          const _images = [
            'https://picsum.photos/1000/600?random=1',
            'https://picsum.photos/1000/600?random=2',
          ];

          /// сюда сохраним данные полей формы
          PlaceDto newPlace = PlaceDto(
            placeType: PlaceType.getCode(_selectedCategory),
            name: _name,
            lat: _lat,
            lng: _lng,
            description: _description,
            urls: _images,
          );

          /// и потом отправим на сервер
          /// test Interactor
          PlaceInteractor().addNewPlace(newPlace);

          /// подтверждаем сохранение данных
          _showDialog(
            category: _selectedCategory,
            name: _name,
            lat: _lat,
            lng: _lng,
            description: _description,
          );
        }
      };
    }

    return Scaffold(
      appBar: _buildAddSightAppBar() as PreferredSizeWidget?,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: GestureDetector(
                onTap: () {
                  if (_currentFocus != null) {
                    _currentFocus!.unfocus();
                    _currentFocus = null;
                  }
                },
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ListCardsWithAddedImg(
                        data: _userImages,
                        addImage: _addImg,
                      ),
                      sizedBoxH24,
                      ..._buildCategory(),
                      sizedBoxH24,
                      ..._buildName(),
                      sizedBoxH24,
                      Row(
                        children: [
                          _buildLat(),
                          sizedBoxW16,
                          _buildLon(),
                        ],
                      ),
                      _buildButtonShowOnMap(),
                      sizedBoxH12,
                      ..._buildDetails(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ButtonSave(
                title: titleButtonSaveAddSightScreen,
                isButtonEnabled: _isButtonEnabled,
                onPressed: _submitForm,
              ),
            ),
          ),
        ],
      ),
      // resizeToAvoidBottomInset: false,
    );
  }

  /// AppBar
  Widget _buildAddSightAppBar() => AppBar(
        toolbarHeight: toolbarHeightStandard,
        leadingWidth: 100,
        leading: TitleLeadingAppBar(
          title: leadingAppBarAddSightScreen,
        ),
        title: Text(
          titleAppBarAddSightScreen,
        ),
        centerTitle: true,
      );

  /// Поле Категория
  List<Widget> _buildCategory() {
    return [
      Text(
        addNewSightLabelSelectedCategory,
        style: Theme.of(context)
            .textTheme
            .caption!
            .copyWith(color: Theme.of(context).colorScheme.inactiveBlack),
      ),
      sizedBoxH12,
      SizedBox(
        height: 48,
        child: Theme(
          data: ThemeData(
            inputDecorationTheme: InputDecorationTheme(
              errorStyle: TextStyle(fontSize: 0),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: _categoryController.text != emptyCategory
                      ? Theme.of(context).accentColor.withOpacity(0.4)
                      : Theme.of(context)
                          .colorScheme
                          .inactiveBlack
                          .withOpacity(0.24),
                  width: 1,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context)
                      .colorScheme
                      .inactiveBlack
                      .withOpacity(0.24),
                  style: BorderStyle.solid,
                  width: 1,
                ),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).errorColor.withOpacity(0.4),
                  style: BorderStyle.solid,
                  width: 1,
                ),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).errorColor.withOpacity(0.4),
                  style: BorderStyle.solid,
                  width: 2,
                ),
              ),
            ),
          ),
          child: TextFormField(
            focusNode: _categoryFocus,
            autofocus: true,
            controller: _categoryController,
            showCursor: false,
            maxLines: 1,
            style: _selectedCategory == emptyCategory
                ? Theme.of(context)
                    .primaryTextTheme
                    .subtitle1!
                    .copyWith(color: Theme.of(context).colorScheme.secondary2)
                : Theme.of(context).primaryTextTheme.subtitle1,
            readOnly: true,
            decoration: InputDecoration(
              suffixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: IconSvg(
                  icon: icView,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            validator: _validateCategory,
            onSaved: (value) => setState(() => _selectedCategory = value as String),
            onTap: () {
              _returnCategoryFromSelectCategoryScreen();
            },
          ),
        ),
      ),
    ];
  }

  /// получаем выбранную категорию из экрана с категориями
  void _returnCategoryFromSelectCategoryScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SelectCategoryScreen(selectedCategory: _selectedCategory),
      ),
    );
    setState(() {
      _selectedCategory = result;
      _fieldFocusChange(context, _categoryFocus, _nameFocus);
    });
  }

  /// поле Название
  List<Widget> _buildName() {
    return [
      const Text(addNewSightLabelName),
      sizedBoxH12,
      SizedBox(
        height: heightInput,
        child: TextFormField(
          focusNode: _nameFocus,
          autofocus: true,
          onFieldSubmitted: (_) {
            _fieldFocusChange(context, _nameFocus, _latFocus);
          },
          onTap: () {
            setState(() {
              _currentFocus = _nameFocus;
            });
          },
          controller: _nameController,
          cursorHeight: 24,
          cursorWidth: 1,
          maxLength: 100,
          maxLines: 1,
          textInputAction: TextInputAction.next,
          style: Theme.of(context).primaryTextTheme.subtitle1,
          decoration: InputDecoration(
            counterText: '',
            suffixIcon: _clearField(
                context: context,
                currentFocus: _nameFocus,
                controller: _nameController),
            enabledBorder: _buildBorderColor(_nameController),
          ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(100),
          ],
          validator: _validateName,
          onSaved: (value) => setState(() => _name = value as String),
        ),
      ),
    ];
  }

  /// поле Широта
  Widget _buildLat() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(addNewSightLabelLat),
          sizedBoxH12,
          SizedBox(
            height: heightInput,
            child: TextFormField(
              focusNode: _latFocus,
              autofocus: true,
              onFieldSubmitted: (_) {
                _fieldFocusChange(context, _latFocus, _lngFocus);
              },
              onTap: () {
                setState(() {
                  _currentFocus = _latFocus;
                });
              },
              controller: _latController,
              cursorHeight: 24,
              cursorWidth: 1,
              maxLength: 50,
              maxLines: 1,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              style: Theme.of(context).primaryTextTheme.subtitle1,
              decoration: InputDecoration(
                counterText: '',
                suffixIcon: _clearField(
                    context: context,
                    currentFocus: _latFocus,
                    controller: _latController),
                enabledBorder: _buildBorderColor(_latController),
              ),
              validator: _validateCoordinates,
              onSaved: (value) =>
                  setState(() => _lat = double.tryParse(value!) as double),
            ),
          ),
        ],
      ),
    );
  }

  /// поле Долгота
  Widget _buildLon() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(addNewSightLabelLon),
          sizedBoxH12,
          SizedBox(
            height: heightInput,
            child: TextFormField(
              focusNode: _lngFocus,
              autofocus: true,
              onFieldSubmitted: (_) {
                _fieldFocusChange(context, _lngFocus, _descriptionFocus);
              },
              onTap: () {
                setState(() {
                  _currentFocus = _lngFocus;
                });
              },
              controller: _lngController,
              cursorHeight: 24,
              cursorWidth: 1,
              maxLength: 50,
              maxLines: 1,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              style: Theme.of(context).primaryTextTheme.subtitle1,
              decoration: InputDecoration(
                counterText: '',
                suffixIcon: _clearField(
                    context: context,
                    currentFocus: _lngFocus,
                    controller: _lngController),
                enabledBorder: _buildBorderColor(_lngController),
              ),
              validator: _validateCoordinates,
              onSaved: (value) =>
                  setState(() => _lng = double.tryParse(value!) as double),
            ),
          ),
        ],
      ),
    );
  }

  /// кнопка Указать на карте
  Widget _buildButtonShowOnMap() => ButtonText(
        title: addNewSightTitleShowOnMap,
        onPressed: () {
          print('onPressed: $addNewSightTitleShowOnMap');
        },
      );

  /// поле Описание
  List<Widget> _buildDetails() {
    return [
      const Text(addNewSightLabelDetails),
      sizedBoxH12,
      TextFormField(
        focusNode: _descriptionFocus,
        autofocus: true,
        onEditingComplete: () {
          _descriptionFocus.unfocus();
          _currentFocus = null;
        },
        onTap: () {
          setState(() {
            _currentFocus = _descriptionFocus;
          });
        },
        controller: _descriptionController,
        cursorHeight: 24,
        cursorWidth: 1,
        maxLength: 300,
        maxLines: 3,
        textInputAction: TextInputAction.done,
        style: Theme.of(context).primaryTextTheme.subtitle1,
        decoration: InputDecoration(
          counterText: '',
          hintText: addNewSightHintTextDetails,
          hintStyle: Theme.of(context)
              .primaryTextTheme
              .subtitle1!
              .copyWith(color: Theme.of(context).colorScheme.inactiveBlack),
          suffixIcon: _clearField(
              context: context,
              currentFocus: _descriptionFocus,
              controller: _descriptionController),
          enabledBorder: _buildBorderColor(_descriptionController),
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(300),
        ],
        validator: _validateDetails,
        onSaved: (value) => setState(() => _description = value as String),
      ),
    ];
  }

  /// валидация полей
  String? _validateCategory(String? value) {
    if (value!.isEmpty || value == emptyCategory) return errorEmptyCategory;

    return null;
  }

  String? _validateName(String? value) {
    final _nameExp = _namePattern;
    if (value!.isEmpty) return errorEmptyName;
    if (value.length < 5) return errorShortName;
    if (!_nameExp.hasMatch(value)) return errorIncorrectName;

    return null;
  }

  String? _validateCoordinates(String? value) {
    final _coordinatesExp = _coordinatesPattern;
    if (value!.isEmpty) return errorEmptyCoordinates;
    if (!_coordinatesExp.hasMatch(value)) return errorIncorrectCoordinates;

    return null;
  }

  String? _validateDetails(String? value) {
    if (value!.isEmpty) return errorEmptyDetails;
    if (value.length < 100) return errorShortDetails;

    return null;
  }

  /// конец валидации

  /// переключение фокуса в полях формы
  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
    setState(() {
      _currentFocus = nextFocus;
    });
  }

  /// очистка поля по кнопке
  Widget _clearField(
      {required BuildContext context,
      required FocusNode currentFocus,
      required TextEditingController controller}) {
    if (currentFocus == _currentFocus && controller.text.isNotEmpty) {
      return ButtonClear(controller: controller);
    }

    return const SizedBox(width: 0);
  }

  /// цвет границы у уже правильно заполненного поля
  InputBorder _buildBorderColor(TextEditingController controller) =>
      Theme.of(context).inputDecorationTheme.enabledBorder!.copyWith(
            borderSide: BorderSide(
              color: controller.text.isNotEmpty
                  ? Theme.of(context).accentColor.withOpacity(0.4)
                  : Theme.of(context).colorScheme.inactiveBlack,
              style: BorderStyle.solid,
              width: 1,
            ),
          );

  /// показываем окно если форма валидна
  void _showDialog({
    String? category,
    String? name,
    double? lat,
    double? lng,
    String? description,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusCard),
            ),
            title: Text(
              addNewSightAlertDialogHeader,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Theme.of(context).accentColor),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  category!,
                  style: Theme.of(context).primaryTextTheme.subtitle1,
                ),
                sizedBoxH12,
                Text(
                  name!,
                  style: Theme.of(context).primaryTextTheme.subtitle1,
                ),
                Text(
                  '${description!.substring(0, 100)} ...',
                  style: Theme.of(context).primaryTextTheme.subtitle1,
                ),
                sizedBoxH12,
                Text(
                  '$addNewSightAlertDialogLat$lat',
                  style: Theme.of(context).primaryTextTheme.bodyText2,
                ),
                Text(
                  '$addNewSightAlertDialogLon$lng',
                  style: Theme.of(context).primaryTextTheme.bodyText2,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlaceListScreen(),
                    ),
                  );
                },
                child: Text(
                  addNewSightAlertDialogSubmit,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Theme.of(context).accentColor),
                ),
              ),
            ],
          );
        });
  }

  /// клик по кнопке добавления фотографии - заполняем тестовыми данными
  void _addImg() {
    setState(() {
      _userImages.add(TestImagesData.getRandomItem());
    });
    _showImageLoadingWindow();
  }

  /// окно для выбора загрузки фотографий
  Future<void> _showImageLoadingWindow() async {
    return showDialog(
        context: context,
        // barrierDismissible: true,
        builder: (_) {
          return ChoiceOfLoadingImages();
        });
  }
}