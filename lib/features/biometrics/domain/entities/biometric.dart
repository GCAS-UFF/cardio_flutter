import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Biometric extends Equatable {
  final int frequency;
  final DateTime initialDate;
  final DateTime finalDate;
  final double weight;
  final int bpm;
  final String id;
  final String bloodPressure;
  final String swelling;
  final String fatigue;

  Biometric({
    this.id,
    this.fatigue,
    this.weight,
    this.bpm,
    this.bloodPressure,
    this.swelling,
    @required this.frequency,
    @required this.initialDate,
    @required this.finalDate,
  });

  @override
  List<Object> get props => [
        frequency,
        initialDate,
        finalDate,
        weight,
        bpm,
        bloodPressure,
        swelling,
        fatigue,
        id
      ];
}
