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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Center(child: Text('Завтра начну')),
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
              SearchBar(),
            ],
          ),
        ),
      ),
    ),
  );
}
