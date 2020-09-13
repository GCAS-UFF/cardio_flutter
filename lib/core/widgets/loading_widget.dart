import 'package:cardio_flutter/resources/cardio_colors.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final baseWidget;
  final double size;
  final double strokeWidth;
  final Color color;

  LoadingWidget(
    this.baseWidget, {
    this.size = 20,
    this.strokeWidth = 5,
    this.color = CardioColors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: Dimensions.getConvertedHeightSize(context, size),
        width: Dimensions.getConvertedHeightSize(context, size),
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: AlwaysStoppedAnimation(color),
        ),
      ),
    );
  }
}
