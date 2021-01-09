import 'package:flutter/material.dart';

/// кнопка очистки поля
/// [data] - поле для строки поиска, туда записываем текущий запрос.
class ButtonClear extends StatelessWidget {
  const ButtonClear({Key key, @required this.controller, this.data})
      : super(key: key);

  final TextEditingController controller;
  final List<String> data;

  @override
  Widget build(BuildContext context) {
    List<String> _data = data;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
      child: SizedBox(
        width: 24,
        height: 24,
        child: Ink(
          decoration: ShapeDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: CircleBorder(),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.close,
              color: Theme.of(context).primaryColor,
              size: 16,
            ),
            onPressed: () {
              controller.clear();
              if (data != null && _data.length > 0) {
                _data.clear();
              }
            },
          ),
        ),
      ),
    );
  }
}
