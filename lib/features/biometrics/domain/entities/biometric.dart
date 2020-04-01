import 'package:cardio_flutter/features/generic_feature/domain/entities/base_entity.dart';
import 'package:meta/meta.dart';

class Biometric extends BaseEntity {
  final int frequency;
  final int weight;
  final int bpm;
  final String bloodPressure;
  final String swelling;
  final String fatigue;

  Biometric({
    this.fatigue,
    this.weight,
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
        bloodPressure,
        swelling,
        id,
        frequency,
        initialDate,
        finalDate,
        executedDate,
        done,
      ];
}
