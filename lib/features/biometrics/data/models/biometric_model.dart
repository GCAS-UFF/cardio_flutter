import 'package:cardio_flutter/features/biometrics/domain/entities/biometric.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';

class BiometricModel extends Biometric {
  BiometricModel(
      {@required int frequency,
      @required DateTime initialDate,
      @required DateTime finalDate,
      double weight,
      int bpm,
      String id,
      String bloodPressure,
      String swelling,
      String fatigue})
      : super(
            frequency: frequency,
            initialDate: initialDate,
            finalDate: finalDate,
            weight: weight,
            bpm: bpm,
            bloodPressure: bloodPressure,
            swelling: swelling,
            fatigue: fatigue,
            id: id);

  Map<dynamic, dynamic> toJson() {
    Map<dynamic, dynamic> json = {};
    if (initialDate != null)
      json['initialDate'] = initialDate.millisecondsSinceEpoch;
    if (finalDate != null) json['finalDate'] = finalDate.millisecondsSinceEpoch;
    if (frequency != null) json['frequency'] = frequency;
    if (weight != null) json['weight'] = weight;
    if (bloodPressure != null) json['bloodPressure'] = bloodPressure;
    if (bpm != null) json['bpm'] = bpm;
    if (swelling != null) json['swelling'] = swelling;
    if (fatigue != null) json['fatigue'] = fatigue;
    if (id != null) json['id'] = id;

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
      weight: json['weight'],
      bloodPressure: json['bloodPressure'],
      bpm: json['bpm'],
      swelling: json['swelling'],
      fatigue: json['fatigue'],
      id: json['id'],
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
        id: biometric.id);
  }

  factory BiometricModel.fromDataSnapshot(DataSnapshot dataSnapshot) {
    if (dataSnapshot == null) return null;
    Map<dynamic, dynamic> objectMap =
        dataSnapshot.value as Map<dynamic, dynamic>;
    objectMap['id'] = dataSnapshot.key;
    return BiometricModel.fromJson(objectMap);
  }

  static List<BiometricModel> fromDataSnapshotList(
    DataSnapshot dataSnapshot,
  ) {
    if (dataSnapshot == null) return null;

    List<BiometricModel> result = List<BiometricModel>();
    Map<dynamic, dynamic> objectTodoMap =
        dataSnapshot.value as Map<dynamic, dynamic>;
    if (objectTodoMap != null) {
      for (MapEntry<dynamic, dynamic> entry in objectTodoMap.entries) {
        Map<dynamic, dynamic> biometricMap = entry.value;
        biometricMap['id'] = entry.key;
        print(biometricMap);
        result.add(BiometricModel.fromJson(biometricMap));
      }
    }
    return result;
  }
}
