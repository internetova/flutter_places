import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:places/ui/screen/components/button_clear.dart';
import 'package:places/ui/screen/components/icon_svg.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/res/themes.dart';

/// виджет поисковой строки для экрана поиска
class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focus;
  final Function onChanged;
  final VoidCallback onEditingComplete;
  final VoidCallback onTap;
  final List<String> data;

  const SearchBar({
    Key key,
    this.controller,
    this.data,
    this.onChanged,
    this.onEditingComplete,
    this.onTap,
    this.focus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(radiusSearchInput),
      clipBehavior: Clip.antiAlias,
      color: Theme.of(context).primaryColorLight,
      child: SizedBox(
        height: heightInput,
        child: Theme(
          data: Theme.of(context).copyWith(
            inputDecorationTheme: InputDecorationTheme(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              hintStyle: Theme.of(context)
                  .primaryTextTheme
                  .subtitle1
                  .copyWith(color: Theme.of(context).colorScheme.inactiveBlack),
            ),
          ),
          child: TextField(
            controller: controller,
            focusNode: focus,
            autofocus: true,
            cursorHeight: 24,
            cursorWidth: 1,
            textInputAction: TextInputAction.search,
            style: Theme.of(context).primaryTextTheme.subtitle1,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: searchHintText,
              counterText: '',
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: IconSvg(
                  icon: icSearch,
                  width: 24,
                  height: 24,
                  color: Theme.of(context).colorScheme.inactiveBlack,
                ),
              ),
              suffixIcon: controller.text.isNotEmpty
                  ? ButtonClear(
                      controller: controller,
                    )
                  : const SizedBox(width: 0),
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(50),
              FilteringTextInputFormatter(RegExp(r'^[a-zа-яA-ZА-Я0-9 ]+$'),
                  allow: true)
            ],
            onChanged: onChanged,
            onEditingComplete: onEditingComplete,
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
