import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// иконка для аппбара leading
Widget buildLeadingIcon(BuildContext context, {@required String icon}) {
  return Container(
    padding: EdgeInsets.only(left: 20, right: 20),
    child: SvgPicture.asset(
      icon,
      color: Theme.of(context).colorScheme.onPrimary,
      width: 24,
      height: 24,
    ),
  );
}
