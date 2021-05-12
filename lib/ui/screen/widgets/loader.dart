import 'package:flutter/material.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/sizes.dart';

enum LoaderSize { small, large }

/// лоадер маленький из дизайна
class Loader extends StatefulWidget {
  final LoaderSize loaderSize;

  const Loader({
    Key? key,
    required this.loaderSize,
  }) : super(key: key);

  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _rotateAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: milliseconds700,
    );

    _rotateAnimation = Tween<double>(
      begin: 0,
      end: -1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );

    _animationController.repeat();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _rotateAnimation,
      child: Center(
        child: _getLoaderImage(Theme.of(context).brightness),
      ),
    );
  }

  /// лоадер в зависимости от текущей темы
  Widget _getLoaderImage(Brightness brightness) {
    Widget loader;

    if (brightness == Brightness.light && widget.loaderSize == LoaderSize.small) {
      loader = Image.asset(icLoaderSmallWhite);
    } else if (brightness == Brightness.light && widget.loaderSize == LoaderSize.large) {
      loader = Image.asset(icLoaderLargeWhite);
    }  else if (brightness == Brightness.dark && widget.loaderSize == LoaderSize.small) {
      loader = Image.asset(icLoaderSmallBlack);
    } else {
      loader = Image.asset(icLoaderLargeBlack);
    }

    return loader;
  }
}
