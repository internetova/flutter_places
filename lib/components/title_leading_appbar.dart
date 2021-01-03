import 'package:flutter/material.dart';
import 'package:places/ui/screen/res/themes.dart';

/// текстовый leading для appBar - Отмена экран Новое место
class TitleLeadingAppBar extends StatelessWidget {
  const TitleLeadingAppBar({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 30, bottom: 26),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headline5
            .copyWith(color: Theme.of(context).colorScheme.secondary2),
      ),
    );
  }
}
