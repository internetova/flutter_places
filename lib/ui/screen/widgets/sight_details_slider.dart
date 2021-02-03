import 'package:flutter/material.dart';
import 'package:places/ui/screen/components/icon_svg.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/sizes.dart';

/// слайдер фотографий
class SightDetailsSlider extends StatefulWidget {
  final List<String> images;

  const SightDetailsSlider({
    Key key,
    @required this.images,
  })  : assert(images != null),
        super(key: key);

  /// для обновления индекса текущей фотографии из дочернего виджета
  static _SightDetailsSliderState of(BuildContext context) =>
      context.findAncestorStateOfType<_SightDetailsSliderState>();

  @override
  _SightDetailsSliderState createState() => _SightDetailsSliderState();
}

class _SightDetailsSliderState extends State<SightDetailsSlider> {
  /// индикатор просмотренных фотографий
  int _currentImage;

  @override
  void initState() {
    _currentImage = 0;

    super.initState();
  }

  void _updateState(int currentImage) {
    setState(() {
      _currentImage = currentImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            _ListSliderItems(
              images: widget.images,
            ),
            Positioned(
              bottom: 0,
              child: ConstrainedBox(
                constraints: BoxConstraints.tight(
                  Size(constraints.maxWidth, 8.0),
                ),
                child: _ProgressIndicatorImages(
                  data: widget.images,
                  currentIndex: _currentImage,
                ),
              ),
            ),
            Positioned(
              top: 36,
              left: 16,
              child: _ButtonBack(),
            ),
          ],
        );
      },
    );
  }
}

/// кнопка назад
class _ButtonBack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tight(
        Size(32.0, 32.0),
      ),
      child: FlatButton(
        padding: EdgeInsets.zero,
        color: Theme.of(context).primaryColor,
        height: heightBigButton,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: IconSvg(
          icon: icArrow,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

/// индикатор просмотра фотографий
class _ProgressIndicatorImages extends StatelessWidget {
  final List<String> data;
  final int currentIndex;

  const _ProgressIndicatorImages({
    Key key,
    @required this.data,
    @required this.currentIndex,
  })  : assert(data != null),
        assert(currentIndex != null),
        super(key: key);

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
  Color _getColor(BuildContext context, {int index, int currentIndex}) {
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

  const _SliderItem({Key key, @required this.url})
      : assert(url != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes
                : null,
          ),
        );
      },
    );
  }
}

class _ListSliderItems extends StatelessWidget {
  final List<String> images;
  final PageController _controller = PageController(initialPage: 0);

  _ListSliderItems({Key key, @required this.images})
      : assert(images != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      onPageChanged: (value) {
        SightDetailsSlider.of(context)._updateState(value);
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
