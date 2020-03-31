import 'package:cardio_flutter/features/medications/domain/entities/medication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';

class MedicationModel extends Medication {
  MedicationModel(
      {@required String name,
      String id,
      @required double dosage,
      @required int quantity,
      @required int frequency,
      @required DateTime initialDate,
      @required DateTime finalDate,
      @required DateTime initialTime,
      String observation,
      DateTime executionDay,
      DateTime executionTine,
      bool tookIt})
      : super(
            id: id,
            name: name,
            dosage: dosage,
            quantity: quantity,
            frequency: frequency,
            initialDate: initialDate,
            finalDate: finalDate,
            initialTime: initialTime,
            observation: observation,
            executionDay: executionDay,
            tookIt: tookIt);

  Map<dynamic, dynamic> toJson() {
    Map<dynamic, dynamic> json = {};
    if (initialDate != null)
      json['initialDate'] = initialDate.millisecondsSinceEpoch;
    if (finalDate != null) json['finalDate'] = finalDate.millisecondsSinceEpoch;
    if (initialTime != null)
      json['initialTime'] = initialTime.millisecondsSinceEpoch;
    if (executionDay != null)
      json['executionDay'] = executionDay.millisecondsSinceEpoch;
    if (id != null) json['id'] = id;
    if (name != null) json['name'] = name;
    if (dosage != null) json['dosage'] = dosage;
    if (quantity != null) json['quantity'] = quantity;
    if (frequency != null) json['frequency'] = frequency;
    if (tookIt != null) json['tookIt'] = tookIt;
    if (observation != null) json['observation'] = observation;

    return json;
  }

  factory MedicationModel.fromJson(Map<dynamic, dynamic> json) {
    if (json == null) return null;
    return MedicationModel(
      name: json['name'],
      initialDate: (json['initialDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['initialDate']),
      finalDate: (json['finalDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['finalDate']),
      initialTime: (json['initialTime'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['initialTime']),
      executionDay: (json['executionDay'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['executionDay']),
      id: json['id'],
      dosage: json['dosage'],
      frequency: json['frequency'],
      quantity: json['quantity'],
      observation: json['observation'],
      tookIt: json['tookIt'],
    );
  }

  factory MedicationModel.fromEntity(Medication medication) {
    if (medication == null) return null;
    return MedicationModel(
        initialTime: medication.initialTime,
        finalDate: medication.finalDate,
        id: medication.id,
        dosage: medication.dosage,
        frequency: medication.frequency,
        name: medication.name,
        quantity: medication.quantity,
        observation: medication.observation,
        executionDay: medication.executionDay,
        initialDate: medication.initialDate,
        tookIt: medication.tookIt);
  }

  factory MedicationModel.fromDataSnapshot(
      DataSnapshot dataSnapshot, bool went) {
    if (dataSnapshot == null) return null;

    Map<dynamic, dynamic> objectMap =
        dataSnapshot.value as Map<dynamic, dynamic>;

    objectMap['id'] = dataSnapshot.key;
    objectMap['tookIt'] = true;

    return MedicationModel.fromJson(objectMap);
  }

  static List<MedicationModel> fromDataSnapshotList(
      DataSnapshot dataSnapshot, bool went) {
    if (dataSnapshot == null) return null;

    List<MedicationModel> result = List<MedicationModel>();
    Map<dynamic, dynamic> objectTodoMap =
        dataSnapshot.value as Map<dynamic, dynamic>;
    if (objectTodoMap != null) {
      for (MapEntry<dynamic, dynamic> entry in objectTodoMap.entries) {
        Map<dynamic, dynamic> medicationMap = entry.value;
        medicationMap['id'] = entry.key;
        medicationMap['tookIt'] = true;
        print(medicationMap);
        result.add(MedicationModel.fromJson(medicationMap));
      }
    }

    return result;
  }
}
