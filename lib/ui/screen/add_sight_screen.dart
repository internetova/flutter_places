import 'package:flutter/material.dart';
import 'package:places/components/button_save.dart';
import 'package:places/components/button_text.dart';
import 'package:places/components/icon_svg.dart';
import 'package:places/components/title_leading_appbar.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/res/themes.dart';
import 'package:places/ui/screen/select_category_screen.dart';

/// добавление нового места
class AddSightScreen extends StatefulWidget {
  @override
  _AddSightScreenState createState() => _AddSightScreenState();
}

class _AddSightScreenState extends State<AddSightScreen> {
  /// кнопка сохранения при старте отключена
  bool _isButtonEnabled = false;
  VoidCallback _onPressed;

  /// сюда запишем данные из формы
  String _selectedCategory;
  String _title;
  String _latitude;
  String _longitude;
  String _description;

  final _categoryController = TextEditingController();
  final _titleController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (_selectedCategory == null) {
      _categoryController.text = 'Не выбрано';
    } else {
      _categoryController.text = _selectedCategory;
    }

    // _categoryController.text = _selectedCategory;

    return Scaffold(
      appBar: _buildAddSightAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('КАТЕГОРИЯ'),
              sizedBoxH12,
              _buildCategory(),
              sizedBoxH24,
              const Text('НАЗВАНИЕ'),
              sizedBoxH12,
              _buildTitle(),
              sizedBoxH24,
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('ШИРОТА'),
                        sizedBoxH12,
                        _buildLatitude(),
                      ],
                    ),
                  ),
                  sizedBoxW16,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('ДОЛГОТА'),
                        sizedBoxH12,
                        _buildLongitude(),
                      ],
                    ),
                  )
                ],
              ),
              ButtonText(
                title: 'Указать на карте',
                onPressed: () {
                  print('onPressed: Указать на карте');
                },
              ),
              sizedBoxH12,
              const Text('ОПИСАНИЕ'),
              sizedBoxH12,
              _buildDescription(),
            ],
          ),
        ),
      ),
      floatingActionButton: ButtonSave(
        title: titleButtonSaveAddSightScreen,
        isButtonEnabled: _isButtonEnabled,
        onPressed: _onPressed,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _buildAddSightAppBar() => AppBar(
        toolbarHeight: toolbarHeightStandard,
        leadingWidth: 80,
        leading: TitleLeadingAppBar(
          title: leadingAppBarAddSightScreen,
        ),
        title: Text(
          titleAppBarAddSightScreen,
        ),
        centerTitle: true,
      );

  _buildCategory() {
    return TextFormField(
      controller: _categoryController,
      showCursor: false,
      maxLines: 1,
      style: Theme.of(context).primaryTextTheme.subtitle1,
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
            width: 1,
          ),
        ),
        suffixIcon: IconButton(
          icon: IconSvg(
            icon: icView,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            _returnCategoryFromSelectCategoryScreen(context);
          },
          splashRadius: 20,
        ),
      ),
    );
  }

  /// получаем выбранную категорию из экрана с категориями
  void _returnCategoryFromSelectCategoryScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SelectCategoryScreen(
              selectedCategory: _selectedCategory)),
    );
    setState(() {
      _selectedCategory = result;
    });
  }

  _buildTitle() {
    return TextFormField(
      controller: _titleController,
      cursorHeight: 24,
      maxLength: 50,
      maxLines: 1,
      style: Theme.of(context).primaryTextTheme.subtitle1,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        counterText: '',
        suffixIcon: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.red,
          ),
          onPressed: () {
            _titleController.clear();
          },
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusInput),
          borderSide: BorderSide(
            color: Theme.of(context).accentColor.withOpacity(0.4),
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusInput),
          borderSide: BorderSide(
            color: Theme.of(context).accentColor.withOpacity(0.4),
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
      ),
    );
  }

  _buildLatitude() {
    return TextFormField(
      controller: _latitudeController,
      cursorHeight: 24,
      maxLength: 50,
      maxLines: 1,
      style: Theme.of(context).primaryTextTheme.subtitle1,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        counterText: '',
        suffixIcon: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.red,
          ),
          onPressed: () {
            _latitudeController.clear();
          },
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusInput),
          borderSide: BorderSide(
            color: Theme.of(context).accentColor.withOpacity(0.4),
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusInput),
          borderSide: BorderSide(
            color: Theme.of(context).accentColor.withOpacity(0.4),
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
      ),
    );
  }

  _buildLongitude() {
    return TextFormField(
      controller: _longitudeController,
      cursorHeight: 24,
      maxLength: 50,
      maxLines: 1,
      style: Theme.of(context).primaryTextTheme.subtitle1,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        counterText: '',
        suffixIcon: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.red,
          ),
          onPressed: () {
            _longitudeController.clear();
          },
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusInput),
          borderSide: BorderSide(
            color: Theme.of(context).accentColor.withOpacity(0.4),
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusInput),
          borderSide: BorderSide(
            color: Theme.of(context).accentColor.withOpacity(0.4),
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
      ),
    );
  }

  _buildDescription() {
    return TextFormField(
      controller: _descriptionController,
      cursorHeight: 24,
      maxLength: 300,
      maxLines: 3,
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
        suffixIcon: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.red,
          ),
          onPressed: () {
            _descriptionController.clear();
          },
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusInput),
          borderSide: BorderSide(
            color: Theme.of(context).accentColor.withOpacity(0.4),
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusInput),
          borderSide: BorderSide(
            color: Theme.of(context).accentColor.withOpacity(0.4),
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
      ),
    );
  }
}
