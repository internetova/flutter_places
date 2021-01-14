import 'package:flutter/material.dart';
import 'package:places/ui/screen/components/button_save.dart';
import 'package:places/ui/screen/components/icon_leading_appbar.dart';
import 'package:places/ui/screen/components/icon_svg.dart';
import 'package:places/domain/categories.dart';
import 'package:places/mocks.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/strings.dart';

/// выбор категории -> из добавления нового места AddSightScreen
class SelectCategoryScreen extends StatefulWidget {
  final String selectedCategory;

  const SelectCategoryScreen({Key key, this.selectedCategory})
      : super(key: key);

  @override
  _SelectCategoryScreenState createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  /// кнопка сохранения при старте отключена
  bool _isButtonEnabled = false;
  VoidCallback _onPressed;

  /// категории
  List<Categories> _categories = categories;

  /// название выбранной категории
  String _selectedCategory;

  /// счётчик выбора категорий
  /// если он 0, то категория передаётся с предыдущего экрана
  /// иначе берем выбранную категорию на этом экране
  int _counterSelection = 0;

  @override
  Widget build(BuildContext context) {
    /// widget.selectedCategory передаём в конструктор из формы предыдущего экрана
    /// по логике там либо null либо выбранная категория из этого экрана
    /// если категория уже выбрана то кнопка для сохранения сразу активна
    /// _counterSelection == 0 - ещё не выбирали другую категорию
    if (widget.selectedCategory != null && _counterSelection == 0) {
      _isButtonEnabled = true;
      _selectedCategory = widget.selectedCategory;
    }

    if (_isButtonEnabled) {
      /// сохраняем выбранную категорию и передаём ее на предыдущий экран
      _onPressed = () {
        Navigator.pop(context, _selectedCategory);
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,
    );
  }

  /// AppBar
  Widget _buildSelectCategoryAppBar() => AppBar(
        toolbarHeight: toolbarHeightStandard,
        leading: SmallLeadingIcon(
          icon: icArrow,
          onPressed: _back,
        ),
        leadingWidth: 64,
        title: Text(
          titleAppBarSelectCategoryScreen,
        ),
        centerTitle: true,
      );

  /// категории
  _buildCategories() => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              for (var i = 0; i < _categories.length; i++) ...[
                _buildCategoryItem(
                    categoryItem: _categories[i],
                    selectedCategoryName: _selectedCategory),
                Divider(),
              ],
            ],
          ),
        ),
      );

  /// категория
  Widget _buildCategoryItem(
      {@required Categories categoryItem,
      @required String selectedCategoryName}) {
    final Widget title = Text(
      categoryItem.name,
      style: Theme.of(context).primaryTextTheme.subtitle1,
    );

    const padding = EdgeInsets.zero;

    /// сохраняем выбранную категорию
    /// делаем активной кнопку
    /// увеличиваем счетчик кликов по категориям (т.к. по нему опредеяем был
    /// ли выбор категории на этом экране)
    void myOnTap() {
      setState(() {
        _selectedCategory = categoryItem.name;
        _isButtonEnabled = true;
        _counterSelection++;
      });
    }

    if (categoryItem.name == selectedCategoryName) {
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

  /// вернуться на предыдущий экран без сохранения
  void _back() {
    Navigator.pop(context, widget.selectedCategory);
  }
}
