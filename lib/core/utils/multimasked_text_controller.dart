import 'package:cardio_flutter/core/utils/converter.dart';
import 'package:flutter/material.dart';

class MultimaskedTextController {
  final String maskDefault;
  final String maskSecundary;
  final Function changeMask;
  final String escapeCharacter;
  final bool onlyDigitsDefault;
  final bool onlyDigitsSecundary;

  var lastTextSize = 0;
  var mask;

  TextEditingController _maskedTextFieldController;

  TextEditingController get maskedTextFieldController =>
      _maskedTextFieldController;

  MultimaskedTextController(
      {@required this.maskDefault,
      this.maskSecundary,
      this.changeMask,
      this.escapeCharacter: "x",
      this.onlyDigitsDefault = false,
      this.onlyDigitsSecundary = false}) {
    this._maskedTextFieldController = new TextEditingController();
    _maskedTextFieldController.addListener(onChanged);
  }

  void onChanged() {
    String text = _maskedTextFieldController.text;
    bool change = (changeMask == null) ? false : changeMask(text);
    mask = change ? maskSecundary : maskDefault;
    if (mask == null) return;
    if (text.length <= lastTextSize) {
      lastTextSize = text.length;
      return;
    } else {
      String newText = _buildText(text);
      lastTextSize = newText.length;
     _maskedTextFieldController.value =
          _maskedTextFieldController.value.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
        composing: TextRange.empty,
      );
    }
  }

  String _buildText(String text) {
    bool change = (changeMask == null) ? false : changeMask(text);
    bool onlyDigits = change ? onlyDigitsSecundary : onlyDigitsDefault;

    return Converter.convertStringToMultimaskedString(
        value: text,
        maskDefault: maskDefault,
        maskSecundary: maskSecundary,
        changeMask: changeMask,
        onlyDigits: onlyDigits);
  }
}
