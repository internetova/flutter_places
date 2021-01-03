import 'package:flutter/material.dart';
import 'package:places/components/button_save.dart';
import 'package:places/components/icon_leading_appbar.dart';
import 'package:places/components/icon_svg.dart';
import 'package:places/domain/categories.dart';
import 'package:places/mocks.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/res/themes.dart';

/// выбор категории -> из добавления нового места AddSightScreen
class SelectCategoryScreen extends StatefulWidget {
  @override
  _SelectCategoryScreenState createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  /// кнопка сохранения при старте отключена
  bool _isButtonEnabled = false;
  var _onPressed;

  /// категории
  List<Categories> _categories = categories;

  /// id выбранной категории
  int _selectedCategory;

  @override
  Widget build(BuildContext context) {
    if (_isButtonEnabled) {
      _onPressed = () {
        print('onPressed Сохранить');
      };
    }

    return Scaffold(
      appBar: _buildSelectCategoryAppBar(),
      body: _buildCategories(),
      floatingActionButton: ButtonSave(
        title: titleButtonSaveSelectCategoryScreen,
        isButtonEnabled: _isButtonEnabled,
        onPressed: _onPressed,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  /// AppBar
  Widget _buildSelectCategoryAppBar() => AppBar(
        toolbarHeight: 80,
        leading: SmallLeadingIcon(icon: icArrow),
        leadingWidth: 64,
        title: Text(
          titleAppBarSelectCategoryScreen,
        ),
        centerTitle: true,
      );

  /// категории
  _buildCategories() => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              for (var i = 0; i < _categories.length; i++) ...[
                _buildCategoryItem(
                    categoryItem: _categories[i],
                    selectedId: _selectedCategory),
                Divider(),
              ],
            ],
          ),
        ),
      );

  /// категория
  Widget _buildCategoryItem(
      {@required Categories categoryItem, @required int selectedId}) {
    final Widget title = Text(
      categoryItem.name,
      style: Theme.of(context).primaryTextTheme.subtitle1,
    );

    const padding = EdgeInsets.zero;

    void myOnTap() {
      setState(() {
        _selectedCategory = categoryItem.id;
        _isButtonEnabled = true;
      });
    }

    if (categoryItem.id == selectedId) {
      return ListTile(
        title: title,
        trailing: IconSvg(
          icon: icTick,
          color: Theme.of(context).accentColor,
        ),
        contentPadding: padding,
        onTap: myOnTap,
      );
    } else {
      return ListTile(
        title: title,
        contentPadding: padding,
        onTap: myOnTap,
      );
    }
  }
}
