import 'package:cardio_flutter/core/utils/converter.dart';
import 'package:cardio_flutter/features/medications/domain/entities/medication.dart';

class MedicationModel extends Medication {
  MedicationModel({
    required super.name,
    required super.dosage,
    required super.quantity,
    required super.frequency,
    required super.initialDate,
    required super.finalDate,
    required super.observation,
    required super.times,
    required super.tookIt,
    required super.id,
    required super.done,
    super.executedDate, // Opcional vindo da BaseEntity
  });

  // 1. Mudança para método de instância (removido static)
  Map<dynamic, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
      'quantity': quantity,
      'frequency': frequency,
      'initialDate': initialDate.millisecondsSinceEpoch,
      'finalDate': finalDate.millisecondsSinceEpoch,
      // Usamos ?. pois executedDate pode ser nulo antes de ser realizado
      'executedDate': executedDate?.millisecondsSinceEpoch,
      'observation': observation,
      'tookIt': tookIt,
      'id': id,
      'done': done,
      'times': times,
    };
  }

  factory MedicationModel.fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) throw Exception("JSON de Medicamento nulo");

    return MedicationModel(
      name: json['name'] ?? "",
      dosage: (json['dosage'] as num?)?.toDouble() ?? 0.0,
      frequency: json['frequency'] ?? 0,
      quantity: json['quantity'] ?? "",
      initialDate: (json['initialDate'] == null)
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(json['initialDate']),
      finalDate: (json['finalDate'] == null)
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(json['finalDate']),
      executedDate: (json['executedDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['executedDate']),
      observation: json['observation'] ?? "",
      tookIt: json['tookIt'] ?? false,
      id: json['id'] ?? "",
      done: json['done'] ?? false,
      times: Converter.convertListDynamicToListString(json['times']) ?? [],
    );
  }

  // 2. Mudado para static retornando opcional para evitar erro de 'Null'
  static MedicationModel? fromEntity(Medication? medication) {
    if (medication == null) return null;
    return MedicationModel(
        name: medication.name ?? "",
        dosage: medication.dosage ?? 0.0,
        frequency: medication.frequency ?? 0,
        quantity: medication.quantity ?? "",
        initialDate: medication.initialDate ?? DateTime.now(),
        finalDate: medication.finalDate ?? DateTime.now(),
        executedDate: medication.executedDate,
        observation: medication.observation ?? "",
        tookIt: medication.tookIt ?? false,
        times: medication.times ?? [],
        id: medication.id ?? "",
        done: medication.done);
  }
}