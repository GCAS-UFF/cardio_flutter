import 'package:cardio_flutter/features/generic_feature/domain/entities/base_entity.dart';

class Medication extends BaseEntity {
  // 1. Campos marcados com '?' para permitir que sejam nulos (opcionais)
  final String? name;
  final double? dosage;
  final String? quantity;
  final List<String>? times;
  final int? frequency;
  final String? observation;
  final bool? tookIt;

  Medication({
    this.name,
    this.dosage,
    this.quantity,
    this.frequency,
    this.times,
    this.observation,
    this.tookIt,
    super.id,
    required super.initialDate, // Assumindo que datas são obrigatórias na sua BaseEntity
    required super.finalDate,
    super.executedDate,
    required super.done,
  });

  @override
  // 2. Mudado para List<Object?> para aceitar campos nuláveis na comparação
  List<Object?> get props => [
        observation,
        name,
        dosage,
        quantity,
        frequency,
        initialDate,
        times,
        finalDate,
        executedDate,
        tookIt,
        id,
        done,
      ];
}