import 'package:flutter/material.dart';
import 'package:places/ui/screen/res/sizes.dart';

/// текстовая кнопка сливающаяся с фоном
/// на экране добавления нового места - Указать на карте
class ButtonText extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const ButtonText({
    Key? key,
    required this.title,
    this.onPressed,
  })  : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size(double.infinity, heightBigButton),
        alignment: Alignment.centerLeft,
      ),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headline5!
            .copyWith(color: Theme.of(context).accentColor),
      ),
    );
  }
}
