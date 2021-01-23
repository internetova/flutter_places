import 'dart:io';

import 'package:flutter/material.dart';
import 'package:places/domain/sight.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/widgets/sight_card.dart';

/// строим часть экрана где выводятся карточки
/// в конструкторе база данных карточек и параметр Где (в каком разделе) выводится
/// карточка, т.к. от него зависит внутреннее наполнение карточки
/// этот для главной страницы
class ListCards extends StatelessWidget {
  final List<Sight> data;
  final WhereShowCard whereShowCard;

  const ListCards({
    Key key,
    @required this.data,
    @required this.whereShowCard,
  })  : assert(data != null),
        assert(whereShowCard != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => ListView.separated(
        physics: Platform.isAndroid
            ? ClampingScrollPhysics()
            : BouncingScrollPhysics(),
        itemCount: data.length,
        itemBuilder: _buildCardItem,
        separatorBuilder: _buildSeparatorItem,
      );

  Widget _buildCardItem(BuildContext context, int index) => SightCard(
        card: data[index],
        whereShowCard: whereShowCard,
      );

  Widget _buildSeparatorItem(BuildContext context, int index) => sizedBoxH16;
}
