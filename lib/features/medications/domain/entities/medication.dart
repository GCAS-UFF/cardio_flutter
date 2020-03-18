import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Medication extends Equatable {
  final String name;
  final String id;
  final double dosage;
  final int quantity;
  final int frequency;
  final DateTime initialDate;
  final DateTime finalDate;
  final DateTime initialTime;
  final String observation;
  final DateTime executionDay;
  final DateTime executionTime;
  final bool tookIt;

  Medication({
    this.executionTime,
    this.tookIt,
    this.id,
    this.executionDay,
    this.observation,
    @required this.name,
    @required this.dosage,
    @required this.quantity,
    @required this.frequency,
    @required this.initialDate,
    @required this.finalDate,
    @required this.initialTime,
  });

  @override
  List<Object> get props => [
        tookIt,
        id,
        executionDay,
        executionTime,
        observation,
        name,
        dosage,
        quantity,
        frequency,
        initialDate,
        finalDate,
        initialTime
      ];
}
