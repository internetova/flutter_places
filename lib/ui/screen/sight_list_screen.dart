import 'package:flutter/material.dart';
import 'package:places/components/icon_svg.dart';

import 'package:places/domain/sight.dart';
import 'package:places/mocks.dart';
import 'package:places/ui/screen/res/themes.dart';
import 'package:places/ui/screen/add_sight_screen.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/sight_card.dart';
import 'package:places/components/bottom_navigationbar.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(152),
        child: AppBar(
          flexibleSpace: Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Text(
                appBarTitle,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
          ),
        ),
      ),
      body: BuildCardScreen(
        data: mocks,
        whereShowCard: WhereShowCard.search,
      ),
      floatingActionButton: _buildAddNewCard(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: const MainBottomNavigationBar(current: 0),
    );
  }

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
}
