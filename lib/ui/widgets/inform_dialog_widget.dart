import 'package:flutter/material.dart';
import 'package:places/ui/res/sizes.dart';

enum InformDialogType { inform, error }

/// диалог при работе с событиями
class InformDialogWidget extends StatelessWidget {
  final String header;
  final String text;
  final String buttonTitle;
  final InformDialogType informDialogType;
  final VoidCallback onPressed;

  const InformDialogWidget({
    Key? key,
    required this.onPressed,
    required this.header,
    required this.text,
    required this.informDialogType,
    this.buttonTitle = 'Ок',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color dialogColor = informDialogType == InformDialogType.error
        ? Theme.of(context).errorColor
        : Theme.of(context).accentColor;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusCard),
      ),
      title: Column(
        children: [
          Text(
            header,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: dialogColor),
          ),
          sizedBoxH12,
          Text(
            text,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onPressed,
          child: Text(
            buttonTitle,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: dialogColor),
          ),
        ),
      ],
    );
  }
}
