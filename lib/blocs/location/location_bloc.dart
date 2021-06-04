import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:places/ui/res/strings.dart';

part 'location_event.dart';

part 'location_state.dart';

/// блок для определения геопозиции
class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription? _locationSubscription;

  LocationBloc() : super(LocationInitial());

  @override
  Stream<LocationState> mapEventToState(
    LocationEvent event,
  ) async* {
    if (event is LocationStarted) {
      yield LocationLoadInProgress();

      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        yield (LocationFailure(appLocationServiceNotEnabled));
        throw Exception(appLocationServiceNotEnabled);
      }

      permission = await Geolocator.checkPermission();

      /// если запрещено определение местоположения делаем запрос на разрешение
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          yield (LocationFailure(appLocationPermissionDenied));
          throw Exception(appLocationPermissionDenied);
        }
      }

      /// Доступ на определение местоложения запрещён навсегда
      if (permission == LocationPermission.deniedForever) {
        yield (LocationFailure(appLocationPermissionDeniedForever));
        throw Exception(appLocationPermissionDeniedForever);
      }

      if (event.isObserver) {
        _locationSubscription?.cancel();
        _locationSubscription = Geolocator.getPositionStream().listen(
          (Position position) => add(LocationChanged(position: position)),
        );
      } else {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        add(LocationChanged(position: position));
      }
    } else if (event is LocationChanged) {
      yield LocationLoadSuccess(position: event.position);
    }
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}
