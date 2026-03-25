import 'package:cardio_flutter/core/input_validators/base_input_validator.dart';

class CpfInputValidator extends BaseInputValidator {
  final List<String> _cpfBlacklist = [
    "00000000000", "11111111111", "22222222222", "33333333333", "44444444444",
    "55555555555", "66666666666", "77777777777", "88888888888", "99999999999"
  ];

  @override
  // 1. Mudamos para String? (com interrogação) porque o validador retorna null quando está TUDO CERTO.
  // 2. O parâmetro cpf também pode ser nulo vindo do formulário.
  String? validate(String? cpf) {
    if (cpf == null || cpf.isEmpty) return null;

    final cleanedCpf = _cleanCpf(cpf);
    String error = "CPF inválido";

    if (cleanedCpf.length != 11) return error;
    if (_cpfBlacklist.contains(cleanedCpf)) return error;
    if (!_validateDigit(cleanedCpf, 10)) return error;
    if (!_validateDigit(cleanedCpf, 11)) return error;

    return null;
  }

  String _cleanCpf(String cpf) {
    // Como já checamos null no validate, aqui o cpf já vem garantido.
    return cpf.replaceAll(".", "").replaceAll("-", "");
  }

  List<int> _convertCPFStringToIntArray(String cpf) {
    // 3. 'new List(11)' não existe mais. Usamos List.filled.
    List<int> cpfIntArray = List<int>.filled(11, 0);

    for (int i = 1; i < 12; i++) {
      cpfIntArray[i - 1] = int.parse(cpf.substring(i - 1, i));
    }
    return cpfIntArray;
  }

  bool _validateDigit(String cpf, int digitNumber) {
    List<int> cpfDigits = _convertCPFStringToIntArray(cpf);
    // 4. Novamente, corrigindo o construtor da List.
    List<int> sumProductDigits = List<int>.filled(digitNumber - 1, 0);

    int weight = digitNumber;

    for (int i = 0; i < (sumProductDigits.length); i++) {
      sumProductDigits[i] = cpfDigits[i] * weight;
      weight--;
    }

    int dvForDigit = _sumAll(sumProductDigits) % 11;
    dvForDigit = 11 - dvForDigit;

    if (dvForDigit > 9) dvForDigit = 0;

    return (dvForDigit == cpfDigits[digitNumber - 1]);
  }

  int _sumAll(List<int> list) {
    int total = 0;
    for (int i = 0; i < list.length; i++) {
      total = total + list[i];
    }
    return total;
  }
}