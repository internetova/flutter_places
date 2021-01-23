import 'package:flutter/material.dart';

import 'package:places/domain/sight.dart';
import 'package:places/mocks.dart';
import 'package:places/ui/screen/components/button_gradient.dart';
import 'package:places/ui/screen/filters_screen.dart';
import 'package:places/ui/screen/res/themes.dart';
import 'package:places/ui/screen/add_sight_screen.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/widgets/list_cards.dart';
import 'package:places/ui/screen/widgets/sight_card.dart';
import 'package:places/ui/screen/components/icon_svg.dart';
import 'package:places/ui/screen/components/search_bar_static.dart';
import 'package:places/ui/screen/components/bottom_navigationbar.dart';
import 'package:places/ui/screen/sight_search_screen.dart';
import 'package:places/ui/screen/utilities/filter_utility.dart';

/// список интересных мест
class SightListScreen extends StatefulWidget {
  @override
  _SightListScreenState createState() => _SightListScreenState();
}

class _SightListScreenState extends State<SightListScreen> {
  /// нефильтрованные данные если юзер не настраивал фильтр
  final List<Sight> _fullData = mocks;

  /// текущие настройки фильтра, получаем их из экрана фильтрации
  FilterSettings _currentFilter;

  /// отфильтрованные данные
  List<Sight> _filteredData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0),
        child: ListCards(
          data: _filteredData.isNotEmpty ? _filteredData : _fullData,
          whereShowCard: WhereShowCard.search,
        ),
      ),
      floatingActionButton: ButtonGradient(onPressed: _onPressedAddNewCard),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: const MainBottomNavigationBar(current: 0),
    );
  }

  /// ‼️ appBar - пока так, потом наверное через сливеры (учебный раздел 6)
  Widget _buildAppBar() => PreferredSize(
        preferredSize: Size.fromHeight(212),
        child: AppBar(
          flexibleSpace: Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appBarTitle,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  sizedBoxH24,
                  SearchBarStatic(
                    onTapSearch: _onTapSearch,
                    onPressedFilter: _onPressedFilter,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  /// нажатие на градиентную кнопку - переходим на экран добавления
  void _onPressedAddNewCard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSightScreen(),
      ),
    );
  }

  /// передаем фильтр на экран поиска
  void _onTapSearch() async {
    final FilterSettings _filter = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SightSearchScreen(filter: _currentFilter),
      ),
    );
    setState(() {
      _currentFilter = _filter;
      _filteredData = filterData(
          data: _fullData,
          categories: _currentFilter.categories,
          centerPoint: _currentFilter.centerPoint,
          distance: _currentFilter.distance);
    });
  }

  /// переход на экран фильтра
  /// настройки фильтра возвращаем сюда и фильтруем данные
  _onPressedFilter() async {
    final FilterSettings _filter = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FiltersScreen(filter: _currentFilter),
      ),
    );
    setState(() {
      _currentFilter = _filter;
      _filteredData = filterData(
          data: _fullData,
          categories: _currentFilter.categories,
          centerPoint: _currentFilter.centerPoint,
          distance: _currentFilter.distance);
    });
  }
}
