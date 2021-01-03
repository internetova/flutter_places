import 'package:flutter/material.dart';
import 'package:places/components/button_save.dart';
import 'package:places/components/title_leading_appbar.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/res/themes.dart';

/// добавление нового места
class AddSightScreen extends StatefulWidget {
  @override
  _AddSightScreenState createState() => _AddSightScreenState();
}

class _AddSightScreenState extends State<AddSightScreen> {
  /// кнопка сохранения при старте отключена
  bool _isButtonEnabled = false;
  var _onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAddSightAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        ),
      ),
      floatingActionButton: ButtonSave(
        title: titleButtonSaveAddSightScreen,
        isButtonEnabled: _isButtonEnabled,
        onPressed: _onPressed,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildAddSightAppBar() => AppBar(
        toolbarHeight: 80,
        leadingWidth: 80,
        leading: TitleLeadingAppBar(
          title: leadingAppBarAddSightScreen,
        ),
        title: Text(
          titleAppBarAddSightScreen,
        ),
        centerTitle: true,
      );
}
