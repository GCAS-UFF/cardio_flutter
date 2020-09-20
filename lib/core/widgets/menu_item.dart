import 'package:cardio_flutter/resources/cardio_colors.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:cardio_flutter/resources/images.dart';

class ItemMenu extends StatelessWidget {
  final String text;
  final String image;
  final Function destination;

  const ItemMenu(
      {Key key, this.text = "", this.image = Images.app_logo, this.destination})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: Dimensions.getEdgeInsets(context, left: 25, right: 25),
      margin: Dimensions.getEdgeInsets(context, bottom: 20),
      child: InkWell(
        onTap: destination,
        child: Container(
          decoration: BoxDecoration(
            color: CardioColors.grey_01,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: CardioColors.black,
              width: Dimensions.getConvertedHeightSize(context, 1),
            ),
          ),
          padding: Dimensions.getEdgeInsets(
            context,
            left: 10,
            right: 10,
            top: 5,
            bottom: 5,
          ),
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Image.asset(
                image,
                height: Dimensions.getConvertedHeightSize(context, 45),
                width: Dimensions.getConvertedHeightSize(context, 45),
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: Dimensions.getTextSize(context, 25),
                  fontWeight: FontWeight.w500,
                  color: CardioColors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
