import 'package:flutter/material.dart';

import 'package:places/constant.dart';
import 'package:places/domain/sight.dart';

class SightCard extends StatelessWidget {
  const SightCard({Key key, this.card}) : super(key: key);
  final Sight card;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: colorBackground,
          child: Column(
            children: [
              Stack(
                children: [
                  CardImagePreview(imgUrl: card.imgPreview),
                  CardContentType(type: card.type),
                ],
              ),
              CardContent(card: card),
            ],
          ),
        ),
      ),
    );
  }
}

class CardImagePreview extends StatelessWidget {
  const CardImagePreview({Key key, this.imgUrl}) : super(key: key);
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 96,
      child: Image.network(
        imgUrl,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes
                  : null,
            ),
          );
        },
      ),
    );
  }
}

class CardContentType extends StatelessWidget {
  const CardContentType({Key key, this.type}) : super(key: key);
  final String type;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            type,
            style: textStyleSmall14BoldWhite,
          ),
          Icon(
            Icons.favorite_border,
            color: Colors.white,
            size: 24,
          ),
        ],
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  const CardContent({Key key, this.card}) : super(key: key);
  final Sight card;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            card.name,
            style: textStyleText16Secondary,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            card.details,
            style: textStyleSmall14Secondary2,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
