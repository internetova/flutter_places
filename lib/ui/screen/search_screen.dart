import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/blocs/search_screen/search_bloc.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/search_history_item.dart';
import 'package:places/data/model/user_location.dart';
import 'package:places/ui/components/bottom_navigationbar.dart';
import 'package:places/ui/components/button_text.dart';
import 'package:places/ui/components/card_square_img.dart';
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
  final UserLocation? userLocation;
  final SearchFilter filter;

  const SearchScreen({
    Key? key,
    this.userLocation,
    required this.filter,
  }) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  /// последний отправленный запрос
  late String _lastSearch;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));

    /// старт поиска при изменении текста в поле запроса
    context.read<SearchBloc>().add(
          StartSearchFromTextField(
            userLocation: widget.userLocation,
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
      appBar: _buildAppBar() as PreferredSizeWidget,
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (_, state) {
          if (state is LoadingSearchState) {
            return _buildLoader();
          } else if (state is LoadedSearchHistoryState) {
            return _buildSearchHistory(state.result);
          } else if (state is LoadedSearchState) {
            if (state.result.isEmpty) {
              return _buildSearchResultEmpty();
            } else {
              return _buildSearchResult(state.result);
            }
          } else if (state is FailureSearchState) {
            return _buildSearchError();
          } else if (state is ChangedTextFieldSearchState) {
            return SizedBox.shrink();
          }

          return _buildLoader();
        },
      ),
      bottomNavigationBar: const MainBottomNavigationBar(current: 0),
    );
  }

  /// appBar
  Widget _buildAppBar() => PreferredSize(
        preferredSize: Size.fromHeight(132),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: _back,
                    child: Text(
                      searchAppBarTitle,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  sizedBoxH24,
                  SearchBar(
                    controller: _searchController,
                    onStartNewSearch: _onStartNewSearch,
                    onEditingComplete: _searchOnEditingComplete,
                    onChanged: (value) => _searchOnChanged(value),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  void _searchOnChanged(String queryString) {
    if (_searchController.text.isNotEmpty) {
      context.read<SearchBloc>().add(ChangedTextFieldSearch(queryString));
    }

    /// обновим последний запрос чтобы выделить жирным в случае успешного поиска
    _lastSearch = queryString;
  }

  /// клик по кнопке клавиатуры - отправить запрос на поиск
  void _searchOnEditingComplete() {
    if (_searchController.text.isNotEmpty &&
        _searchController.text.trim().length > 2) {
      _lastSearch = _searchController.text;
      context.read<SearchBloc>().add(
            GetSearchResult(
              userLocation: widget.userLocation,
              filter: widget.filter,
              keywords: _lastSearch,
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

  /// сетевая ошибка
  Widget _buildSearchError() {
    return EmptyPage(
      icon: appNetworkException['emptyScreenIcon']!,
      header: appNetworkException['emptyScreenHeader']!,
      text: appNetworkException['emptyScreenText']!,
    );
  }

  /// если ничего не найдено
  Widget _buildSearchResultEmpty() {
    return const EmptyPage(
      icon: icEmptySearch,
      header: searchEmptyHeader,
      text: searchEmptyText,
    );
  }

  /// лоадер при ожидании
  Widget _buildLoader() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Loader(
          loaderSize: LoaderSize.small,
        ),
      ),
    );
  }

  /// карточка для результатов поиска
  Widget _buildSearchItem(Place card) {
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
            string: card.name,
            search: _lastSearch,
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
            builder: (context) => PlaceDetails(card: card),
          ),
        );
      },
    );
  }

  /// для карточки результатов: выделяем жирным найденный запрос
  List<TextSpan> _buildRichText(
      {required String string, required String search}) {
    List<TextSpan> result = [];
    int findIndex = string.toLowerCase().indexOf(search.toLowerCase());

    // искомое слово В начале
    if (findIndex == 0) {
      result.add(
        TextSpan(
          text: string.substring(0, search.length),
          style: Theme.of(context).textTheme.headline5,
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
          style: Theme.of(context).textTheme.headline5,
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
            style: Theme.of(context).textTheme.headline5),
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

  /// список найденных результатов
  Widget _buildSearchResult(List<Place> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: ListView.separated(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildSearchItem(data[index]);
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

  /// история поисковых запросов
  Widget _buildSearchHistory(List<SearchHistoryItem> data) {
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
                    _searchController.text = data[index].request;
                    _lastSearch = data[index].request;

                    context.read<SearchBloc>().add(
                          GetSearchResult(
                            userLocation: widget.userLocation,
                            filter: widget.filter,
                            keywords: _searchController.text,
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

  /// вернуться на предыдущий экран
  void _back() {
    Navigator.pop(context, widget.filter);
  }
}
