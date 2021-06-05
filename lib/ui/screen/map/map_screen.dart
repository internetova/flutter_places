import 'package:flutter/material.dart';
import 'package:places/ui/components/bottom_navigationbar.dart';
import 'package:places/ui/components/search_bar_static.dart';
import 'package:places/ui/res/sizes.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/screen/map/widgets/bottom_map_buttons.dart';

/// экран с яндекс картой
class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _BuildAppBar(),
      body: Container(),
      floatingActionButton: BottomMapButtons(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: const MainBottomNavigationBar(current: 1),
    );
  }
}

/// AppBar
class _BuildAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                mapAppBarTitle,
                style: Theme.of(context).textTheme.headline6,
              ),
              sizedBoxH24,
              SearchBarStatic(
                onTapSearch: () {},
                onPressedFilter: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// вернуться на предыдущий экран
  void _back(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Size get preferredSize => Size.fromHeight(132);
}
