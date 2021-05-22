import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/blocs/add_place_screen/fields/fields_bloc.dart';
import 'package:places/blocs/add_place_screen/form/add_form_bloc.dart';
import 'package:places/blocs/add_place_screen/select_category/select_category_cubit.dart';
import 'package:places/blocs/add_place_screen/user_images/user_images_cubit.dart';
import 'package:places/ui/screen/add_place_screen/select_category_screen.dart';
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
  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _fieldDescriptionFocus;

  @override
  void initState() {
    super.initState();
    _fieldDescriptionFocus = FocusNode();
  }

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
                    BlocBuilder<UserImagesCubit, UserImagesState>(
                        builder: (context, state) {
                      final cubit = context.read<UserImagesCubit>();
                      return ListCardsWithAddedImg(
                        data: state.userImages,
                        onAddImage: () {
                          cubit.addImg();
                          // todo пока закоментировала до реализации загрузки фото
                          // _showImageLoadingWindow();
                        },
                        onRemoveImage: cubit.removeImg,
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
              child: BlocBuilder<AddFormBloc, AddFormState>(
                builder: (context, state) {
                  /// для дальнейшей передачи данных в отправку формы
                  final isEnabled = context.watch<FieldsBloc>().state.isValid &&
                      context
                          .watch<UserImagesCubit>()
                          .state
                          .userImages
                          .isNotEmpty;
                  final fieldsState = context.watch<FieldsBloc>().state;
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
                            text: appNetworkException['emptyScreenText']!),
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
            ),
          ),
        ],
      ),
      // resizeToAvoidBottomInset: false,
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
        child: BlocBuilder<FieldsBloc, FieldsState>(
          builder: (context, state) {
            return Stack(
              children: [
                // todo баг с цветом границы категории срабатывает не сразу,
                // а при обращении к следующему полю
                CustomTextFieldUnderlineWidget(
                  onTap: _onSelectCategory,
                  validator: (value) => state.fieldCategoryIsValid,
                ),
                Positioned(
                  bottom: 14,
                  child: Text(
                    state.fieldCategory,
                    style: state.fieldCategory == emptyCategory
                        ? Theme.of(context)
                            .primaryTextTheme
                            .subtitle1!
                            .copyWith(
                                color: Theme.of(context).colorScheme.secondary2)
                        : Theme.of(context).primaryTextTheme.subtitle1,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ];
  }

  /// выбрать категорию (onTap)
  Future<void> _onSelectCategory() async {
    final newCategory = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: BlocProvider.of<FieldsBloc>(context),
            ),
            BlocProvider<SelectCategoryCubit>(
              create: (context) => SelectCategoryCubit()
                ..onTap(
                  context.read<FieldsBloc>().state.fieldCategory,
                ),
            ),
          ],
          child: SelectCategoryScreen(
            selectedCategory: context.read<FieldsBloc>().state.fieldCategory,
          ),
        ),
      ),
    );

    context.read<FieldsBloc>().add(
          CategoryChanged(fieldCategory: newCategory),
        );
    print('newCategory $newCategory');
    FocusScope.of(context).nextFocus();
  }

  /// поле Название
  List<Widget> _buildName() {
    return [
      const Text(addNewSightLabelName),
      sizedBoxH12,
      SizedBox(
        height: heightInput,
        child: BlocBuilder<FieldsBloc, FieldsState>(
          builder: (context, state) {
            return CustomTextFieldWidget(
              onChanged: (value) => context.read<FieldsBloc>().add(
                    NameChanged(fieldName: value),
                  ),
              onClear: () => context.read<FieldsBloc>().add(
                    NameChanged(fieldName: ''),
                  ),
              validator: (value) => state.fieldNameIsValid,
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              maxLength: 100,
            );
          },
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
            child: BlocBuilder<FieldsBloc, FieldsState>(
              builder: (context, state) {
                return CustomTextFieldWidget(
                  onChanged: (value) => context.read<FieldsBloc>().add(
                        LatChanged(fieldLat: value),
                      ),
                  onClear: () => context.read<FieldsBloc>().add(
                        LatChanged(fieldLat: ''),
                      ),
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
            child: BlocBuilder<FieldsBloc, FieldsState>(
              builder: (context, state) {
                return CustomTextFieldWidget(
                  onChanged: (value) => context.read<FieldsBloc>().add(
                        LngChanged(fieldLng: value),
                      ),
                  onClear: () => context.read<FieldsBloc>().add(
                        LngChanged(fieldLng: ''),
                      ),
                  validator: (value) => state.fieldLngIsValid,
                  onFieldSubmitted: (_) => FocusScope.of(context)
                      .requestFocus(_fieldDescriptionFocus),
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
      BlocBuilder<FieldsBloc, FieldsState>(
        builder: (context, state) {
          return CustomTextFieldWidget(
            focusNode: _fieldDescriptionFocus,
            onChanged: (value) => context.read<FieldsBloc>().add(
                  DescriptionChanged(fieldDescription: value),
                ),
            onClear: () => context.read<FieldsBloc>().add(
                  DescriptionChanged(fieldDescription: ''),
                ),
            validator: (value) => state.fieldDescriptionIsValid,
            onEditingComplete: () => FocusScope.of(context).unfocus(),
            textInputAction: TextInputAction.done,
            maxLength: 300,
            maxLines: 4,
          );
        },
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
