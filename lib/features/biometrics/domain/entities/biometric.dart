import 'package:cardio_flutter/features/generic_feature/domain/entities/base_entity.dart';

class Biometric extends BaseEntity {
  final int? frequency;
  final int? weight;
  final int? bpm;
  final String? bloodPressure;
  final String? swelling;
  final String? swellingLocalization;
  final String? fatigue;
  final List<String>? times;
  final String? observation;

  Biometric({
    this.fatigue,
    this.weight,
    this.observation,
    this.swellingLocalization,
    this.bpm,
    this.times,
    this.bloodPressure,
    this.swelling,
    this.frequency,
    // CAMPOS HERDADOS:
    super.id, // Opcional (String?)
    required super.initialDate, // ADICIONADO REQUIRED
    required super.finalDate,   // ADICIONADO REQUIRED
    super.executedDate,         // Opcional (DateTime?)
    required super.done,        // Obrigatório (bool)
  });

  @override
  // 2. List<Object?> permite que campos nulos (String?, int?) sejam comparados
  List<Object?> get props => [
        fatigue,
        weight,
        bpm,
        observation,
        bloodPressure,
        swelling,
        swellingLocalization,
        id,
        times,
        frequency,
        initialDate,
        finalDate,
        executedDate,
        done,
      ];
}