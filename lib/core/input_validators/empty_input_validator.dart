import 'package:cardio_flutter/core/input_validators/base_input_validator.dart';
import 'package:cardio_flutter/resources/strings.dart';

class EmptyInputValidator extends BaseInputValidator {
  @override
  String validate(String value) {
    if (value == null || value.isEmpty) return Strings.empty_fild_message;

    return null;
  }
}
