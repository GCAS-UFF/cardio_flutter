import 'package:cardio_flutter/core/input_validators/base_input_validator.dart';
import 'package:cardio_flutter/resources/strings.dart';

class EmailInputValidator extends BaseInputValidator {
  @override
  String validate(String value) {
    if (value != null && value.isNotEmpty) {
      if (!RegExp(
              r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
          .hasMatch(value)) {
        return Strings.email_format_error_message;
      }
    }

    return null;
  }
}
