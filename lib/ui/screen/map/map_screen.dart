import 'dart:async';

import 'package:flutter/material.dart';
import 'package:places/blocs/location/location_bloc.dart';
import 'package:places/data/model/user_location.dart';
import 'package:places/ui/components/search_bar_static.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/sizes.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/screen/map/widgets/bottom_map_buttons.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// экран с яндекс картой
class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final UserLocation _userLocation;
  late final LocationBloc _locationBloc;

  /// для яндекс карты
  late final Point _point;
  final Completer<YandexMapController> _completer = Completer();

  @override
  void initState() {
    _locationBloc = context.read<LocationBloc>();

    if (_locationBloc.state is LocationLoadSuccess) {
      final _locationLoadSuccessState =
          _locationBloc.state as LocationLoadSuccess;

      _userLocation = UserLocation(
        lat: _locationLoadSuccessState.position.latitude,
        lng: _locationLoadSuccessState.position.longitude,
      );
    } else {
      _userLocation = defaultLocation;
    }

    _point = Point(
      latitude: _userLocation.lat,
      longitude: _userLocation.lng,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _BuildAppBar(),
      body: YandexMap(
        onMapCreated: _onMapCreated,
      ),
      floatingActionButton: BottomMapButtons(
        onPressedRefresh: _onPressedRefresh,
        onPressedGeolocation: _onPressedGeolocation,
        onPressedZoomIn: _onPressedZoomIn,
        onPressedZoomOut: _onPressedZoomOut,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  /// создаём карту, перемещаемся в точку локации
  void _onMapCreated(YandexMapController controller) {
    _completer.complete(controller);

    controller.move(
      point: Point(
        latitude: _userLocation.lat,
        longitude: _userLocation.lng,
      ),
    );
  }

  Future<void> _onPressedGeolocation() async {
    YandexMapController controller = await _completer.future;
    _locationBloc.add(LocationStarted());

    print('_point $_point');

    controller.showUserLayer(
      iconName: _getIconicIAmHere() ,
      arrowName: _getIconicIAmHere(),
      accuracyCircleFillColor: Theme.of(context).accentColor.withOpacity(0.3),
    );

    controller.move(point: _point);
  }

  /// файл (png) иконки в зависимости от темы
  String _getIconicIAmHere() {
    return Theme.of(context).brightness == Brightness.light
        ? icIAmHereWhite
        : icIAmHereBlack;
  }

  /// обновить данные
  void _onPressedRefresh() {
    print('_onPressedRefresh');
  }

  /// увеличить масштаб
  Future<void> _onPressedZoomIn() async {
    YandexMapController controller = await _completer.future;
    controller.zoomIn();
  }

  /// уменьшить масштаб
  Future<void> _onPressedZoomOut() async {
    YandexMapController controller = await _completer.future;
    controller.zoomOut();
  }
}

/// AppBar
class _BuildAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                mapAppBarTitle,
                style: Theme.of(context).textTheme.headline6,
              ),
              sizedBoxH24,
              SearchBarStatic(
                onTapSearch: () {},
                onPressedFilter: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// вернуться на предыдущий экран
  void _back(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Size get preferredSize => Size.fromHeight(132);
}
