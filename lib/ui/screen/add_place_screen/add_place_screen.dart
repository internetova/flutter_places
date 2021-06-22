import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/blocs/add_place_screen/fields/fields_cubit.dart';
import 'package:places/blocs/add_place_screen/form/add_form_bloc.dart';
import 'package:places/blocs/add_place_screen/select_category/select_category_cubit.dart';
import 'package:places/blocs/add_place_screen/select_position/select_place_position_cubit.dart';
import 'package:places/blocs/add_place_screen/user_images/user_images_cubit.dart';
import 'package:places/data/model/object_position.dart';
import 'package:places/ui/screen/add_place_screen/select_category_screen.dart';
import 'package:places/ui/screen/add_place_screen/select_position_screen.dart';
import 'package:places/ui/screen/add_place_screen/widgets/custom_text_field_widget.dart';
import 'package:places/ui/components/button_save.dart';
import 'package:places/ui/components/button_text.dart';
import 'package:places/ui/components/title_leading_appbar.dart';
import 'package:places/ui/res/sizes.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/widgets/choice_of_loading_images.dart';
import 'package:places/ui/widgets/empty_page.dart';
import 'package:places/ui/widgets/list_cards_with_added_img.dart';

/// экран добавление нового места
class AddPlaceScreen extends StatefulWidget {
  final ObjectPosition? userPosition;

  const AddPlaceScreen({Key? key, this.userPosition}) : super(key: key);

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  late final TextEditingController _categoryController;
  late final TextEditingController _nameController;
  late final TextEditingController _latController;
  late final TextEditingController _lngController;
  late final TextEditingController _descriptionController;
  late final FocusNode _fieldDescriptionFocus;

  @override
  void initState() {
    super.initState();
    _categoryController = TextEditingController();
    _nameController = TextEditingController();
    _latController = TextEditingController();
    _lngController = TextEditingController();
    _descriptionController = TextEditingController();
    _fieldDescriptionFocus = FocusNode();

    _categoryController.addListener(() => setState(() {}));
    _nameController.addListener(() => setState(() {}));
    _latController.addListener(() => setState(() {}));
    _lngController.addListener(() => setState(() {}));
    _descriptionController.addListener(() => setState(() {}));

    _categoryController.text = emptyCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _BuildAppBar(),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _BuildUserImages(),
                    sizedBoxH24,
                    _BuildCategory(controller: _categoryController),
                    _BuildName(controller: _nameController),
                    Row(
                      children: [
                        _BuildLat(controller: _latController),
                        sizedBoxW16,
                        _BuildLng(
                          controller: _lngController,
                          nextFocus: _fieldDescriptionFocus,
                        ),
                      ],
                    ),
                    _BuildButtonShowOnMap(
                      latController: _latController,
                      lngController: _lngController,
                      userPosition: widget.userPosition,
                    ),
                    _BuildDetails(
                      controller: _descriptionController,
                      currentFocus: _fieldDescriptionFocus,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: _BuildButtonCreate(),
          ),
        ],
      ),
      // resizeToAvoidBottomInset: false,
    );
  }
}

/// AppBar
class _BuildAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeightStandard);
}

/// загрузка фото
class _BuildUserImages extends StatelessWidget {
  const _BuildUserImages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserImagesCubit, UserImagesState>(
      builder: (context, state) {
        final cubit = context.read<UserImagesCubit>();
        return ListCardsWithAddedImg(
          data: state.userImages,
          onAddImage: () {
            _showImageLoadingWindow(context, cubit);
          },
          onRemoveImage: cubit.removeImg,
        );
      },
    );
  }

  /// окно для выбора загрузки фотографий
  Future<void> _showImageLoadingWindow(
      BuildContext context, UserImagesCubit imagesCubit) async {
    return showDialog(
        context: context,
        builder: (_) {
          return ChoiceOfLoadingImages(imagesCubit: imagesCubit);
        });
  }
}

/// Поле Категория
class _BuildCategory extends StatelessWidget {
  final TextEditingController controller;

  const _BuildCategory({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          child: BlocBuilder<FieldsCubit, FieldsState>(
            builder: (context, state) {
              return CustomTextFieldUnderlineWidget(
                controller: controller,
                onTap: () {
                  _onSelectCategory(context);
                },
                validator: (value) => state.fieldCategoryIsValid,
              );
            },
          ),
        ),
        sizedBoxH24,
      ],
    );
  }

  /// выбрать категорию (onTap)
  Future<void> _onSelectCategory(BuildContext context) async {
    final _newCategory = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: BlocProvider.of<FieldsCubit>(context),
            ),
            BlocProvider<SelectCategoryCubit>(
              create: (context) => SelectCategoryCubit()
                ..onTap(
                  context.read<FieldsCubit>().state.fieldCategory,
                ),
            ),
          ],
          child: SelectCategoryScreen(
            selectedCategory: context.read<FieldsCubit>().state.fieldCategory,
          ),
        ),
      ),
    );

    controller.text = _newCategory;

    FocusScope.of(context).nextFocus();
  }
}

/// поле Название
class _BuildName extends StatelessWidget {
  final TextEditingController controller;

  const _BuildName({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(addNewSightLabelName),
        sizedBoxH12,
        SizedBox(
          height: heightInput,
          child: BlocBuilder<FieldsCubit, FieldsState>(
            builder: (context, state) {
              return CustomTextFieldWidget(
                controller: controller,
                onChanged: (value) => context.read<FieldsCubit>().nameChanged(value),
                onClear: () => context.read<FieldsCubit>().nameChanged(''),
                validator: (value) => state.fieldNameIsValid,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                maxLength: 100,
              );
            },
          ),
        ),
        sizedBoxH24,
      ],
    );
  }
}

/// поле Широта
class _BuildLat extends StatelessWidget {
  final TextEditingController controller;

  const _BuildLat({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(addNewSightLabelLat),
          sizedBoxH12,
          SizedBox(
            height: heightInput,
            child: BlocBuilder<FieldsCubit, FieldsState>(
              builder: (context, state) {
                return CustomTextFieldWidget(
                  controller: controller,
                  onChanged: (value) => context.read<FieldsCubit>().latChanged(value),
                  onClear: () => context.read<FieldsCubit>().latChanged(''),
                  validator: (value) => state.fieldLatIsValid,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  keyboardType: TextInputType.number,
                  maxLength: 50,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// поле Долгота
class _BuildLng extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode nextFocus;

  const _BuildLng({
    Key? key,
    required this.controller,
    required this.nextFocus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(addNewSightLabelLon),
          sizedBoxH12,
          SizedBox(
            height: heightInput,
            child: BlocBuilder<FieldsCubit, FieldsState>(
              builder: (context, state) {
                return CustomTextFieldWidget(
                  controller: controller,
                  onChanged: (value) => context.read<FieldsCubit>().lngChanged(value),
                  onClear: () => context.read<FieldsCubit>().lngChanged(''),
                  validator: (value) => state.fieldLngIsValid,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(nextFocus),
                  keyboardType: TextInputType.number,
                  maxLength: 50,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// кнопка Указать на карте
class _BuildButtonShowOnMap extends StatelessWidget {
  final ObjectPosition? userPosition;
  final TextEditingController latController;
  final TextEditingController lngController;

  const _BuildButtonShowOnMap({
    Key? key,
    this.userPosition,
    required this.latController,
    required this.lngController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonText(
      title: addNewSightTitleShowOnMap,
      onPressed: () async {
        ObjectPosition? _placePosition;

        if (context.read<FieldsCubit>().state.fieldLat != '' &&
            context.read<FieldsCubit>().state.fieldLng != '') {
          _placePosition = ObjectPosition(
              lat: double.tryParse(context.read<FieldsCubit>().state.fieldLat) ??
                  defaultPosition.lat,
              lng: double.tryParse(context.read<FieldsCubit>().state.fieldLng) ??
                  defaultPosition.lng);
        }

        final ObjectPosition? _newPlacePosition = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: BlocProvider.of<FieldsCubit>(context),
                ),
                BlocProvider<SelectPlacePositionCubit>(
                    create: (context) => SelectPlacePositionCubit()),
              ],
              child: SelectPositionScreen(
                userPosition: userPosition ?? defaultPosition,
                placePosition: _placePosition,
              ),
            ),
          ),
        );

        if (_newPlacePosition != null) {
          context.read<FieldsCubit>().latChanged(_newPlacePosition.lat.toString());

          context.read<FieldsCubit>().lngChanged(_newPlacePosition.lng.toString());

          latController.text = _newPlacePosition.lat.toString();
          lngController.text = _newPlacePosition.lng.toString();
        }
      },
    );
  }
}

/// поле Описание
class _BuildDetails extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode currentFocus;

  const _BuildDetails({
    Key? key,
    required this.currentFocus,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sizedBoxH12,
        const Text(addNewSightLabelDetails),
        sizedBoxH12,
        BlocBuilder<FieldsCubit, FieldsState>(
          builder: (context, state) {
            return CustomTextFieldWidget(
              controller: controller,
              focusNode: currentFocus,
              onChanged: (value) => context.read<FieldsCubit>().descriptionChanged(value),
              onClear: () => context.read<FieldsCubit>().descriptionChanged(''),
              validator: (value) => state.fieldDescriptionIsValid,
              onEditingComplete: () => FocusScope.of(context).unfocus(),
              textInputAction: TextInputAction.done,
              maxLength: 700,
              maxLines: 4,
            );
          },
        ),
      ],
    );
  }
}

class _BuildButtonCreate extends StatelessWidget {
  const _BuildButtonCreate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: BlocBuilder<AddFormBloc, AddFormState>(
        builder: (context, state) {
          /// для дальнейшей передачи данных в отправку формы
          final isEnabled = context.watch<FieldsCubit>().state.isValid &&
              context.watch<UserImagesCubit>().state.userImages.isNotEmpty;
          final fieldsState = context.watch<FieldsCubit>().state;
          final imagesState = context.watch<UserImagesCubit>().state;

          if (state is AddFormInitial) {
            /// кнопка активна когда форма валидна
            return AnimatedSwitcher(
              duration: milliseconds300,
              child: ButtonSave(
                key: ValueKey(isEnabled),
                title: titleButtonSaveAddSightScreen,
                isButtonEnabled: isEnabled,
                onPressed: isEnabled
                    ? () => _formSubmit(
                          context,
                          fieldsState: fieldsState,
                          imagesState: imagesState,
                        )
                    : null,
              ),
            );
          } else if (state is AddFormSubmitting) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                sizedBoxH16,
                ButtonSave(
                  title: titleButtonSaveAddSightScreen,
                  isButtonEnabled: false,
                  onPressed: null,
                ),
              ],
            );
          } else if (state is AddFormSubmissionSuccess) {
            /// подтверждаем сохранение данных
            return ButtonSave(
              title: titleButtonSaveAddSightScreen,
              isButtonEnabled: false,
              onPressed: null,
            );
          } else if (state is AddFormSubmissionFailed) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                EmptyPage(
                  icon: appNetworkException['emptyScreenIcon']!,
                  header: appNetworkException['emptyScreenHeader']!,
                  text: appNetworkException['emptyScreenText']!,
                ),
                sizedBoxH24,
                ButtonSave(
                  title: titleButtonSaveOneMoreAddSightScreen,
                  isButtonEnabled: isEnabled,
                  onPressed: isEnabled
                      ? () => _formSubmit(
                            context,
                            fieldsState: fieldsState,
                            imagesState: imagesState,
                          )
                      : null,
                ),
              ],
            );
          }

          return SizedBox.shrink();
        },
      ),
    );
  }

  /// клик по кнопке Создать
  void _formSubmit(
    BuildContext context, {
    required FieldsState fieldsState,
    required UserImagesState imagesState,
  }) {
    // отправляем данные из полей формы и загруженные фото
    context.read<AddFormBloc>().add(
          FormEventSubmitted(
            context,
            fieldsState: fieldsState,
            imagesState: imagesState,
          ),
        );
  }
}
