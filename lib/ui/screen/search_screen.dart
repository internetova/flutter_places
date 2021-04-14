import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/data/model/place.dart';
import 'package:places/redux/action/search_action.dart';
import 'package:places/redux/state/app_state.dart';
import 'package:places/redux/state/search_state.dart';
import 'package:places/ui/screen/components/bottom_navigationbar.dart';
import 'package:places/ui/screen/components/button_text.dart';
import 'package:places/ui/screen/components/card_square_img.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/res/themes.dart';
import 'package:places/ui/screen/place_details.dart';
import 'package:places/ui/screen/widgets/empty_page.dart';
import 'package:places/ui/screen/widgets/search_bar.dart';
import 'package:flutter_redux/flutter_redux.dart';

/// экран поиска
class SearchScreen extends StatefulWidget {
  final SearchFilter filter;

  const SearchScreen({
    Key? key,
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
  }

  @override
  void dispose() {
    super.dispose();

    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar() as PreferredSizeWidget?,
      body: StoreConnector<AppState, SearchState>(
        onInit: (store) => store.dispatch(GetSearchHistoryAction()),
        converter: (store) => store.state.searchState,
        builder: (BuildContext context, state) {
          if (state is SearchLoadingState) {
            print('Загружаем результаты Поиска или Историю $state');

            return _buildLoader();
          } else if (state is SearchResultHistoryState) {
            print('История запросов ${state.result}');

            return _buildSearchHistory(state.result);
          } else if (state is SearchResultState) {
            print('Результаты поиска ${state.result}');

            if (state.result.isEmpty) {
              return _buildSearchResultEmpty();
            } else {
              return _buildSearchResult(state.result);
            }
          } else if (state is SearchErrorState) {
            return _buildSearchError();
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
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  /// клик по кнопке клавиатуры - отправить запрос на поиск
  _searchOnEditingComplete() {
    _lastSearch = _searchController.text;

    StoreProvider.of<AppState>(context).dispatch(
        GetSearchResultAction(filter: widget.filter, keywords: _lastSearch));
  }

  /// меняет состояние экрана на стартовое для нового поиска
  _onStartNewSearch() {
    StoreProvider.of<AppState>(context).dispatch(GetSearchHistoryAction());
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
        child: SizedBox(
          child: const CircularProgressIndicator(),
          width: 40,
          height: 40,
        ),
      ),
    );
  }

  /// карточка для результатов поиска
  Widget _buildSearchItem(Place card) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
      leading: CardSquareImg(
        image: NetworkImage(
          card.urls[0],
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
  Widget _buildSearchHistory(List<String> data) {
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
              searchHeaderHistory,
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(color: Theme.of(context).colorScheme.inactiveBlack),
            ),
            const SizedBox(height: 4),
            for (int i = 0; i < data.length; i++) ...[
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: Text(
                  data[i],
                  style: Theme.of(context).primaryTextTheme.subtitle1!.copyWith(
                      color: Theme.of(context).colorScheme.secondary2),
                ),
                trailing: IconButton(
                  onPressed: () {
                    StoreProvider.of<AppState>(context)
                        .dispatch(RemoveRequestFromHistoryAction(i));
                  },
                  icon: SvgPicture.asset(
                    icDelete,
                    color: Theme.of(context).colorScheme.inactiveBlack,
                  ),
                  splashRadius: 24,
                ),
                onTap: () {
                  _searchController.text = data[i];
                  StoreProvider.of<AppState>(context).dispatch(
                      GetSearchResultAction(
                          filter: widget.filter, keywords: data[i]));
                  // _search();
                },
              ),
              Divider(),
            ],
            ButtonText(
              title: 'Очистить историю',
              onPressed: () {
                StoreProvider.of<AppState>(context)
                    .dispatch(ClearHistorySearchAction());
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
