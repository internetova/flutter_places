import 'dart:async';

import 'package:flutter/material.dart';
import 'package:places/blocs/location/location_bloc.dart';
import 'package:places/data/model/user_location.dart';
import 'package:places/ui/components/bottom_navigationbar.dart';
import 'package:places/ui/components/search_bar_static.dart';
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
  late UserLocation _userLocation;
  late final LocationBloc _locationBloc;
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
      bottomNavigationBar: const MainBottomNavigationBar(current: 1),
    );
  }

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

    print('_onPressedGeolocation');

    _locationBloc.add(LocationStarted());

    controller.move(
      point: Point(
        latitude: _userLocation.lat,
        longitude: _userLocation.lng,
        // latitude: defaultLocation.lat,
        // longitude: defaultLocation.lng,
      ),
    );
  }

  void _onPressedRefresh() {
    print('_onPressedRefresh');
  }

  Future<void> _onPressedZoomIn() async {
    YandexMapController controller = await _completer.future;
    controller.zoomIn();
  }

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
