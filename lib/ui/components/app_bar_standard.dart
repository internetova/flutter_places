import 'package:flutter/material.dart';
import 'package:places/ui/components/icon_leading_appbar.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/sizes.dart';

/// стандартный AppBar со стрелкой возврата
class AppBarStandard extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onPressedBack;

  const AppBarStandard({
    Key? key,
    required this.title,
    required this.onPressedBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: toolbarHeightStandard,
      leading: SmallLeadingIcon(
        icon: icArrow,
        onPressed: onPressedBack,
      ),
      leadingWidth: 64,
      title: Text(
        title,
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeightStandard);
}
