import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/blocs/search_screen/last_query/last_query_cubit.dart';
import 'package:places/blocs/search_screen/search_bloc.dart';
import 'package:places/data/model/card_type.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/search_history_item.dart';
import 'package:places/data/model/object_position.dart';
import 'package:places/ui/components/button_text.dart';
import 'package:places/ui/components/card_square_img.dart';
import 'package:places/ui/components/icon_leading_appbar.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/sizes.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/screen/place_details_screen.dart';
import 'package:places/ui/widgets/empty_page.dart';
import 'package:places/ui/widgets/loader.dart';
import 'package:places/ui/widgets/search_bar.dart';

/// экран поиска
class SearchScreen extends StatefulWidget {
  final ObjectPosition? userPosition;
  final SearchFilter filter;

  const SearchScreen({
    Key? key,
    this.userPosition,
    required this.filter,
  }) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  /// последний отправленный запрос
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() => setState(() {}));

    /// старт поиска при изменении текста в поле запроса
    context.read<SearchBloc>().add(
          StartSearchFromTextField(
            userLocation: widget.userPosition,
            filter: widget.filter,
          ),
        );
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _BuildAppBar(
        controller: _searchController,
        onTapBack: _back,
        onStartNewSearch: _onStartNewSearch,
        searchOnEditingComplete: _searchOnEditingComplete,
        onChanged: (value) => _searchOnChanged(value),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (_, state) {
          if (state is LoadingSearchState) {
            return _BuildLoader();
          } else if (state is LoadedSearchHistoryState) {
            return _BuildSearchHistory(
              data: state.result,
              controller: _searchController,
              filter: widget.filter,
              lastSearch: context.read<LastQueryCubit>().state.lastQuery,
            );
          } else if (state is LoadedSearchState) {
            if (state.result.isEmpty) {
              return _BuildSearchResultEmpty();
            } else {
              return _BuildSearchResult(
                data: state.result,
                lastSearch: context.watch<LastQueryCubit>().state.lastQuery,
              );
            }
          } else if (state is FailureSearchState) {
            return _BuildSearchError();
          } else if (state is ChangedTextFieldSearchState) {
            return SizedBox.shrink();
          }

          return _BuildLoader();
        },
      ),
    );
  }

  /// изменения в текстовом поле
  void _searchOnChanged(String query) {
    if (_searchController.text.isNotEmpty) {
      context.read<SearchBloc>().add(ChangedTextFieldSearch(query));
    }

    /// обновим последний запрос чтобы выделить жирным в случае успешного поиска
    // _lastSearch = query;
    context.read<LastQueryCubit>().saveQuery(query);
  }

  /// клик по кнопке клавиатуры - отправить запрос на поиск
  void _searchOnEditingComplete() {
    if (_searchController.text.isNotEmpty &&
        _searchController.text.trim().length > 2) {
      context.read<LastQueryCubit>().saveQuery(_searchController.text);

      context.read<SearchBloc>().add(
            GetSearchResult(
              userLocation: widget.userPosition,
              filter: widget.filter,
              keywords: _searchController.text,
            ),
          );
    } else {
      final snackBar = SnackBar(
        content: Text(searchIsShot),
        backgroundColor: Theme.of(context).errorColor,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  /// меняет состояние экрана на стартовое для нового поиска
  void _onStartNewSearch() {
    context.read<SearchBloc>().add(GetSearchHistory());
  }

  /// вернуться на предыдущий экран
  void _back() {
    Navigator.pop(context, widget.filter);
  }
}

class _BuildAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final VoidCallback onTapBack;
  final VoidCallback onStartNewSearch;
  final VoidCallback searchOnEditingComplete;
  final Function(String)? onChanged;

  const _BuildAppBar({
    Key? key,
    required this.controller,
    required this.onTapBack,
    required this.onStartNewSearch,
    required this.searchOnEditingComplete,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(132),
      child: AppBar(
        toolbarHeight: toolbarHeightStandard,
        automaticallyImplyLeading: false,
        leading: SmallLeadingIcon(
          icon: icArrow,
          onPressed: onTapBack,
        ),
        leadingWidth: 64,
        title: Text(
          searchAppBarTitle,
        ),
        centerTitle: true,
        flexibleSpace: Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: SearchBar(
              controller: controller,
              onStartNewSearch: onStartNewSearch,
              onEditingComplete: searchOnEditingComplete,
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(132);
}

/// сетевая ошибка
class _BuildSearchError extends StatelessWidget {
  const _BuildSearchError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyPage(
      icon: appNetworkException['emptyScreenIcon']!,
      header: appNetworkException['emptyScreenHeader']!,
      text: appNetworkException['emptyScreenText']!,
    );
  }
}

/// если ничего не найдено
class _BuildSearchResultEmpty extends StatelessWidget {
  const _BuildSearchResultEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const EmptyPage(
      icon: icEmptySearch,
      header: searchEmptyHeader,
      text: searchEmptyText,
    );
  }
}

/// лоадер при ожидании
class _BuildLoader extends StatelessWidget {
  const _BuildLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Loader(
          loaderSize: LoaderSize.small,
        ),
      ),
    );
  }
}

/// карточка для результатов поиска
class _BuildSearchItem extends StatelessWidget {
  final Place card;
  final String lastSearch;

  const _BuildSearchItem({
    Key? key,
    required this.card,
    required this.lastSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
      leading: Hero(
        tag: '${card.urls.first}',
        child: CardSquareImg(
          image: NetworkImage(
            card.urls.first,
          ),
        ),
      ),
      title: RichText(
        text: TextSpan(
          children: _buildRichText(
            context,
            string: card.name,
            search: lastSearch,
          ),
        ),
      ),
      subtitle: Text(
        card.getPlaceTypeName(),
        style: Theme.of(context).textTheme.bodyText2,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceDetailsScreen(
              card: card,
              cardType: CardType.search,
            ),
          ),
        );
      },
    );
  }

  /// для карточки результатов: выделяем жирным найденный запрос
  List<TextSpan> _buildRichText(BuildContext context,
      {required String string, required String search}) {
    List<TextSpan> result = [];
    int findIndex = string.toLowerCase().indexOf(search.toLowerCase());

    // искомое слово В начале
    if (findIndex == 0) {
      result.add(
        TextSpan(
          text: string.substring(0, search.length),
          style: Theme.of(context)
              .textTheme
              .headline5
              ?.copyWith(color: Theme.of(context).accentColor),
        ),
      );

      result.add(
        TextSpan(
          text: string.substring(search.length),
          style: Theme.of(context).primaryTextTheme.subtitle1,
        ),
      );
    }
    // искомое слово В конце
    else if (string.length == findIndex + search.length) {
      result.add(
        TextSpan(
          text: string.substring(0, findIndex),
          style: Theme.of(context).primaryTextTheme.subtitle1,
        ),
      );

      result.add(
        TextSpan(
          text: string.substring(findIndex),
          style: Theme.of(context)
              .textTheme
              .headline5
              ?.copyWith(color: Theme.of(context).accentColor),
        ),
      );
    }
    // искомое слово В середине
    else {
      result.add(
        TextSpan(
          text: string.substring(0, findIndex),
          style: Theme.of(context).primaryTextTheme.subtitle1,
        ),
      );

      result.add(
        TextSpan(
          text: string.substring(
            findIndex,
            findIndex + search.length,
          ),
          style: Theme.of(context)
              .textTheme
              .headline5
              ?.copyWith(color: Theme.of(context).accentColor),
        ),
      );

      result.add(
        TextSpan(
          text: string.substring(findIndex + search.length),
          style: Theme.of(context).primaryTextTheme.subtitle1,
        ),
      );
    }

    return result;
  }
}

/// список найденных результатов
class _BuildSearchResult extends StatelessWidget {
  final List<Place> data;
  final String lastSearch;

  const _BuildSearchResult({
    Key? key,
    required this.data,
    required this.lastSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: ListView.separated(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return _BuildSearchItem(
            card: data[index],
            lastSearch: lastSearch,
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            height: 1.0,
            indent: 72,
          );
        },
      ),
    );
  }
}

/// история поисковых запросов
class _BuildSearchHistory extends StatelessWidget {
  final List<SearchHistoryItem> data;
  final TextEditingController controller;
  final ObjectPosition? userPosition;
  final SearchFilter filter;
  final String? lastSearch;

  const _BuildSearchHistory({
    Key? key,
    required this.data,
    required this.controller,
    this.userPosition,
    required this.filter,
    this.lastSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return SizedBox.shrink();
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              searchHeaderHistory.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(color: Theme.of(context).colorScheme.inactiveBlack),
            ),
            sizedBoxH4,
            ListView.separated(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: Text(
                    data[index].request,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .subtitle1!
                        .copyWith(
                            color: Theme.of(context).colorScheme.secondary2),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      /// удаляем позицию из истории запросов
                      context
                          .read<SearchBloc>()
                          .add(DeleteRequestFromHistory(data[index].id));
                    },
                    icon: SvgPicture.asset(
                      icDelete,
                      color: Theme.of(context).colorScheme.inactiveBlack,
                    ),
                    splashRadius: splashRadiusSmall,
                  ),
                  onTap: () {
                    /// выполняем поиск по тапу по пункту в истории запросов
                    controller.text = data[index].request;
                    context.read<LastQueryCubit>().saveQuery(controller.text);

                    context.read<SearchBloc>().add(
                          GetSearchResult(
                            userLocation: userPosition,
                            filter: filter,
                            keywords: controller.text,
                          ),
                        );
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            ),
            ButtonText(
              title: searchClear,
              onPressed: () {
                context.read<SearchBloc>().add(ClearSearchHistory());
              },
            ),
          ],
        ),
      ),
    );
  }
}
