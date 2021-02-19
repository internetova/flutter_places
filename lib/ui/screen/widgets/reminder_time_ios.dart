import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/strings.dart';

/// действия на карточке
/// пикер времени IOS
class ReminderTimeIOSBottomSheet extends StatefulWidget {
  @override
  _ReminderTimeIOSBottomSheetState createState() =>
      _ReminderTimeIOSBottomSheetState();
}

class _ReminderTimeIOSBottomSheetState
    extends State<ReminderTimeIOSBottomSheet> {
  Duration _selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(radiusCard),
        ),
        color: Theme.of(context).primaryColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: CupertinoTimerPicker(onTimerDurationChanged: (value) {
              _selected = value;
            }),
          ),
          sizedBoxH16,
          CupertinoButton(
              child: Text(cupertinoPickerSelect.toUpperCase()),
              onPressed: () {
                Navigator.of(context).pop(_selected);
              })
        ],
      ),
    );
  }
}
