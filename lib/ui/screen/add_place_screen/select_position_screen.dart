import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/blocs/add_place_screen/select_position/select_place_position_cubit.dart';
import 'package:places/blocs/settings_app/settings_app_cubit.dart';
import 'package:places/data/model/object_position.dart';
import 'package:places/ui/components/app_bar_standard.dart';
import 'package:places/ui/components/button_save.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/sizes.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/utilities/ui_utils.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

/// экран указания позиции места на карте
class SelectPositionScreen extends StatefulWidget {
  final ObjectPosition userPosition;
  final ObjectPosition? placePosition;

  const SelectPositionScreen(
      {Key? key, required this.userPosition, this.placePosition})
      : super(key: key);

  @override
  _SelectPositionScreenState createState() => _SelectPositionScreenState();
}

class _SelectPositionScreenState extends State<SelectPositionScreen> {
  YandexMapController? controller;
  ObjectPosition? _placePosition;

  /// предыдущая и последняя выбранные отметки на карте - для удаления
  /// предыдущего маркера
  final List<Placemark> _newPlacemark = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectPlacePositionCubit, SelectPlacePositionState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBarStandard(
            title: titleAppBarSelectPositionScreen,
            onPressedBack: _back,
          ),
          body: YandexMap(
            onMapCreated: _onMapCreated,
            onMapTap: (Point point) {
              _onTapMap(controller!, point);
            },
          ),
          floatingActionButton: AnimatedSwitcher(
            duration: milliseconds300,
            child: ButtonSave(
              key: ValueKey(state),
              title: titleButtonSave,
              isButtonEnabled: state.isButtonEnabled,
              onPressed: state.isButtonEnabled ? _onPressedSave : null,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          resizeToAvoidBottomInset: false,
        );
      },
    );
  }

  /// создаём карту
  Future<void> _onMapCreated(YandexMapController yandexMapController) async {
    controller = yandexMapController;

    /// логотип яндекса
    await controller!.logoAlignment(
      horizontal: HorizontalAlignment.left,
      vertical: VerticalAlignment.top,
    );

    /// тема карты
    await controller!.toggleNightMode(
        enabled: context.read<SettingsAppCubit>().state.isDark);

    /// стиль карты
    await controller!.setMapStyle(
        style: context.read<SettingsAppCubit>().state.isDark
            ? mapDarkStyle
            : mapLightStyle);

    if (widget.placePosition != null) {
      _loadPlacemark(controller!, placePosition: widget.placePosition!);

      /// переместиться к месту
      await controller!.move(
        point: Point(
          latitude: widget.placePosition!.lat,
          longitude: widget.placePosition!.lng,
        ),
      );
    } else {
      /// показать где юзер
      await controller!.showUserLayer(
        iconName: UiUtils.setIconForTheme(context,
            light: icUserHereLight, dark: icUserHereDark),
        arrowName: UiUtils.setIconForTheme(context,
            light: icUserHereLight, dark: icUserHereDark),
        accuracyCircleFillColor: Theme.of(context).accentColor.withOpacity(0.5),
      );

      /// переместиться в точку локации юзера
      await controller!.move(
        point: Point(
          latitude: widget.userPosition.lat,
          longitude: widget.userPosition.lng,
        ),
      );

      await controller!.zoomOut();
    }
  }

  /// загружаем метку если передали позицию места из полей формы
  Future<void> _loadPlacemark(
    YandexMapController controller, {
    required ObjectPosition placePosition,
  }) async {
    final Placemark _selectedPlace = Placemark(
      point: Point(latitude: placePosition.lat, longitude: placePosition.lng),
      style: PlacemarkStyle(
        iconName: UiUtils.setIconForTheme(context,
            light: icPlaceMarkActiveLight, dark: icPlaceMarkActiveDark),
        scale: 1.5,
        opacity: 1,
      ),
    );

    controller.addPlacemark(_selectedPlace);
    _newPlacemark.add(_selectedPlace);

    _placePosition = placePosition;
    context.read<SelectPlacePositionCubit>().setPosition(_placePosition!);
  }

  /// ставим новую метку по тапу на карте
  Future<void> _onTapMap(YandexMapController controller, Point point) async {
    if (_newPlacemark.isNotEmpty) {
      controller.removePlacemark(_newPlacemark.first);
      _newPlacemark.clear();
    }

    final Placemark _selectedPlacemark = Placemark(
      point: point,
      style: PlacemarkStyle(
        iconName: UiUtils.setIconForTheme(context,
            light: icPlaceMarkActiveLight, dark: icPlaceMarkActiveDark),
        scale: 1.5,
        opacity: 1,
      ),
    );

    controller.addPlacemark(_selectedPlacemark);

    _placePosition = ObjectPosition(lat: point.latitude, lng: point.longitude);
    context.read<SelectPlacePositionCubit>().setPosition(_placePosition!);

    _newPlacemark.add(_selectedPlacemark);
  }

  /// сохранить выбранную позицю
  void _onPressedSave() {
    Navigator.of(context).pop(_placePosition);
  }

  /// вернуться на предыдущий экран без сохранения
  void _back() {
    Navigator.of(context).pop(widget.placePosition);
  }
}
