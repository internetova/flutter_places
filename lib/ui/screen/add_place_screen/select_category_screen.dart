import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/blocs/add_place_screen/select_category/select_category_cubit.dart';
import 'package:places/data/model/place_type.dart';
import 'package:places/ui/screen/components/button_save.dart';
import 'package:places/ui/screen/components/icon_leading_appbar.dart';
import 'package:places/ui/screen/components/icon_svg.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/strings.dart';

/// выбор категории -> из добавления нового места AddSightScreen
class SelectCategoryScreen extends StatefulWidget {
  final String? selectedCategory;

  const SelectCategoryScreen({Key? key, this.selectedCategory})
      : super(key: key);

  @override
  _SelectCategoryScreenState createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  /// категории
  List<PlaceType> _categories = PlaceType.getList;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectCategoryCubit, SelectCategoryState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _buildSelectCategoryAppBar() as PreferredSizeWidget?,
          body: _buildCategories(),
          floatingActionButton: AnimatedSwitcher(
            duration: milliseconds300,
            child: ButtonSave(
              key: ValueKey(state),
              title: titleButtonSaveSelectCategoryScreen,
              isButtonEnabled: state.isButtonEnabled,
              onPressed: state.isButtonEnabled ? _onPressedSave : null,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          resizeToAvoidBottomInset: false,
        );
      },
    );
  }

  void _onPressedSave () {
      Navigator.pop(context, context.read<SelectCategoryCubit>().state.selectedCategory);
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
  Widget _buildCategories() => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              for (var i = 0; i < _categories.length; i++) ...[
                _buildCategoryItem(
                  categoryItem: _categories[i],
                  selectedCategoryName: context
                      .read<SelectCategoryCubit>()
                      .state
                      .selectedCategory,
                ),
                Divider(),
              ],
            ],
          ),
        ),
      );

  /// категория
  Widget _buildCategoryItem(
      {required PlaceType categoryItem,
      required String? selectedCategoryName}) {
    final Widget title = Text(
      categoryItem.name,
      style: Theme.of(context).primaryTextTheme.subtitle1,
    );

    const padding = EdgeInsets.zero;

    /// выбор новой категории
    void _onSelect() {
      context.read<SelectCategoryCubit>().onTap(categoryItem.name);
    }

    if (categoryItem.name == selectedCategoryName) {
      return ListTile(
        title: title,
        trailing: IconSvg(
          icon: icTick,
          color: Theme.of(context).accentColor,
        ),
        contentPadding: padding,
        onTap: _onSelect,
      );
    } else {
      return ListTile(
        title: title,
        contentPadding: padding,
        onTap: _onSelect,
      );
    }
  }

  /// вернуться на предыдущий экран без сохранения
  void _back() {
    Navigator.pop(context, widget.selectedCategory);
  }
}
