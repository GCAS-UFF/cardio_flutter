import 'package:cardio_flutter/features/generic_feature/domain/entities/base_entity.dart';
import 'package:meta/meta.dart';

class Biometric extends BaseEntity {
  final int frequency;
  final int weight;
  final int bpm;
  final String bloodPressure;
  final String swelling;
  final String swellingLocalization;
  final String fatigue;
  final String observation;

  Biometric({
    this.fatigue,
    this.weight,
    this.observation,
    this.swellingLocalization,
    this.bpm,
    this.bloodPressure,
    this.swelling,
    id,
    this.frequency,
    initialDate,
    finalDate,
    executedDate,
    @required done,
  }) : super(
            id: id,
            initialDate: initialDate,
            finalDate: finalDate,
            done: done,
            executedDate: executedDate);

  @override
  List<Object> get props => [
        fatigue,
        weight,
        bpm,
        observation,
        bloodPressure,
        swelling,
        swellingLocalization,
        id,
        frequency,
        initialDate,
        finalDate,
        executedDate,
        done,
      ];
}
