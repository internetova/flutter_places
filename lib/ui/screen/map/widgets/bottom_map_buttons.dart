import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/blocs/map/selected_place/selected_place_cubit.dart';
import 'package:places/data/model/card_type.dart';
import 'package:places/data/model/place.dart';
import 'package:places/ui/components/button_rounded.dart';
import 'package:places/ui/components/button_gradient.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/sizes.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/screen/map/widgets/place_card_map.dart';
import 'package:places/ui/utilities/ui_utils.dart';

/// кнопки внизу карты - геопозиция, добавить новое место, обновить данные,
/// карточка выбранного места
class BottomMapButtons extends StatelessWidget {
  final VoidCallback onPressedRefresh;
  final VoidCallback onPressedGeolocation;
  final VoidCallback onPressedAddNewCard;
  final Place? place;

  const BottomMapButtons({
    Key? key,
    required this.onPressedRefresh,
    required this.onPressedGeolocation,
    this.place,
    required this.onPressedAddNewCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedPlaceCubit, SelectedPlaceState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                sizedBoxW16,
                ButtonRounded(
                  size: 50,
                  radius: 50,
                  backgroundColor: UiUtils.setColorForTheme(
                    context,
                    light: Theme.of(context).colorScheme.white,
                    dark: Theme.of(context).colorScheme.secondary,
                  ),
                  icon: icRefresh,
                  iconColor: Theme.of(context).colorScheme.primary,
                  elevation: 2,
                  onPressed: onPressedRefresh,
                ),
                Expanded(child: SizedBox.shrink()),
                if (state.place == null)
                  ButtonGradient(
                    isEnabled: true,
                    onPressed: onPressedAddNewCard,
                  ),
                Expanded(child: SizedBox.shrink()),
                ButtonRounded(
                  size: 50,
                  radius: 50,
                  backgroundColor: UiUtils.setColorForTheme(
                    context,
                    light: Theme.of(context).colorScheme.white,
                    dark: Theme.of(context).colorScheme.secondary,
                  ),
                  icon: icGeolocation,
                  iconColor: Theme.of(context).colorScheme.primary,
                  elevation: 2,
                  onPressed: onPressedGeolocation,
                ),
                sizedBoxW16,
              ],
            ),
            if (state.place != null)
              PlaceCardMap(
                place: state.place!,
                cardType: CardType.map,
              ),
          ],
        );
      },
    );
  }
}
