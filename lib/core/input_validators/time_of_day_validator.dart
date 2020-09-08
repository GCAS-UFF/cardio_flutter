import '../../resources/strings.dart';
import 'base_input_validator.dart';

class TimeofDayValidator extends BaseInputValidator {
  @override
  String validate(String value) {
    if (value != null && value.isNotEmpty) {
      if (value.length != 5) return Strings.invalid_time_error_message;

      int hour = int.tryParse(value.substring(0, 2));
      int minute = int.tryParse(value.substring(3, 5));

      if (hour == null || hour < 0 || hour > 23)
        return Strings.invalid_time_error_message;
      if (minute == null || minute < 0 || minute > 59)
        return Strings.invalid_time_error_message;
    }

    return null;
  }
}
