import 'package:cardio_flutter/core/utils/converter.dart';
import 'package:flutter/material.dart';

class MultimaskedTextController {
  final String maskDefault;
  final String? maskSecondary; // 1. Opcional, então precisa da ? e corrigi o nome
  final bool Function(String?)? changeMask; // 2. Tipagem correta para bater com o Converter
  final String escapeCharacter;
  final bool onlyDigitsDefault;
  final bool onlyDigitsSecondary;

  int lastTextSize = 0; // var -> int
  String? mask; // var -> String?

  // 3. 'late' avisa o Dart que vamos inicializar isso no construtor antes de usar
  late TextEditingController _maskedTextFieldController;

  TextEditingController get maskedTextFieldController =>
      _maskedTextFieldController;

  MultimaskedTextController({
    required this.maskDefault, // 4. @required -> required
    this.maskSecondary,
    this.changeMask,
    this.escapeCharacter = "x", // 5. Troquei ':' por '='
    this.onlyDigitsDefault = false,
    this.onlyDigitsSecondary = false,
  }) {
    _maskedTextFieldController = TextEditingController();
    _maskedTextFieldController.addListener(onChanged);
  }

  void onChanged() {
    String text = _maskedTextFieldController.text;
    
    // 6. Lógica de nulos para o changeMask
    bool change = (changeMask == null) ? false : changeMask!(text);
    mask = change ? maskSecondary : maskDefault;
    
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
    bool change = (changeMask == null) ? false : changeMask!(text);
    bool onlyDigits = change ? onlyDigitsSecondary : onlyDigitsDefault;

    return Converter.convertStringToMultimaskedString(
        value: text,
        maskDefault: maskDefault,
        maskSecondary: maskSecondary ?? maskDefault, // 7. Fallback caso a secundária seja null
        changeMask: changeMask,
        onlyDigits: onlyDigits,
        escapeCharacter: escapeCharacter);
  }
}