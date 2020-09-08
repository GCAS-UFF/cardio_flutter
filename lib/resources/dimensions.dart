import 'package:flutter/material.dart';

class Dimensions {
  //The height size of the base screen.
  //The base screen is the screen of the cellphone using to define the designs
  static final double baseScreenHeight = 592.0;
  //The width size of the base screen.
  //The base screen is the screen of the tablet using to define the designs
  static final double baseScreenWidth = 360.0;

  static double getConvertedHeightSize(
      BuildContext context, double sizeInPixel) {
    //Getting the current screen height
    MediaQueryData queryData = MediaQuery.of(context);
    double currentScreenHeight = queryData.size.height;
    if (sizeInPixel == null) sizeInPixel = 0.0;

    //Expression to get the current height proportion
    return (sizeInPixel * (currentScreenHeight)) / baseScreenHeight;
  }

  static double getConvertedWidthSize(
      BuildContext context, double sizeInPixel) {
    //Getting the current screen width
    MediaQueryData queryData = MediaQuery.of(context);
    double currentScreenWidth = queryData.size.width;

    if (sizeInPixel == null) sizeInPixel = 0.0;

    //Expression to get the current width proportion
    return (sizeInPixel * (currentScreenWidth)) / baseScreenWidth;
  }

  static EdgeInsets getEdgeInsets(BuildContext context,
      {double top, double bottom, double left, double right}) {
    return EdgeInsets.only(
        top: getConvertedHeightSize(context, top),
        bottom: getConvertedHeightSize(context, bottom),
        left: getConvertedWidthSize(context, left),
        right: getConvertedWidthSize(context, right));
  }

  static EdgeInsets getEdgeInsetsSymetric(BuildContext context,
      {double vertical, double horizontal}) {
    return EdgeInsets.symmetric(
      vertical: getConvertedHeightSize(context, vertical),
      horizontal: getConvertedWidthSize(context, horizontal),
    );
  }

  static EdgeInsets getEdgeInsetsAll(BuildContext context, double size) {
    return EdgeInsets.only(
        top: getConvertedHeightSize(context, size),
        bottom: getConvertedHeightSize(context, size),
        left: getConvertedWidthSize(context, size),
        right: getConvertedWidthSize(context, size));
  }

  static EdgeInsets getEdgeInsetsFromLTRB(BuildContext context, double left,
      double top, double right, double bottom) {
    return EdgeInsets.fromLTRB(
        getConvertedWidthSize(context, left),
        getConvertedHeightSize(context, top),
        getConvertedWidthSize(context, right),
        getConvertedHeightSize(context, bottom));
  }

  static double getTextSize(BuildContext context, double sizeInPixel) {
    return getConvertedHeightSize(context, sizeInPixel);
  }
}
