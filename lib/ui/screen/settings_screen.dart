import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/blocs/onboarding_screen/onboarding_cubit.dart';
import 'package:places/blocs/settings_app/settings_app_cubit.dart';
import 'package:places/ui/screen/components/bottom_navigationbar.dart';
import 'package:places/ui/screen/onboarding_screen.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/res/themes.dart';
import 'package:provider/provider.dart';

/// экран с настройками приложения
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: titleScreenSettings,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildThemeMode(),
              Divider(),
              _buildTutorial(context),
              Divider(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MainBottomNavigationBar(current: 3),
    );
  }

  /// Тёмная тема
  Widget _buildThemeMode() {
    return BlocBuilder<SettingsAppCubit, SettingsAppState>(
      builder: (context, state) {
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          title: Text(
            itemThemeDark,
            style: Theme.of(context).primaryTextTheme.subtitle1,
          ),
          trailing: CupertinoSwitch(
              trackColor: Theme.of(context).colorScheme.inactiveBlack,
              value: state.isDark,
              onChanged: (currentValue) {
                context.read<SettingsAppCubit>().toggleTheme(currentValue);
              }),
        );
      },
    );
  }

  /// Смотреть туториал
  Widget _buildTutorial(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      title: Text(
        itemTutorial,
        style: Theme.of(context).primaryTextTheme.subtitle1,
      ),
      trailing: IconButton(
          icon: SvgPicture.asset(
            icInfo,
            color: Theme.of(context).accentColor,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => BlocProvider<OnboardingCubit>(
                  create: (_) => OnboardingCubit(),
                  child: OnboardingScreen(),
                ),
              ),
            );
          }),
    );
  }
}
