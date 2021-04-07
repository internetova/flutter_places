import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/data/model/place.dart';
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

/// экран поиска
class SightSearchScreen extends StatefulWidget {
  final SearchFilter filter;

  const SightSearchScreen({
    Key? key,
    required this.filter,
  }) : super(key: key);

  @override
  _SightSearchScreenState createState() => _SightSearchScreenState();
}

class _SightSearchScreenState extends State<SightSearchScreen> {
  /// запишем результаты по отмене фокуса или отправке запроса кнопкой клавиатуры
  /// или если был тап по результату автопоиска по таймеру
  List<String> _dataResults = [];
  late String _lastSearch;

  final TextEditingController _searchController = TextEditingController();
  late StreamController<List<Place>?> _streamController;
  Stream<List<Place>?>? _stream;

  /// для передачи / снятия фокуса по тапам и через клавиатуру
  final _searchFocus = FocusNode();
  FocusNode? _currentFocus;

  /// для показа лоадера
  bool _isWaiting = false;

  /// нефильтрованные данные
  // final List<UiPlace> _fullData = mocks;

  /// отфильтрованные результаты
  List<Place> _filteredData = [];

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() => setState(() {}));
    _streamController = StreamController();
    _stream = _streamController.stream;
    _currentFocus = _searchFocus;

    if (widget.filter != null) {
      // _filteredData = filterData(
      //     data: _fullData,
      //     categories: widget.filter!.categories,
      //     centerPoint: widget.filter!.centerPoint,
      //     distance: widget.filter!.distance);
    }
  }

  @override
  void dispose() {
    super.dispose();

    _searchController.dispose();
    _searchFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_searchController.text.isEmpty || _searchController.text.length == 0) {
      _streamController.add(null);
    }

    return Scaffold(
      appBar: _buildAppBar() as PreferredSizeWidget?,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isWaiting) _buildLoaderWaiting(),
          Expanded(
            child: StreamBuilder(
                stream: _stream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Place>?> snapshot) {
                  if (snapshot.hasError) {
                    return _buildSearchError();
                  }

                  if (snapshot.hasData && !snapshot.hasError) {
                    if (snapshot.data!.isEmpty) {
                      return _buildSearchResultEmpty();
                    } else {
                      return _buildSearchResult(snapshot.data!);
                    }
                  }

                  return _buildTempStreamBuilderResult();
                }),
          ),
        ],
      ),
      bottomNavigationBar: const MainBottomNavigationBar(current: 0),
    );
  }

  /// для отображения истории поиска чтобы скрывать историю во время
  /// процесса поиска
  Widget _buildTempStreamBuilderResult() {
    if (_isWaiting) {
      return SizedBox(width: 0);
    } else {
      return _buildSearchHistory(_dataResults);
    }
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
                    focus: _searchFocus,
                    onEditingComplete: _searchOnEditingComplete,
                    onTap: _searchOnTap,
                    data: _dataResults,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  /// записать поисковое выражение в базу
  void _writeRequest(
      {List<String>? data, required TextEditingController controller}) {
    if (controller.text.isNotEmpty && !data!.contains(controller.text)) {
      data.add(controller.text.trim());
    }
  }

  /// поиск
  Future<void> _search() async {
    if (_searchController.text.isEmpty ||
        _searchController.text.trim().length == 0) {
      _streamController.add(null);

      return;
    }

    /// на время поиска показываем лоадер
    _showLoader(true);

    // final result = await _searchData(
    //   data: widget.filter != null ? _filteredData : _fullData,
    //   query: _searchController.text,
    // );

    _showLoader(false);

    // _streamController.add(result);
    _lastSearch = _searchController.text;
  }

  /// управление отображением лоадера
  void _showLoader(bool isWaiting) {
    setState(() => _isWaiting = isWaiting);
  }

  /// поиск в базе по запросу
  Future<List<Place>> _searchData(
      {required List<Place> data, String? query}) async {
    List<Place> result = [];

    for (var i = 0; i < data.length; i++) {
      if (data[i].name.toLowerCase().contains(query!.trim().toLowerCase())) {
        result.add(data[i]);
      }
    }

    /// типа ждём ответ от сервера - временно
    await Future.delayed(Duration(seconds: 2));

    return result;
  }

  /// клик по кнопке клавиатуры - отправить запрос на поиск
  _searchOnEditingComplete() {
    _search();
    _searchFocus.unfocus();
    _currentFocus = null;

    _writeRequest(
      data: _dataResults,
      controller: _searchController,
    );

    PlaceInteractor().saveKeywords(_searchController.text);
  }

  /// клик по полю поиска
  _searchOnTap() {
    FocusScope.of(context).requestFocus(_searchFocus);
    setState(() {
      _currentFocus = _searchFocus;
    });
  }

  /// ошибка поиска
  Widget _buildSearchError() {
    return Center(
      child: Text(searchError),
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
  Widget _buildLoaderWaiting() {
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
        _writeRequest(
          data: _dataResults,
          controller: _searchController,
        );

        PlaceInteractor().saveKeywords(_searchController.text);

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
                    setState(() {
                      data.removeAt(i);
                    });
                  },
                  icon: SvgPicture.asset(
                    icDelete,
                    color: Theme.of(context).colorScheme.inactiveBlack,
                  ),
                  splashRadius: 24,
                ),
                onTap: () {
                  _searchController.text = data[i];
                  _search();
                },
              ),
              Divider(),
            ],
            ButtonText(
              title: 'Очистить историю',
              onPressed: () {
                setState(() {
                  data.clear();
                });

                PlaceInteractor().clearSearchHistory();
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
