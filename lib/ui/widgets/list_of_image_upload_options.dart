import 'package:flutter/material.dart';
import 'package:places/blocs/add_place_screen/user_images/user_images_cubit.dart';
import 'package:places/ui/components/icon_svg.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/widgets/choice_of_loading_images.dart';

/// список вариантов загрузки изображений для экрана добавления нового места
class ListOfImageUploadOptions extends StatelessWidget {
  final List<ImageUploadItem> data;
  final UserImagesCubit imagesCubit;

  const ListOfImageUploadOptions({
    Key? key,
    required this.data,
    required this.imagesCubit,
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
          onTap: () => imagesCubit.addImg(context, source: data[index].source),
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
    Key? key,
    required this.icon,
    required this.name,
    required this.onTap,
  }) : super(key: key);

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
        style: Theme.of(context).primaryTextTheme.subtitle1!.copyWith(
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
