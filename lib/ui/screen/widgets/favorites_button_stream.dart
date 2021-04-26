import 'dart:async';

import 'package:flutter/material.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/ui/screen/components/icon_action_button.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:provider/provider.dart';

/// кнопка Избранное для карточки (маленькая)
/// переключает текущий статус места, вносит измения в базе данных
class FavoritesButtonStream extends StatefulWidget {
  final Place place;

  const FavoritesButtonStream({
    Key? key,
    required this.place,
  }) : super(key: key);

  @override
  _FavoritesButtonStreamState createState() => _FavoritesButtonStreamState();
}

class _FavoritesButtonStreamState extends State<FavoritesButtonStream> {
  var _isFavController = StreamController<bool>();

  /// текущий статус места
  late bool currentStatusPlaces;
  late final PlaceInteractor _placeInteractor;

  @override
  void initState() {
    currentStatusPlaces = widget.place.isFavorite;
    _placeInteractor = context.read<PlaceInteractor>();
    super.initState();
  }

  @override
  void dispose() {
    _isFavController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: _isFavController.stream,
        initialData: widget.place.isFavorite,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            /// отвечает за смену иконки
            final bool isFav = snapshot.data!;

            return IconActionButton(
              onPressed: () {
                currentStatusPlaces = !currentStatusPlaces;
                _isFavController.sink.add(currentStatusPlaces);
                print('onPressed Избранное $currentStatusPlaces');

                /// вносит изменения в базах данных
                _placeInteractor.toggleFavorites(Place.switchFavoriteStatus(
                    place: widget.place, isFav: currentStatusPlaces));
              },
              icon: isFav ? icFavoritesFull : icFavorites,
            );
          }

          return const SizedBox.shrink();
        });
  }
}
