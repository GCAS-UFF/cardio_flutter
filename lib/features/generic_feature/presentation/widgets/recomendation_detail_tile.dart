import 'package:flutter/material.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/cardio_colors.dart';

class RecomendationDetailTile extends StatelessWidget {
  final String title;
  final String content;
  const RecomendationDetailTile({
    Key key,
    this.title = "Título: ",
    this.content = "conteúdo",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Dimensions.getEdgeInsets(context, left: 15, top: 10, bottom: 10),
      width: double.infinity,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: CardioColors.grey_05,
            width: Dimensions.getConvertedHeightSize(context, 1),
          ),
        ),
      ),
      child: Text.rich(
        TextSpan(
          style: TextStyle(
            fontSize: Dimensions.getTextSize(context, 16),
            fontWeight: FontWeight.normal,
            color: CardioColors.black,
          ),
          children: <TextSpan>[
            TextSpan(
              text: title,
            ),
            TextSpan(
              text: content, //"06:00, 14:00, 22:00",
              style: TextStyle(
                fontSize: Dimensions.getTextSize(context, 16),
                fontWeight: FontWeight.bold,
                color: CardioColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
