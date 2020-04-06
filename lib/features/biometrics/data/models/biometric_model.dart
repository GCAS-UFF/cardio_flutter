import 'package:cardio_flutter/features/biometrics/domain/entities/biometric.dart';
import 'package:meta/meta.dart';

class BiometricModel extends Biometric {
  BiometricModel(
      {@required int frequency,
      @required DateTime initialDate,
      @required DateTime finalDate,
      @required DateTime executedDate,
      @required bool done,
      @required int weight,
      @required int bpm,
      @required String id,
      @required String observation,
      @required String bloodPressure,
      @required String swelling,
      @required String fatigue})
      : super(
            frequency: frequency,
            initialDate: initialDate,
            finalDate: finalDate,
            weight: weight,
            observation: observation,
            bpm: bpm,
            bloodPressure: bloodPressure,
            swelling: swelling,
            fatigue: fatigue,
            id: id,
            executedDate: executedDate,
            done: done);

  static Map<dynamic, dynamic> toJson(BiometricModel model) {
    Map<dynamic, dynamic> json = {};
    if (model.initialDate != null)
      json['initialDate'] = model.initialDate.millisecondsSinceEpoch;
    if (model.finalDate != null)
      json['finalDate'] = model.finalDate.millisecondsSinceEpoch;
    if (model.executedDate != null)
      json['executedDate'] = model.executedDate.millisecondsSinceEpoch;
    if (model.frequency != null) json['frequency'] = model.frequency;
    if (model.weight != null) json['weight'] = model.weight;
    if (model.bloodPressure != null)
      json['bloodPressure'] = model.bloodPressure;
    if (model.bpm != null) json['bpm'] = model.bpm;
    if (model.swelling != null) json['swelling'] = model.swelling;
    if (model.fatigue != null) json['fatigue'] = model.fatigue;
    if (model.observation != null) json['observation'] = model.observation;

    return json;
  }

  factory BiometricModel.fromJson(Map<dynamic, dynamic> json) {
    if (json == null) return null;
    return BiometricModel(
      frequency: json['frequency'],
      initialDate: (json['initialDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['initialDate']),
      finalDate: (json['finalDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['finalDate']),
      executedDate: (json['executedDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['executedDate']),
      weight: json['weight'],
      bloodPressure: json['bloodPressure'],
      bpm: json['bpm'],
      swelling: json['swelling'],
      fatigue: json['fatigue'],
      id: json['id'],
      done: json['done'],
      observation: json['observation'],
    );
  }

  factory BiometricModel.fromEntity(Biometric biometric) {
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
        executedDate: biometric.executedDate);
  }
}
