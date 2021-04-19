import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mwwm/mwwm.dart';
import 'package:places/ui/screen/add_place_screen/add_place_wm.dart';
import 'package:places/ui/screen/components/button_clear.dart';
import 'package:places/ui/screen/components/button_save.dart';
import 'package:places/ui/screen/components/button_text.dart';
import 'package:places/ui/screen/components/icon_svg.dart';
import 'package:places/ui/screen/components/title_leading_appbar.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/res/themes.dart';
import 'package:places/ui/screen/place_list_screen.dart';
import 'package:places/ui/screen/utilities/test_images_data.dart';
import 'package:places/ui/screen/widgets/choice_of_loading_images.dart';
import 'package:places/ui/screen/widgets/list_cards_with_added_img.dart';
import 'package:relation/relation.dart';

/// экран добавление нового места
class AddPlaceScreen extends CoreMwwmWidget {
  AddPlaceScreen({required WidgetModelBuilder widgetModelBuilder})
      : super(widgetModelBuilder: widgetModelBuilder);

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends WidgetState<AddPlaceWidgetModel> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAddSightAppBar() as PreferredSizeWidget?,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    StreamedStateBuilder<List<TestImage>>(
                        streamedState: wm.userListImgState,
                        builder: (context, userListImg) {
                          return ListCardsWithAddedImg(
                            data: userListImg!,
                            onAddImage: () {
                              wm.addImg();
                              _showImageLoadingWindow();
                            },
                            onRemoveImage: (int index) => wm.removeImg(index),
                          );
                        }),
                    sizedBoxH24,
                    ..._buildCategory(),
                    sizedBoxH24,
                    ..._buildName(),
                    sizedBoxH24,
                    Row(
                      children: [
                        _buildLat(),
                        sizedBoxW16,
                        _buildLon(),
                      ],
                    ),
                    _buildButtonShowOnMap(),
                    sizedBoxH12,
                    ..._buildDetails(),
                  ],
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: StreamedStateBuilder<bool>(
                  streamedState: wm.isButtonEnabledState,
                  builder: (context, isButtonEnabled) {
                    return ButtonSave(
                      title: titleButtonSaveAddSightScreen,
                      isButtonEnabled: isButtonEnabled!,
                      onPressed: isButtonEnabled ? _submitForm : null,
                    );
                  }),
            ),
          ),
        ],
      ),
      // resizeToAvoidBottomInset: false,
    );
  }

  /// AppBar
  Widget _buildAddSightAppBar() => AppBar(
        toolbarHeight: toolbarHeightStandard,
        leadingWidth: 100,
        leading: TitleLeadingAppBar(
          title: leadingAppBarAddSightScreen,
        ),
        title: Text(
          titleAppBarAddSightScreen,
        ),
        centerTitle: true,
      );

  /// Поле Категория
  List<Widget> _buildCategory() {
    return [
      Text(
        addNewSightLabelSelectedCategory,
        style: Theme.of(context)
            .textTheme
            .caption!
            .copyWith(color: Theme.of(context).colorScheme.inactiveBlack),
      ),
      sizedBoxH12,
      SizedBox(
        height: 48,
        child: Theme(
          data: ThemeData(
            inputDecorationTheme: InputDecorationTheme(
              errorStyle: TextStyle(fontSize: 0),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: wm.fieldCategory.controller.text != emptyCategory
                      ? Theme.of(context).accentColor.withOpacity(0.4)
                      : Theme.of(context)
                          .colorScheme
                          .inactiveBlack
                          .withOpacity(0.24),
                  width: 1,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context)
                      .colorScheme
                      .inactiveBlack
                      .withOpacity(0.24),
                  style: BorderStyle.solid,
                  width: 1,
                ),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).errorColor.withOpacity(0.4),
                  style: BorderStyle.solid,
                  width: 1,
                ),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).errorColor.withOpacity(0.4),
                  style: BorderStyle.solid,
                  width: 2,
                ),
              ),
            ),
          ),
          child: TextFormField(
            focusNode: wm.fieldCategoryFocus,
            autofocus: true,
            controller: wm.fieldCategory.controller,
            showCursor: false,
            maxLines: 1,
            style: wm.fieldCategory.controller.text == emptyCategory
                ? Theme.of(context)
                    .primaryTextTheme
                    .subtitle1!
                    .copyWith(color: Theme.of(context).colorScheme.secondary2)
                : Theme.of(context).primaryTextTheme.subtitle1,
            readOnly: true,
            decoration: InputDecoration(
              suffixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: IconSvg(
                  icon: icView,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            validator: wm.validateCategory,
            onSaved: (value) => wm.selectedCategory = value as String,
            onTap: wm.selectCategory,
          ),
        ),
      ),
    ];
  }

  /// поле Название
  List<Widget> _buildName() {
    return [
      const Text(addNewSightLabelName),
      sizedBoxH12,
      SizedBox(
        height: heightInput,
        child: TextFormField(
          focusNode: wm.fieldNameFocus,
          autofocus: true,
          onFieldSubmitted: (_) {
            wm.fieldFocusChange(context, wm.fieldNameFocus, wm.fieldLatFocus);
          },
          onTap: () {
            wm.setFocus(wm.fieldNameFocus);
          },
          controller: wm.fieldName.controller,
          cursorHeight: 24,
          cursorWidth: 1,
          maxLength: 100,
          maxLines: 1,
          textInputAction: TextInputAction.next,
          style: Theme.of(context).primaryTextTheme.subtitle1,
          decoration: InputDecoration(
            counterText: '',
            suffixIcon: _clearField(
              currentFocus: wm.fieldNameFocus,
              controller: wm.fieldName.controller,
            ),
            enabledBorder: _buildBorderColor(wm.fieldName.controller),
          ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(100),
          ],
          validator: wm.validateName,
          onSaved: (value) => wm.name = value as String,
        ),
      ),
    ];
  }

  /// поле Широта
  Widget _buildLat() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(addNewSightLabelLat),
          sizedBoxH12,
          SizedBox(
            height: heightInput,
            child: TextFormField(
              focusNode: wm.fieldLatFocus,
              autofocus: true,
              onFieldSubmitted: (_) {
                wm.fieldFocusChange(
                    context, wm.fieldLatFocus, wm.fieldLngFocus);
              },
              onTap: () {
                wm.setFocus(wm.fieldLatFocus);
              },
              controller: wm.fieldLat.controller,
              cursorHeight: 24,
              cursorWidth: 1,
              maxLength: 50,
              maxLines: 1,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              style: Theme.of(context).primaryTextTheme.subtitle1,
              decoration: InputDecoration(
                counterText: '',
                suffixIcon: _clearField(
                    currentFocus: wm.fieldLatFocus,
                    controller: wm.fieldLat.controller),
                enabledBorder: _buildBorderColor(wm.fieldLat.controller),
              ),
              validator: wm.validateCoordinates,
              onSaved: (value) => wm.lat = double.tryParse(value!) as double,
            ),
          ),
        ],
      ),
    );
  }

  /// поле Долгота
  Widget _buildLon() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(addNewSightLabelLon),
          sizedBoxH12,
          SizedBox(
            height: heightInput,
            child: TextFormField(
              focusNode: wm.fieldLngFocus,
              autofocus: true,
              onFieldSubmitted: (_) {
                wm.fieldFocusChange(
                    context, wm.fieldNameFocus, wm.fieldDescriptionFocus);
              },
              onTap: () {
                wm.setFocus(wm.fieldLngFocus);
              },
              controller: wm.fieldLng.controller,
              cursorHeight: 24,
              cursorWidth: 1,
              maxLength: 50,
              maxLines: 1,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              style: Theme.of(context).primaryTextTheme.subtitle1,
              decoration: InputDecoration(
                counterText: '',
                suffixIcon: _clearField(
                    currentFocus: wm.fieldLngFocus,
                    controller: wm.fieldLng.controller),
                enabledBorder: _buildBorderColor(wm.fieldLng.controller),
              ),
              validator: wm.validateCoordinates,
              onSaved: (value) => wm.lng = double.tryParse(value!) as double,
            ),
          ),
        ],
      ),
    );
  }

  /// кнопка Указать на карте
  Widget _buildButtonShowOnMap() => ButtonText(
        title: addNewSightTitleShowOnMap,
        onPressed: () {
          print('onPressed: $addNewSightTitleShowOnMap');
        },
      );

  /// поле Описание
  List<Widget> _buildDetails() {
    return [
      const Text(addNewSightLabelDetails),
      sizedBoxH12,
      TextFormField(
        focusNode: wm.fieldDescriptionFocus,
        autofocus: true,
        onEditingComplete: () {
          wm.clearFocus(wm.fieldDescriptionFocus);
        },
        onTap: () {
          wm.setFocus(wm.fieldDescriptionFocus);
        },
        controller: wm.fieldDescription.controller,
        cursorHeight: 24,
        cursorWidth: 1,
        maxLength: 300,
        maxLines: 3,
        textInputAction: TextInputAction.done,
        style: Theme.of(context).primaryTextTheme.subtitle1,
        decoration: InputDecoration(
          counterText: '',
          hintText: addNewSightHintTextDetails,
          hintStyle: Theme.of(context)
              .primaryTextTheme
              .subtitle1!
              .copyWith(color: Theme.of(context).colorScheme.inactiveBlack),
          suffixIcon: _clearField(
            currentFocus: wm.fieldDescriptionFocus,
            controller: wm.fieldDescription.controller,
          ),
          enabledBorder: _buildBorderColor(wm.fieldDescription.controller),
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(300),
        ],
        validator: wm.validateDetails,
        onSaved: (value) => wm.description = value as String,
      ),
    ];
  }

  /// очистка поля по кнопке
  Widget _clearField({
    required FocusNode currentFocus,
    required TextEditingController controller,
  }) {
    return StreamedStateBuilder<FocusNode>(
        streamedState: wm.currentFocusState,
        builder: (context, focus) {
          if (focus == currentFocus) {
            return ButtonClear(controller: controller);
          } else {
            return SizedBox.shrink();
          }
        });
  }

  /// цвет границы у уже правильно заполненного поля
  InputBorder _buildBorderColor(TextEditingController controller) =>
      Theme.of(context).inputDecorationTheme.enabledBorder!.copyWith(
            borderSide: BorderSide(
              color: controller.text.isNotEmpty
                  ? Theme.of(context).accentColor.withOpacity(0.4)
                  : Theme.of(context).colorScheme.inactiveBlack,
              style: BorderStyle.solid,
              width: 1,
            ),
          );

  /// клик по кнопке Создать
  void _submitForm() {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();

      wm.addPlace();

      /// подтверждаем сохранение данных
      _showDialog(
        category: wm.selectedCategory,
        name: wm.name,
        lat: wm.lat,
        lng: wm.lng,
        description: wm.description,
      );
    }
  }

  /// показываем окно если форма валидна
  void _showDialog({
    String? category,
    String? name,
    double? lat,
    double? lng,
    String? description,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusCard),
            ),
            title: Text(
              addNewSightAlertDialogHeader,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Theme.of(context).accentColor),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  category!,
                  style: Theme.of(context).primaryTextTheme.subtitle1,
                ),
                sizedBoxH12,
                Text(
                  name!,
                  style: Theme.of(context).primaryTextTheme.subtitle1,
                ),
                Text(
                  '${description!.substring(0, 100)} ...',
                  style: Theme.of(context).primaryTextTheme.subtitle1,
                ),
                sizedBoxH12,
                Text(
                  '$addNewSightAlertDialogLat$lat',
                  style: Theme.of(context).primaryTextTheme.bodyText2,
                ),
                Text(
                  '$addNewSightAlertDialogLon$lng',
                  style: Theme.of(context).primaryTextTheme.bodyText2,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlaceListScreen(),
                    ),
                  );
                },
                child: Text(
                  addNewSightAlertDialogSubmit,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Theme.of(context).accentColor),
                ),
              ),
            ],
          );
        });
  }

  /// окно для выбора загрузки фотографий
  Future<void> _showImageLoadingWindow() async {
    return showDialog(
        context: context,
        // barrierDismissible: true,
        builder: (_) {
          return ChoiceOfLoadingImages();
        });
  }
}
