import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/ui/screen/components/button_save.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/res/themes.dart';

/// экран туториала
class OnboardingScreen extends StatefulWidget {
  /// для обновления значения текущей страницы при перелистывании
  static _OnboardingScreenState of(BuildContext context) =>
      context.findAncestorStateOfType<_OnboardingScreenState>();

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<TutorialItem> _data = _dataPages;
  int _currentPage;

  @override
  void initState() {
    _currentPage = 0;

    super.initState();
  }

  void updateState(int currentPage) {
    setState(() {
      _currentPage = currentPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: toolbarHeightStandard,
        actions: [
          _buttonSkip(_data, _currentPage),
        ],
      ),
      body: Stack(
        children: [
          TutorialList(
            data: _data,
          ),
          Positioned.fill(
            bottom: 100,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: PageSelector(
                data: _data,
                currentIndex: _currentPage,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buttonStart(_data, _currentPage),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,
    );
  }

  /// кнопка старт
  Widget _buttonStart(List<TutorialItem> data, int currentIndex) {
    if (currentIndex == data.length - 1) {
      return ButtonSave(
        title: tutorialButtonTitle,
        isButtonEnabled: true,
        onPressed: () {
          Navigator.of(context).pushReplacementNamed('/');
        },
      );
    }
    return SizedBox.shrink();
  }

  /// кнопка пропустить
  Widget _buttonSkip(List<TutorialItem> data, int currentIndex) {
    if (currentIndex < data.length - 1) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextButton(
          style: TextButton.styleFrom(
            primary: Theme.of(context).accentColor,
            textStyle: Theme.of(context).textTheme.headline5,
          ),
          onPressed: () {
            print('onPressed $tutorialButtonAppBarTitle');
          },
          child: Text(tutorialButtonAppBarTitle),
        ),
      );
    }
    return SizedBox.shrink();
  }
}

/// Контент страницы
class TutorialItem {
  final String icon;
  final String title;
  final String text;

  TutorialItem({
    @required this.icon,
    @required this.title,
    @required this.text,
  })  : assert(icon != null),
        assert(title != null),
        assert(text != null);
}

/// Список страниц с контентом
List<TutorialItem> _dataPages = [
  TutorialItem(
    icon: icPage1,
    title: 'Добро пожаловать\nв Путеводитель',
    text: 'Ищи новые локации и сохраняй\nсамые любимые.',
  ),
  TutorialItem(
    icon: icPage2,
    title: 'Построй маршрут\nи отправляйся в путь',
    text: 'Достигай цели максимально\nбыстро и комфортно.',
  ),
  TutorialItem(
    icon: icPage3,
    title: 'Добавляй места,\nкоторые нашёл сам',
    text: 'Делись самыми интересными\nи помоги нам стать лучше!',
  ),
];

/// виджет контента c индикатором страниц
class TutorialItemWidget extends StatelessWidget {
  final TutorialItem item;

  TutorialItemWidget({
    @required this.item,
  }) : assert(item != null);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            item.icon,
            width: 104,
            height: 104,
            color: Theme.of(context).colorScheme.primary,
          ),
          sizedBoxH40,
          Text(
            item.title,
            style: Theme.of(context).textTheme.headline4.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
            textAlign: TextAlign.center,
          ),
          sizedBoxH8,
          Text(
            item.text,
            style: Theme.of(context).textTheme.bodyText2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 140),
        ],
      ),
    );
  }
}

/// индикаторы страниц
class PageSelector extends StatelessWidget {
  final List<TutorialItem> data;
  final int currentIndex;

  const PageSelector({
    Key key,
    @required this.data,
    @required this.currentIndex,
  })  : assert(data != null),
        assert(currentIndex != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: data
          .asMap()
          .map(
            (i, element) => MapEntry(
              i,
              Container(
                margin: EdgeInsets.all(4),
                width: _getWidth(
                  context,
                  index: i,
                  currentIndex: currentIndex,
                ),
                height: 8,
                decoration: BoxDecoration(
                    color: _getColor(
                      context,
                      index: i,
                      currentIndex: currentIndex,
                    ),
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          )
          .values
          .toList(),
    );
  }

  /// цвет индикатора текущей страницы
  Color _getColor(BuildContext context, {int index, int currentIndex}) {
    if (index == currentIndex) {
      return Theme.of(context).accentColor;
    } else {
      return Theme.of(context).colorScheme.inactiveBlack;
    }
  }

  /// ширина индикатора текущей страницы
  double _getWidth(BuildContext context, {int index, int currentIndex}) {
    if (index == currentIndex) {
      return 24;
    } else {
      return 8;
    }
  }
}

/// список страниц туториала
class TutorialList extends StatelessWidget {
  final List<TutorialItem> data;
  final PageController _controller = PageController(initialPage: 0);

  TutorialList({
    Key key,
    @required this.data,
  })  : assert(data != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        onPageChanged: (value) {
          OnboardingScreen.of(context).updateState(value);
        },
        controller: _controller,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return TutorialItemWidget(
            item: data[index],
          );
        });
  }
}
