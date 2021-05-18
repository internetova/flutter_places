import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/data/model/place_type.dart';
import 'package:places/ui/screen/filters_screen.dart';
import 'package:places/ui/res/assets.dart';

/// айтем категории фильтра
/// [placeType] название места (категория)
/// [selectedCat] соотвтетствующая категории метка в отдельном
/// параллельном категориям списке (выбрано / не выбрано)
/// нажатие на категорию обрабатывается в главном родительском экране [FiltersScreen]
class FilterCategoryItem extends StatelessWidget {
  final PlaceType placeType;
  final Map<String, dynamic> selectedCat;
  final VoidCallback? onPressed;

  const FilterCategoryItem({
    Key? key,
    required this.placeType,
    required this.selectedCat,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          const SizedBox(
            width: 96,
            height: 92,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              width: 64,
              height: 64,
              child: Ink(
                decoration: ShapeDecoration(
                  color: Theme.of(context).accentColor.withOpacity(0.16),
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: SvgPicture.asset(
                    placeType.icon,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: onPressed,
                  splashColor: Theme.of(context).accentColor.withOpacity(0.5),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Text(
              placeType.name,
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.center,
            ),
          ),
          if (selectedCat['isSelected']) _ShowSelectedCat(),
        ],
      ),
    );
  }
}

/// метка на выбранных категориях
class _ShowSelectedCat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 46,
      right: 16,
      child: Stack(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: ShapeDecoration(
              shape: CircleBorder(),
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: SvgPicture.asset(
              icTick,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
