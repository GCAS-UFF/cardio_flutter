import '../../resources/strings.dart';
import 'base_input_validator.dart';

class DateInputValidator extends BaseInputValidator {
  @override
  String validate(String value) {
    if (value != null && value.isNotEmpty) {
      if (value.length != 10) return Strings.invalid_date_error_message;

      int day = int.tryParse(value.substring(0, 2));
      int mounth = int.tryParse(value.substring(3, 5));
      int year = int.tryParse(value.substring(6, 10));

      if (day == null || day <= 0 || day > 31)
        return Strings.invalid_day_error_message;
      if (mounth == null || mounth <= 0 || mounth > 12)
        return Strings.invalid_mounth_error_message;
      if (year == null || year <= 0) return Strings.invalid_year_error_message;
    }

    return null;
  }
}
