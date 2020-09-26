import 'package:cardio_flutter/resources/cardio_colors.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {
  final String text;

  const EmptyPage({@required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Dimensions.getEdgeInsetsSymetric(context, horizontal: 40),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: Dimensions.getTextSize(context, 22),
          fontWeight: FontWeight.bold,
          color: CardioColors.blue,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
