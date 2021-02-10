import 'package:flutter/material.dart';
import 'package:places/ui/screen/res/themes.dart';

/// текстовый leading для appBar - Отмена экран Новое место
class TitleLeadingAppBar extends StatelessWidget {
  final String title;

  const TitleLeadingAppBar({Key key, @required this.title})
      : assert(title != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headline5
            .copyWith(color: Theme.of(context).colorScheme.secondary2),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
