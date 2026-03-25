import '../../resources/strings.dart';
import 'base_input_validator.dart';

class TimeOfDayValidator extends BaseInputValidator {
  @override
  // 1. Ajuste de assinatura para bater com o pai (String? -> String?)
  String? validate(String? value) {
    // 2. Se o campo estiver vazio, não validamos hora (o EmptyInputValidator cuida disso se for obrigatório)
    if (value == null || value.isEmpty) return null;

    if (value.length != 5) return Strings.invalid_time_error_message;

    // 3. int.tryParse agora retorna int?, então usamos 'final' ou 'int?'
    final hour = int.tryParse(value.substring(0, 2));
    final minute = int.tryParse(value.substring(3, 5));

    // 4. Se a conversão falhar (null) ou os valores forem inválidos, erro.
    if (hour == null || hour < 0 || hour > 23) {
      return Strings.invalid_time_error_message;
    }
    
    if (minute == null || minute < 0 || minute > 59) {
      return Strings.invalid_time_error_message;
    }

    return null;
  }
}