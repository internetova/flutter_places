import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:places/ui/components/button_clear.dart';
import 'package:places/ui/components/icon_svg.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/sizes.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/themes.dart';

/// виджет поисковой строки для экрана поиска
class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focus;
  final Function? onChanged;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;
  final VoidCallback? onStartNewSearch;

  const SearchBar({
    Key? key,
    required this.controller,
    this.onStartNewSearch,
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
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              hintStyle: Theme.of(context)
                  .primaryTextTheme
                  .subtitle1!
                  .copyWith(color: Theme.of(context).colorScheme.inactiveBlack),
            ),
          ),
          child: TextField(
            controller: controller,
            focusNode: focus,
            autofocus: true,
            cursorWidth: 1,
            textInputAction: TextInputAction.search,
            style: Theme.of(context).primaryTextTheme.subtitle1,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: InputBorder.none,
              hintText: searchHintText,
              counterText: '',
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: IconSvg(
                  icon: icSearch,
                  size: 24,
                  color: Theme.of(context).colorScheme.inactiveBlack,
                ),
              ),
              suffixIcon: controller.text.isNotEmpty
                  ? ButtonClear(
                      controller: controller,
                      onStartNewSearch: onStartNewSearch,
                    )
                  : const SizedBox(width: 0),
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(50),
              FilteringTextInputFormatter(RegExp(r'^[a-zа-яA-ZА-Я0-9 ]+$'),
                  allow: true)
            ],
            onChanged: onChanged as void Function(String)?,
            onEditingComplete: onEditingComplete,
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
