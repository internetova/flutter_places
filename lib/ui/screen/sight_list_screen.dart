import 'package:flutter/material.dart';

import 'package:places/domain/sight.dart';
import 'package:places/mocks.dart';
import 'package:places/ui/screen/filters_screen.dart';
import 'package:places/ui/screen/res/themes.dart';
import 'package:places/ui/screen/add_sight_screen.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/sight_card.dart';
import 'package:places/components/icon_svg.dart';
import 'package:places/components/search_bar_static.dart';
import 'package:places/components/bottom_navigationbar.dart';
import 'package:places/ui/screen/sight_search_screen.dart';
import 'package:places/ui/screen/utilities/filter_utility.dart';

/// константы экрана
const _buttonTitleAddNewCard = 'НОВОЕ МЕСТО';
const double _widthButton = 177;
const double _radiusButton = 24;

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
    if (_currentFilter != null)
    print('_onPressed фильтр ${_currentFilter.distance} ${_currentFilter.centerPoint.name}  ${_currentFilter.categories}');

    return Scaffold(
      appBar: _buildAppBar(),
      body: BuildCardScreen(
        data: _filteredData.isNotEmpty ? _filteredData : _fullData,
        whereShowCard: WhereShowCard.search,
      ),
      floatingActionButton: _buildAddNewCard(),
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
                    onTapSearch: () {
                      // _getFilteredResultFromFiltersScreen(context);
                      print('onTapSearch');
                    },
                      onPressedFilter: () {
                        _onPressedFilter();
                      }
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  /// кнопка добавить новое место
  Widget _buildAddNewCard() => FlatButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddSightScreen(),
            ),
          );
        },
        child: Container(
          width: _widthButton,
          height: heightBigButton,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(_radiusButton),
            ),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.yellow,
                Theme.of(context).colorScheme.green,
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconSvg(icon: icPlus),
              sizedBoxW8,
              Text(
                _buttonTitleAddNewCard,
                style: Theme.of(context).textTheme.button,
              ),
            ],
          ),
        ),
      );

  /// получаем отфильтрованные результаты из экрана с фильтром
  void _getFilteredResultFromFiltersScreen(BuildContext context) async {
    final FilterSettings filter = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SightSearchScreen(),
      ),
    );
    setState(() {
      _currentFilter = filter;
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
