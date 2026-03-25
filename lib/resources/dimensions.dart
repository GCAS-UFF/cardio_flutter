import 'package:flutter/material.dart';

class Dimensions {
  static final double baseScreenHeight = 592.0;
  static final double baseScreenWidth = 360.0;

  // 1. Mudamos para double? para permitir que o programador passe nulo se quiser
  static double getConvertedHeightSize(
      BuildContext context, double? sizeInPixel) {
    MediaQueryData queryData = MediaQuery.of(context);
    double currentScreenHeight = queryData.size.height;
    
    // 2. Usamos o operador ?? para garantir que se for nulo, vire 0.0
    double size = sizeInPixel ?? 0.0;

    return (size * currentScreenHeight) / baseScreenHeight;
  }

  static double getConvertedWidthSize(
      BuildContext context, double? sizeInPixel) {
    MediaQueryData queryData = MediaQuery.of(context);
    double currentScreenWidth = queryData.size.width;

    double size = sizeInPixel ?? 0.0;

    return (size * currentScreenWidth) / baseScreenWidth;
  }

  // 3. Adicionamos valores padrão (= 0) para os parâmetros nomeados
  static EdgeInsets getEdgeInsets(BuildContext context,
      {double top = 0, double bottom = 0, double left = 0, double right = 0}) {
    return EdgeInsets.only(
        top: getConvertedHeightSize(context, top),
        bottom: getConvertedHeightSize(context, bottom),
        left: getConvertedWidthSize(context, left),
        right: getConvertedWidthSize(context, right));
  }

  // Nome corrigido para Symmetric
  static EdgeInsets getEdgeInsetsSymmetric(BuildContext context,
      {double vertical = 0, double horizontal = 0}) {
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