import 'package:cardio_flutter/core/input_validators/base_input_validator.dart';
import 'package:cardio_flutter/resources/strings.dart';

class EmailInputValidator extends BaseInputValidator {
  @override
  // 1. Mudamos para String? no retorno e no parâmetro
  String? validate(String? value) {
    // 2. Se for nulo ou vazio, consideramos válido (ou trate conforme sua regra)
    if (value == null || value.isEmpty) return null;

    // 3. O RegExp continua igual, mas o Dart agora sabe que 'value' não é nulo aqui
    if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(value)) {
      return Strings.email_format_error_message;
    }

    return null;
  }
}