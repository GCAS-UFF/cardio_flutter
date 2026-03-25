import 'package:cardio_flutter/core/utils/converter.dart';
import 'package:cardio_flutter/features/biometrics/domain/entities/biometric.dart';

class BiometricModel extends Biometric {
  BiometricModel({
    required super.frequency,
    required super.initialDate,
    required super.finalDate,
    super.executedDate, // Opcional na BaseEntity
    required super.done,
    required super.weight,
    required super.bpm,
    super.id,           // Opcional na BaseEntity
    required super.times,
    required super.observation,
    required super.bloodPressure,
    required super.swelling,
    required super.swellingLocalization,
    required super.fatigue,
  });

  Map<dynamic, dynamic> toJson() {
    return {
      'initialDate': initialDate.millisecondsSinceEpoch,
      'finalDate': finalDate.millisecondsSinceEpoch,
      'executedDate': executedDate?.millisecondsSinceEpoch,
      'frequency': frequency,
      'weight': weight,
      'bloodPressure': bloodPressure,
      'bpm': bpm,
      'swelling': swelling,
      'fatigue': fatigue,
      'observation': observation,
      'swellingLocalization': swellingLocalization,
      'times': times,
      'done': done,
      'id': id,
    };
  }

  factory BiometricModel.fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) throw Exception("JSON de Biometria nulo");

    return BiometricModel(
      frequency: json['frequency'] ?? 0,
      initialDate: (json['initialDate'] == null)
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(json['initialDate']),
      finalDate: (json['finalDate'] == null)
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(json['finalDate']),
      // 2. Aqui permitimos null se não houver data de execução
      executedDate: (json['executedDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['executedDate']),
      weight: json['weight'] ?? 0,
      bloodPressure: json['bloodPressure'] ?? "",
      bpm: json['bpm'] ?? 0,
      swelling: json['swelling'] ?? "",
      fatigue: json['fatigue'] ?? "",
      id: json['id'],
      done: json['done'] ?? false,
      observation: json['observation'] ?? "",
      swellingLocalization: json['swellingLocalization'] ?? "",
      // 3. Garantimos que a lista de horários nunca seja nula
      times: Converter.convertListDynamicToListString(json['times']) ?? [],
    );
  }

  // 4. Mudado para static para suportar retorno nulo se a entidade for nula
  static BiometricModel? fromEntity(Biometric? biometric) {
    if (biometric == null) return null;
    return BiometricModel(
      finalDate: biometric.finalDate,
      frequency: biometric.frequency,
      initialDate: biometric.initialDate,
      weight: biometric.weight,
      bloodPressure: biometric.bloodPressure,
      bpm: biometric.bpm,
      swelling: biometric.swelling,
      fatigue: biometric.fatigue,
      id: biometric.id,
      done: biometric.done,
      observation: biometric.observation,
      swellingLocalization: biometric.swellingLocalization,
      times: biometric.times,
      executedDate: biometric.executedDate,
    );
  }
}