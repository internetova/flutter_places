import 'package:flutter/material.dart';
import 'package:places/ui/screen/components/icon_svg.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/res/themes.dart';

/// вариант загрузки фото
class ImageUploadItem {
  final String icon;
  final String name;

  const ImageUploadItem({
    this.icon,
    this.name,
  });
}

/// список вариантов загрузки фотографий
const List<ImageUploadItem> _dataImageUploadItems = const [
  ImageUploadItem(icon: icCamera, name: imageUploadCamera),
  ImageUploadItem(icon: icPhoto, name: imageUploadPhoto),
  ImageUploadItem(icon: icFail, name: imageUploadFail),
];

/// список вариантов загрузки изображений для экрана добавления нового места
class ListOfImageUploadOptions extends StatelessWidget {
  final List<ImageUploadItem> data;

  const ListOfImageUploadOptions({
    Key key,
    this.data = _dataImageUploadItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return _ImageUploadItemWidget(
          icon: data[index].icon,
          name: data[index].name,
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 1.0,
        );
      },
    );
  }
}

/// виджет варианта загрузки фото
class _ImageUploadItemWidget extends StatelessWidget {
  final String icon;
  final String name;
  final VoidCallback onTap;

  const _ImageUploadItemWidget({
    Key key,
    @required this.icon,
    @required this.name,
    this.onTap,
  })  : assert(icon != null),
        assert(name != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 12,
      leading: IconSvg(
        icon: icon,
        color: _setColor(context),
      ),
      title: Text(
        name,
        style: Theme.of(context).primaryTextTheme.subtitle1.copyWith(
              color: _setColor(context),
            ),
      ),
      onTap: onTap,
    );
  }

  /// цвет иконки и шрифта
  Color _setColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).colorScheme.secondary2
        : Theme.of(context).colorScheme.white;
  }
}
