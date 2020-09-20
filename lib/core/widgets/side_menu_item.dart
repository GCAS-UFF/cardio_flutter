import 'package:cardio_flutter/resources/cardio_colors.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:flutter/material.dart';

class SideMenuItem extends StatelessWidget {
  final String text;
  final Function onTapFunction;
  const SideMenuItem({
    Key key,
    @required this.text = "SideMenuItem",
    @required this.onTapFunction = _print,
  }) : super(key: key);

  static _print() {
    print("SideMenuItem");
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: Dimensions.getEdgeInsets(context, left: 5, right: 5),
        padding: Dimensions.getEdgeInsets(
          context,
          left: 15,
          top: 15,
          bottom: 15,
        ),
        decoration: BoxDecoration(
          color: CardioColors.grey_01,
          border: Border(
            bottom: BorderSide(
              color: CardioColors.black,
              width: Dimensions.getConvertedHeightSize(context, 1),
            ),
          ),
        ),
        width: double.infinity,
        child: Text(
          text,
          style: TextStyle(
            fontSize: Dimensions.getTextSize(context, 20),
            fontWeight: FontWeight.w500,
            color: CardioColors.black,
          ),
        ),
      ),
      onTap: onTapFunction,
    );
  }
}
