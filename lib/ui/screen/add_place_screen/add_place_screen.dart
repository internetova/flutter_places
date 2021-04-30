import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/blocs/add_place_screen/add_place/add_place_bloc.dart';
import 'package:places/blocs/add_place_screen/select_category/select_category_cubit.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/ui/screen/add_place_screen/select_category_screen.dart';
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

/// экран добавление нового места
class AddPlaceScreen extends StatefulWidget {
  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
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
                    // todo прошу проверить пока так!
                    //  боюсь не успеть на проверку перед праздниками
                    // StreamedStateBuilder<List<TestImage>>(
                    //     streamedState: wm.userListImgState,
                    //     builder: (context, userListImg) {
                    //       return ListCardsWithAddedImg(
                    //         data: userListImg!,
                    //         onAddImage: () {
                    //           wm.addImg();
                    //           // todo пока закоментировала до реализации загрузки фото
                    //           // _showImageLoadingWindow();
                    //         },
                    //         onRemoveImage: wm.removeImg,
                    //       );
                    //     }),
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
              child: BlocBuilder<AddPlaceBloc, AddPlaceState>(
                builder: (context, state) {
                  return ButtonSave(
                    title: titleButtonSaveAddSightScreen,
                    isButtonEnabled: state.isValid,
                    onPressed: state.isValid
                        ? () =>
                            context.read<AddPlaceBloc>().add(FormSubmitted())
                        : null,
                  );
                },
              ),
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
        child: BlocBuilder<AddPlaceBloc, AddPlaceState>(
          builder: (context, state) {
            return Stack(children: [
              CustomTextFieldUnderlineWidget(
                onTap: _onSelectCategory,
                onChanged: (value) => context.read<AddPlaceBloc>().add(
                      FieldCategoryChanged(fieldCategory: value),
                    ),
                validator: (value) => state.fieldCategoryIsValid,
              ),
              Positioned(
                bottom: 14,
                child: Text(
                  state.fieldCategory,
                  style: state.fieldCategory == emptyCategory
                      ? Theme.of(context).primaryTextTheme.subtitle1!.copyWith(
                          color: Theme.of(context).colorScheme.secondary2)
                      : Theme.of(context).primaryTextTheme.subtitle1,
                ),
              ),
            ]);
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
            BlocProvider<AddPlaceBloc>(
              create: (_) => AddPlaceBloc(
                context.read<PlaceInteractor>(),
              ),
            ),
            BlocProvider<SelectCategoryCubit>(
              create: (context) => SelectCategoryCubit()
                ..onTap(
                  context.read<AddPlaceBloc>().state.fieldCategory,
                ),
            ),
          ],
          child: SelectCategoryScreen(
            selectedCategory: context.read<AddPlaceBloc>().state.fieldCategory,
          ),
        ),
      ),
    );

    context
        .read<AddPlaceBloc>()
        .add(FieldCategoryChanged(fieldCategory: newCategory));
  }

  /// поле Название
  List<Widget> _buildName() {
    return [
      const Text(addNewSightLabelName),
      sizedBoxH12,
      SizedBox(
        height: heightInput,
        child: BlocBuilder<AddPlaceBloc, AddPlaceState>(
          builder: (context, state) {
            return CustomTextFieldWidget(
              onChanged: (value) => context.read<AddPlaceBloc>().add(
                    FieldNameChanged(fieldName: value),
                  ),
              validator: (value) => state.fieldNameIsValid,
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
            child: BlocBuilder<AddPlaceBloc, AddPlaceState>(
              builder: (context, state) {
                return CustomTextFieldWidget(
                  onChanged: (value) => context.read<AddPlaceBloc>().add(
                        FieldLatChanged(fieldLat: value),
                      ),
                  validator: (value) => state.fieldLatIsValid,
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
            child: BlocBuilder<AddPlaceBloc, AddPlaceState>(
              builder: (context, state) {
                return CustomTextFieldWidget(
                  onChanged: (value) => context.read<AddPlaceBloc>().add(
                        FieldLngChanged(fieldLng: value),
                      ),
                  validator: (value) => state.fieldLngIsValid,
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
      BlocBuilder<AddPlaceBloc, AddPlaceState>(
        builder: (context, state) {
          return CustomTextFieldWidget(
            onChanged: (value) => context.read<AddPlaceBloc>().add(
                  FieldDescriptionChanged(fieldDescription: value),
                ),
            validator: (value) => state.fieldDescriptionIsValid,
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
