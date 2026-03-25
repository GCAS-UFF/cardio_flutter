import 'package:cardio_flutter/core/input_validators/base_input_validator.dart';
import 'package:cardio_flutter/resources/strings.dart';

class EmptyInputValidator extends BaseInputValidator {
  @override
  // 1. Ajustado para aceitar nulo e retornar nulo (String?)
  String? validate(String? value) {
    // 2. Agora o 'value == null' faz sentido para o Dart
    if (value == null || value.isEmpty) {
      return Strings.empty_fild_message; 
    }

    return null;
  }
}