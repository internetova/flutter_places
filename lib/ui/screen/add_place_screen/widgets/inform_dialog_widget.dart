import 'package:flutter/material.dart';
import 'package:places/ui/res/app_routes.dart';
import 'package:places/ui/res/sizes.dart';
import 'package:places/ui/res/strings.dart';

/// после добавления нового места показываем диалог с подтверждением
class InformDialogWidget extends StatelessWidget {
  final String category;
  final String name;
  final double lat;
  final double lng;
  final String description;

  const InformDialogWidget({
    Key? key,
    required this.category,
    required this.name,
    required this.lat,
    required this.lng,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusCard),
      ),
      title: Text(
        addNewSightAlertDialogHeader,
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(color: Theme.of(context).accentColor),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            category,
            style: Theme.of(context).primaryTextTheme.subtitle1,
          ),
          sizedBoxH12,
          Text(
            name,
            style: Theme.of(context).primaryTextTheme.subtitle1,
          ),
          Text(
            '${description.substring(0, 100)} ...',
            style: Theme.of(context).primaryTextTheme.subtitle1,
          ),
          sizedBoxH12,
          Text(
            '$addNewSightAlertDialogLat$lat',
            style: Theme.of(context).primaryTextTheme.bodyText2,
          ),
          Text(
            '$addNewSightAlertDialogLon$lng',
            style: Theme.of(context).primaryTextTheme.bodyText2,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(AppRoutes.home);
          },
          child: Text(
            addNewSightAlertDialogSubmit,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Theme.of(context).accentColor),
          ),
        ),
      ],
    );
  }
}
