import 'package:cardio_flutter/features/generic_feature/domain/entities/base_entity.dart';
import 'package:meta/meta.dart';

class Medication extends BaseEntity {
  final String name;
  final String dosage;
  final String quantity;
  final List<String> times;
  final int frequency;
  final String observation;
  final bool tookIt;

  Medication({
    @required this.name,
    @required this.dosage,
    @required this.quantity,
    this.frequency,
    initialDate,
    this.times,
    finalDate,
    executedDate,
    this.observation,
    this.tookIt,
    id,
    @required done,
  }) : super(
          initialDate: initialDate,
          finalDate: finalDate,
          executedDate: executedDate,
          id: id,
          done: done,
        );

  @override
  List<Object> get props => [
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
