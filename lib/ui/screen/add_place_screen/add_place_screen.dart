import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mwwm/mwwm.dart';
import 'package:places/ui/screen/add_place_screen/add_place_wm.dart';
import 'package:places/ui/screen/add_place_screen/widgets/custom_text_field_widget.dart';
import 'package:places/ui/screen/components/button_save.dart';
import 'package:places/ui/screen/components/button_text.dart';
import 'package:places/ui/screen/components/title_leading_appbar.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/res/themes.dart';
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
                key: wm.formKey,
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
                              // todo пока закоментировала до реализации загрузки фото
                              // _showImageLoadingWindow();
                            },
                            onRemoveImage: wm.removeImg,
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
                      onPressed: () =>
                          isButtonEnabled ? wm.submitForm(context) : null,
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
          child: CustomTextFieldUnderlineWidget(
            focusNode: wm.fieldCategoryFocus,
            controller: wm.fieldCategory.controller,
            onTap: wm.selectCategory,
            validator: wm.validateCategory,
            onSaved: wm.saveSelectedCategory,
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
        child: CustomTextFieldWidget(
          focusNode: wm.fieldNameFocus,
          controller: wm.fieldName.controller,
          onFieldSubmitted: (_) {
            wm.fieldFocusChange(wm.fieldLatFocus);
          },
          validator: wm.validateName,
          onSaved: wm.saveName,
          maxLength: 100,
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
            child: CustomTextFieldWidget(
              focusNode: wm.fieldLatFocus,
              controller: wm.fieldLat.controller,
              onFieldSubmitted: (_) {
                wm.fieldFocusChange( wm.fieldLngFocus);
              },
              validator: wm.validateCoordinates,
              onSaved: wm.saveLat,
              keyboardType: TextInputType.number,
              maxLength: 50,
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
            child: CustomTextFieldWidget(
              focusNode: wm.fieldLngFocus,
              controller: wm.fieldLng.controller,
              onFieldSubmitted: (_) {
                wm.fieldFocusChange( wm.fieldDescriptionFocus);
              },
              validator: wm.validateCoordinates,
              onSaved: wm.saveLng,
              keyboardType: TextInputType.number,
              maxLength: 50,
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
      CustomTextFieldWidget(
        focusNode: wm.fieldDescriptionFocus,
        controller: wm.fieldDescription.controller,
        onEditingComplete: () {
          wm.clearFocus(wm.fieldDescriptionFocus);
        },
        validator: wm.validateDetails,
        onSaved: wm.saveDescription,
        textInputAction: TextInputAction.done,
        maxLength: 300,
        maxLines: 4,
      ),
    ];
  }

  /// todo скрыла до реализации загрузки фотографий
  /// окно для выбора загрузки фотографий
  Future<void> _showImageLoadingWindow() async {
    return showDialog(
        context: context,
        builder: (_) {
          return ChoiceOfLoadingImages();
        });
  }
}
