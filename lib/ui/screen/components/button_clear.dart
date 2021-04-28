import 'package:flutter/material.dart';
import 'package:places/ui/screen/res/sizes.dart';

/// кнопка очистки поля
/// [onStartNewSearch] меняет состояние экрана на стартовое для нового поиска
/// запускает [GetSearchHistoryAction] в search_reducer
class ButtonClear extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onStartNewSearch;

  ButtonClear({
    Key? key,
    required this.controller, this.onStartNewSearch,
  })  : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            splashRadius: splashRadiusSmall,
            onPressed: () {
              controller.clear();
              if (onStartNewSearch != null) {
                onStartNewSearch!();
              }
            },
          ),
        ),
      ),
    );
  }
}
