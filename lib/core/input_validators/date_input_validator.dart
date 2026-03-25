import '../../resources/strings.dart';
import 'base_input_validator.dart';

class DateInputValidator extends BaseInputValidator {
  @override
  // 1. Ajustado para String? tanto no retorno quanto no parâmetro
  String? validate(String? value) {
    // 2. Se for nulo ou vazio, consideramos válido (ou tratamos conforme a regra de negócio)
    if (value == null || value.isEmpty) return null;

    if (value.length != 10) return Strings.invalid_date_error_message;

    // 3. Usamos 'final' ou 'int?' porque o tryParse pode falhar e retornar null
    final day = int.tryParse(value.substring(0, 2));
    final month = int.tryParse(value.substring(3, 5));
    final year = int.tryParse(value.substring(6, 10));

    // 4. O Dart faz o "Type Promotion": se checarmos se é null, 
    // dentro do IF ele já sabe que o valor é um int válido.
    if (day == null || day <= 0 || day > 31) {
      return Strings.invalid_day_error_message;
    }
    
    if (month == null || month <= 0 || month > 12) {
      return Strings.invalid_month_error_message;
    }

    if (year == null || year <= 0 || year > DateTime.now().year) {
      return Strings.invalid_year_error_message;
    }

    return null;
  }
}