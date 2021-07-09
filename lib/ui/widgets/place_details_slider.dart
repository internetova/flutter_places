import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/blocs/place_details_screen/details_slider/details_slider_cubit.dart';
import 'package:places/data/model/card_type.dart';
import 'package:places/ui/components/button_rounded.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/sizes.dart';

/// где показывать - на скрине или боттомшите
enum WhereShowSlider { screen, bottomSheet }

/// слайдер фотографий
/// [cardType] - для формирования тега Hero
class PlaceDetailsSlider extends StatelessWidget {
  final List<String> images;
  final WhereShowSlider whereShowSlider;
  final CardType cardType;

  const PlaceDetailsSlider({
    Key? key,
    required this.images,
    required this.whereShowSlider,
    required this.cardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsSliderCubit, DetailsSliderState>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Hero(
              tag: cardType == CardType.search
                  ? 'fromSearch${images.first}'
                  : 'fromFavorites${images.first}',
              child: Stack(
                children: [
                  _ListSliderItems(
                    images: images,
                  ),
                  Positioned(
                    bottom: 0,
                    child: ConstrainedBox(
                      constraints: BoxConstraints.tight(
                        Size(constraints.maxWidth, 8.0),
                      ),
                      child: _ProgressIndicatorImages(
                        data: images,
                        currentIndex: state.currentPage,
                      ),
                    ),
                  ),
                  if (whereShowSlider == WhereShowSlider.screen)
                    Positioned(
                      top: 16,
                      left: 16,
                      child: _ButtonBack(),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

/// кнопка Назад при показе на отдельном скрине
class _ButtonBack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ButtonRounded(
      size: 32,
      radius: radiusButtonSmall,
      backgroundColor: Theme.of(context).primaryColor,
      icon: icArrow,
      iconColor: Theme.of(context).colorScheme.onPrimary,
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}

/// индикатор просмотра фотографий
class _ProgressIndicatorImages extends StatelessWidget {
  final List<String> data;
  final int currentIndex;

  const _ProgressIndicatorImages({
    Key? key,
    required this.data,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: data
          .asMap()
          .map(
            (i, element) => MapEntry(
              i,
              Expanded(
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: _getColor(
                      context,
                      index: i,
                      currentIndex: currentIndex,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          )
          .values
          .toList(),
    );
  }

  /// цвет индикатора просмотренных фотографий
  Color _getColor(BuildContext context,
      {required int index, required int currentIndex}) {
    if (index < currentIndex || index == currentIndex) {
      return Theme.of(context).colorScheme.primary;
    } else {
      return Colors.transparent;
    }
  }
}

/// элемент для слайдера
class _SliderItem extends StatelessWidget {
  final String url;

  const _SliderItem({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      frameBuilder: (
        BuildContext context,
        Widget child,
        int? frame,
        bool wasSynchronouslyLoaded,
      ) {
        if (wasSynchronouslyLoaded) {
          return child;
        }
        return AnimatedOpacity(
          child: child,
          opacity: frame == null ? 0 : 1,
          duration: milliseconds1500,
          curve: Curves.easeOut,
        );
      },
    );
  }
}

class _ListSliderItems extends StatelessWidget {
  final List<String> images;
  final PageController _controller = PageController(initialPage: 0);

  _ListSliderItems({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      onPageChanged: (value) {
        context.read<DetailsSliderCubit>().changedPage(value);
      },
      controller: _controller,
      itemCount: images.length,
      itemBuilder: (BuildContext context, int index) {
        return _SliderItem(
          url: images[index],
        );
      },
    );
  }
}
