import 'package:flutter/material.dart';
import 'package:places/components/bottom_navigationbar.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/widgets/search_bar.dart';

/// константы
const appBarTitle = 'Список интересных мест';

/// экран поиска
class SightSearchScreen extends StatefulWidget {
  @override
  _SightSearchScreenState createState() => _SightSearchScreenState();
}

class _SightSearchScreenState extends State<SightSearchScreen> {
  /// запишем запросы из поисковой строки
  List<String> _baseQuery = [];

  /// запишем результаты по отмене фокуса или отправке запроса кнопкой клавиатуры
  List<String> _baseResults = [];

  /// отправляем последний элемент массива в качестве запроса
  /// в массиве запросы из целых слов ['храм', 'храм джедаев']
  Stream<String> _stream(List<String> data) async* {
    await Future.delayed(Duration(seconds: 3));
    yield data.last;
  }

  final TextEditingController _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  /// для передачи / снятия фокуса по тапам и через клавиатуру
  FocusNode _currentFocus;

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();

    _searchController.dispose();
    _searchFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _currentFocus = _searchFocus;

    /// составляем поисковые запросы из целых слов
    /// если после слова есть пробел, то слово целое и можно отправлять запрос
    _writeRequest(
      data: _baseQuery,
      controller: _searchController,
      focus: _currentFocus,
    );

    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: _stream(_baseQuery),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              List<Widget> children;
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Center(
                    child: Text('Не найдено'),
                  );
                  break;
                case ConnectionState.waiting:
                  return Center(
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        SizedBox(
                          child: const CircularProgressIndicator(),
                          width: 40,
                          height: 40,
                        ),
                        SizedBox(height: 10),
                        Text('Загрузка...'),
                      ],
                    ),
                  );
                  break;
                case ConnectionState.active:
                  return Center(
                    child: Text('${snapshot.data}'),
                  );
                  break;
                case ConnectionState.done:
                  return Center(
                    child: Text('${snapshot.data} (готово)'),
                  );
                  break;
              }

              return null;
            }),
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
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      appBarTitle,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  sizedBoxH24,
                  SearchBar(
                    controller: _searchController,
                    focus: _searchFocus,
                    onEditingComplete: _searchOnEditingComplete,
                    onTap: _searchOnTap,
                    data: _baseQuery,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  /// считаем количество пробелов в строке чтобы определить, что было введено
  /// целое слово
  int _countSpaces(String str) {
    int spaces = 0;
    for (int i = 0; i < str.length; i++)
      if (str[i] == ' ') {
        spaces++;
      }

    return spaces;
  }

  /// записать поисковое выражение для поиска
  void _writeRequest(
      {List<String> data, TextEditingController controller, FocusNode focus}) {
    if (controller.text.isNotEmpty && controller.text.length > 2) {
      int numberOfSpaces = _countSpaces(controller.text);

      if (focus == _searchFocus) {
        if (data.length < numberOfSpaces) {
          data.add('${controller.text.trim()}');
          print(data);
        }
      } else {
        if (data.length == numberOfSpaces) {
        data.add('${controller.text.trim()}');
        print(data);
        }
      }
    }
  }

  /// клик по кнопке клавиатуры - завершение редактирования
   _searchOnEditingComplete() {
    _searchFocus.unfocus();
    _currentFocus = null;

    _writeRequest(
      data: _baseQuery,
      controller: _searchController,
      focus: _currentFocus,
    );
  }

  /// клик по полю поиска
   _searchOnTap() {
    FocusScope.of(context).requestFocus(_searchFocus);
    setState(() {
      _currentFocus = _searchFocus;
    });
  }
}
