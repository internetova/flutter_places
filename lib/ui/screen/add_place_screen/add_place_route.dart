import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/ui/screen/add_place_screen/add_place_screen.dart';
import 'package:provider/provider.dart';
import 'add_place_wm.dart';

/// при переходе на экран AddPlaceScreen создаём WM для экрана с помощью билдера
class AddPlaceScreenRoute extends MaterialPageRoute {
  AddPlaceScreenRoute()
      : super(
          builder: (context) => AddPlaceScreen(
            widgetModelBuilder: _widgetModelBuilder,
          ),
        );
}

/// билдер для WidgetModel
WidgetModel _widgetModelBuilder(BuildContext context) => AddPlaceWidgetModel(
      context.read<WidgetModelDependencies>(),
      placeInteractor: context.read<PlaceInteractor>(),
      navigator: Navigator.of(context),
    );
