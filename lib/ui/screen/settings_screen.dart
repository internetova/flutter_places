import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/components/bottom_NavigationBar.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/res/themes.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: titleScreenSettings,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Consumer<ThemeNotifier>(
                builder: (context, notifier, child) => SwitchListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  activeColor: Theme.of(context).colorScheme.white,
                  activeTrackColor: Theme.of(context).accentColor,
                  inactiveThumbColor: Theme.of(context).colorScheme.white,
                  inactiveTrackColor: Theme.of(context).colorScheme.background,
                  title: Text(
                    itemThemeDark,
                    style: Theme.of(context).primaryTextTheme.subtitle1,
                  ),
                  value: notifier.darkTheme,
                  onChanged: (currentValue) {
                    notifier.toggleTheme();
                  },
                ),
              ),
              Divider(),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                title: Text(
                  itemTutorial,
                  style: Theme.of(context).primaryTextTheme.subtitle1,
                ),
                trailing: IconButton(
                    icon: SvgPicture.asset(icInfo,
                        color: Theme.of(context).accentColor),
                    onPressed: () {
                      print('onPressed Туториал');
                    }),
              ),
              Divider(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MainBottomNavigationBar(current: 3),
    );
  }
}
