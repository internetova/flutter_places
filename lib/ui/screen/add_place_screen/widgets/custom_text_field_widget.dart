import 'package:flutter/material.dart';
import 'package:places/ui/screen/components/button_clear.dart';
import 'package:places/ui/screen/components/icon_svg.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/res/themes.dart';

/// ПОЛЯ для формы добавления нового места
///
/// текстовое поле формы добавления нового места
class CustomTextFieldWidget extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final ValueChanged? onFieldSubmitted; // переход к следующему полю
  final VoidCallback? onEditingComplete; // закончили редактировать поле
  final String? Function(String?)? validator;
  final ValueChanged<String?> onSaved; // сохранить если все поля валидны
  final int maxLength;
  final int maxLines;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? hintText;

  const CustomTextFieldWidget({
    Key? key,
    required this.focusNode,
    required this.controller,
    this.onFieldSubmitted,
    this.onEditingComplete,
    required this.validator,
    required this.onSaved,
    required this.maxLength,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.hintText,
  }) : super(key: key);

  @override
  _CustomTextFieldWidgetState createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller;
    _focusNode = widget.focusNode;

    /// следим за изменениями текстового поля и фокуса
    _controller.addListener(() => setState(() {}));
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: _focusNode,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onFieldSubmitted,
      controller: _controller,
      cursorHeight: 24,
      cursorWidth: 1,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      style: Theme.of(context).primaryTextTheme.subtitle1,
      decoration: InputDecoration(
        counterText: '',
        hintText: widget.hintText,
        hintStyle: Theme.of(context)
            .primaryTextTheme
            .subtitle1!
            .copyWith(color: Theme.of(context).colorScheme.inactiveBlack),
        suffixIcon: _clearField(
          focusNode: _focusNode,
          controller: _controller,
        ),
        enabledBorder: _buildBorderColor(_controller),
      ),
      validator: widget.validator,
      onSaved: widget.onSaved,
    );
  }

  /// очистка поля по кнопке
  Widget _clearField({
    required FocusNode focusNode,
    required TextEditingController controller,
  }) {
    if (focusNode.hasPrimaryFocus && controller.text.isNotEmpty) {
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
}

/// поле с нижним подчеркиванием для Категории
class CustomTextFieldUnderlineWidget extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final VoidCallback onTap;
  final String? Function(String?)? validator;
  final ValueChanged<String?> onSaved;

  const CustomTextFieldUnderlineWidget({
    Key? key,
    required this.focusNode,
    required this.controller,
    required this.onTap,
    required this.validator,
    required this.onSaved,
  }) : super(key: key);

  @override
  _CustomTextFieldUnderlineWidgetState createState() =>
      _CustomTextFieldUnderlineWidgetState();
}

class _CustomTextFieldUnderlineWidgetState
    extends State<CustomTextFieldUnderlineWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller;

    /// следим за изменениями текстового поля
    _controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          errorStyle: TextStyle(fontSize: 0),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: _controller.text != emptyCategory
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
              color:
                  Theme.of(context).colorScheme.inactiveBlack.withOpacity(0.24),
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
        focusNode: widget.focusNode,
        controller: _controller,
        showCursor: false,
        maxLines: 1,
        style: _controller.text == emptyCategory
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
        validator: widget.validator,
        onSaved: widget.onSaved,
        onTap: widget.onTap,
      ),
    );
  }
}