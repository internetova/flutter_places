import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:places/components/button_save.dart';
import 'package:places/components/button_text.dart';
import 'package:places/components/icon_svg.dart';
import 'package:places/components/title_leading_appbar.dart';
import 'package:places/domain/sight.dart';
import 'package:places/mocks.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/res/themes.dart';
import 'package:places/ui/screen/select_category_screen.dart';
import 'package:places/ui/screen/sight_list_screen.dart';

/// константы для экрана
const _emptyCategory = 'Не выбрано';
const _errorEmptyCategory = 'Выберите Категорию';
const _errorEmptyName = 'Заполните Название';
const _errorShortName = 'Название слишком короткое';
const _errorIncorrectName = 'Только буквы и цифры';
const _errorEmptyCoordinates = 'Укажите данные';
const _errorIncorrectCoordinates = 'Некорректные данные';
const _errorEmptyDetails = 'Заполните Описание min 100 символов';
const _errorShortDetails = 'Описание меньше 100 символов';

/// регулярные выражения
final _namePattern = RegExp(r'^[a-zа-яA-ZА-Я0-9 ]+$');
final _coordinatesPattern = RegExp(r'^-?[0-9]{1,3}(?:\.[0-9]{1,10})?$');

/// добавление нового места
class AddSightScreen extends StatefulWidget {
  @override
  _AddSightScreenState createState() => _AddSightScreenState();
}

class _AddSightScreenState extends State<AddSightScreen> {
  final _formKey = GlobalKey<FormState>();

  /// кнопка сохранения при старте отключена
  bool _isButtonEnabled = false;
  VoidCallback _submitForm;

  /// сюда сохраним данные из формы
  String _selectedCategory;
  String _name;
  double _lat;
  double _lon;
  String _details;

  final _categoryController = TextEditingController();
  final _nameController = TextEditingController();
  final _latController = TextEditingController();
  final _lonController = TextEditingController();
  final _detailsController = TextEditingController();

  final _categoryFocus = FocusNode();
  final _nameFocus = FocusNode();
  final _latFocus = FocusNode();
  final _lonFocus = FocusNode();
  final _detailsFocus = FocusNode();

  /// для передачи фокуса по тапам по полям и через клавиатуру
  FocusNode _currentFocus;

  @override
  void initState() {
    super.initState();

    _categoryController.addListener(() => setState(() {}));
    _nameController.addListener(() => setState(() {}));
    _latController.addListener(() => setState(() {}));
    _lonController.addListener(() => setState(() {}));
    _detailsController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _nameController.dispose();
    _latController.dispose();
    _lonController.dispose();
    _detailsController.dispose();

    _categoryFocus.dispose();
    _nameFocus.dispose();
    _latFocus.dispose();
    _lonFocus.dispose();
    _detailsFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedCategory == null) {
      _categoryController.text = _emptyCategory;
    } else {
      _categoryController.text = _selectedCategory;

      /// если все поля что-то содержат, то кнопка активна
      if (_nameController.text.isNotEmpty &&
          _latController.text.isNotEmpty &&
          _lonController.text.isNotEmpty &&
          _detailsController.text.isNotEmpty) {
        _isButtonEnabled = true;
      }
    }

    if (_isButtonEnabled) {
      _submitForm = () {
        final isValid = _formKey.currentState.validate();

        if (isValid) {
          _formKey.currentState.save();

          /// подтверждаем сохранение данных
          _showDialog(
            category: _selectedCategory,
            name: _name,
            lat: _lat,
            lon: _lon,
            details: _details,
          );
        }
      };
    }

    return Scaffold(
      appBar: _buildAddSightAppBar(),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: GestureDetector(
                onTap: () {
                  if (_currentFocus != null) {
                    _currentFocus.unfocus();
                    _currentFocus = null;
                  }
                },
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
          )
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
      const Text('КАТЕГОРИЯ'),
      sizedBoxH12,
      TextFormField(
        focusNode: _categoryFocus,
        autofocus: true,
        controller: _categoryController,
        showCursor: false,
        maxLines: 1,
        style: _selectedCategory == null
            ? Theme.of(context)
                .primaryTextTheme
                .subtitle1
                .copyWith(color: Theme.of(context).colorScheme.inactiveBlack)
            : Theme.of(context).primaryTextTheme.subtitle1,
        readOnly: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(0, 10, 16, 10),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.inactiveBlack,
              width: 1,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.inactiveBlack,
              style: BorderStyle.solid,
              width: 1,
            ),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).errorColor.withOpacity(0.4),
              style: BorderStyle.solid,
              width: 2,
            ),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).errorColor.withOpacity(0.4),
              style: BorderStyle.solid,
              width: 2,
            ),
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: IconSvg(
              icon: icView,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        validator: _validateCategory,
        onSaved: (value) => setState(() => _selectedCategory = value),
        onTap: () {
          _returnCategoryFromSelectCategoryScreen(context);
        },
      ),
    ];
  }

  /// получаем выбранную категорию из экрана с категориями
  void _returnCategoryFromSelectCategoryScreen(BuildContext context) async {
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
      const Text('НАЗВАНИЕ'),
      sizedBoxH12,
      TextFormField(
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
        maxLength: 100,
        maxLines: 1,
        textInputAction: TextInputAction.next,
        style: Theme.of(context).primaryTextTheme.subtitle1,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          counterText: '',
          suffixIcon: _clearField(
              context: context,
              currentFocus: _nameFocus,
              controller: _nameController),
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(100),
        ],
        validator: _validateName,
        onSaved: (value) => setState(() => _name = value),
      ),
    ];
  }

  /// поле Широта
  Widget _buildLat() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ШИРОТА'),
          sizedBoxH12,
          TextFormField(
            focusNode: _latFocus,
            autofocus: true,
            onFieldSubmitted: (_) {
              _fieldFocusChange(context, _latFocus, _lonFocus);
            },
            onTap: () {
              setState(() {
                _currentFocus = _latFocus;
              });
            },
            controller: _latController,
            cursorHeight: 24,
            maxLength: 50,
            maxLines: 1,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            style: Theme.of(context).primaryTextTheme.subtitle1,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              counterText: '',
              suffixIcon: _clearField(
                  context: context,
                  currentFocus: _latFocus,
                  controller: _latController),
            ),
            validator: _validateCoordinates,
            onSaved: (value) => setState(() => _lat = double.tryParse(value)),
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
          const Text('ДОЛГОТА'),
          sizedBoxH12,
          TextFormField(
            focusNode: _lonFocus,
            autofocus: true,
            onFieldSubmitted: (_) {
              _fieldFocusChange(context, _lonFocus, _detailsFocus);
            },
            onTap: () {
              setState(() {
                _currentFocus = _lonFocus;
              });
            },
            controller: _lonController,
            cursorHeight: 24,
            maxLength: 50,
            maxLines: 1,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            style: Theme.of(context).primaryTextTheme.subtitle1,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              counterText: '',
              suffixIcon: _clearField(
                  context: context,
                  currentFocus: _lonFocus,
                  controller: _lonController),
            ),
            validator: _validateCoordinates,
            onSaved: (value) => setState(() => _lon = double.tryParse(value)),
          ),
        ],
      ),
    );
  }

  /// кнопка Указать на карте
  Widget _buildButtonShowOnMap() => ButtonText(
        title: 'Указать на карте',
        onPressed: () {
          print('onPressed: Указать на карте');
        },
      );

  /// поле Описание
  List<Widget> _buildDetails() {
    return [
      const Text('ОПИСАНИЕ'),
      sizedBoxH12,
      TextFormField(
        focusNode: _detailsFocus,
        autofocus: true,
        onEditingComplete: () {
          _detailsFocus.unfocus();
          _currentFocus = null;
        },
        onTap: () {
          setState(() {
            _currentFocus = _detailsFocus;
          });
        },
        controller: _detailsController,
        cursorHeight: 24,
        maxLength: 300,
        maxLines: 3,
        textInputAction: TextInputAction.done,
        style: Theme.of(context).primaryTextTheme.subtitle1,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          counterText: '',
          hintText: 'введите текст',
          hintStyle: Theme.of(context)
              .primaryTextTheme
              .subtitle1
              .copyWith(color: Theme.of(context).colorScheme.inactiveBlack),
          suffixIcon: _clearField(
              context: context,
              currentFocus: _detailsFocus,
              controller: _detailsController),
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(300),
        ],
        validator: _validateDetails,
        onSaved: (value) => setState(() => _details = value),
      ),
    ];
  }

  /// валидация полей
  String _validateCategory(String value) {
    if (value.isEmpty || value == _emptyCategory) return _errorEmptyCategory;

    return null;
  }

  String _validateName(String value) {
    final _nameExp = _namePattern;
    if (value.isEmpty) return _errorEmptyName;
    if (value.length < 5) return _errorShortName;
    if (!_nameExp.hasMatch(value)) return _errorIncorrectName;

    return null;
  }

  String _validateCoordinates(String value) {
    final _coordinatesExp = _coordinatesPattern;
    if (value.isEmpty) return _errorEmptyCoordinates;
    if (!_coordinatesExp.hasMatch(value)) return _errorIncorrectCoordinates;

    return null;
  }

  String _validateDetails(String value) {
    if (value.isEmpty) return _errorEmptyDetails;
    if (value.length < 100) return _errorShortDetails;

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
      {@required BuildContext context,
      @required FocusNode currentFocus,
      @required TextEditingController controller}) {
    if (currentFocus == _currentFocus && controller.text.isNotEmpty) {
      return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
        child: SizedBox(
          width: 24,
          height: 24,
          child: Ink(
            decoration: ShapeDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: CircleBorder(),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
                size: 16,
              ),
              onPressed: () {
                controller.clear();
              },
            ),
          ),
        ),
      );
    }

    return const SizedBox(width: 0);
  }

  /// показываем окно если форма валидна
  void _showDialog(
      {String category, String name, double lat, double lon, String details}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusCard),
            ),
            title: Text(
              'Данные сохранены',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Theme.of(context).accentColor),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  category,
                  style: Theme.of(context).primaryTextTheme.subtitle1,
                ),
                sizedBoxH12,
                Text(
                  name,
                  style: Theme.of(context).primaryTextTheme.subtitle1,
                ),
                Text(
                  '${details.substring(0, 100)} ...',
                  style: Theme.of(context).primaryTextTheme.subtitle1,
                ),
                sizedBoxH12,
                Text(
                  'Широта:\n$lat',
                  style: Theme.of(context).primaryTextTheme.bodyText2,
                ),
                Text(
                  'Долгота:\n$lon',
                  style: Theme.of(context).primaryTextTheme.bodyText2,
                ),
              ],
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  /// получаем id последнего элемента в массиве
                  final int _newId = mocks.last.id + 1;

                  /// временно
                  const _imgPreview =
                      'https://img1.fonwall.ru/o/dg/coast-beach-sand-ocean.jpeg';

                  /// сюда сохраним данные полей
                  Sight newSight = Sight(
                    id: _newId,
                    type: category,
                    name: name,
                    lat: lat,
                    lon: lon,
                    details: details,
                    imgPreview: _imgPreview,
                  );

                  /// и потом добавим в общий список
                  mocks.add(newSight);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SightListScreen(),
                    ),
                  );
                },
                child: Text(
                  'Ok',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Theme.of(context).accentColor),
                ),
                splashColor: Theme.of(context).accentColor.withOpacity(0.05),
              ),
            ],
          );
        });
  }
}
