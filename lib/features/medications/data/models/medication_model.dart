import 'package:cardio_flutter/features/medications/domain/entities/medication.dart';
import 'package:meta/meta.dart';

class MedicationModel extends Medication {
  MedicationModel(
      {@required String name,
      @required double dosage,
      @required int quantity,
      @required int frequency,
      @required DateTime initialDate,
      @required DateTime finalDate,
      @required String observation,
      @required bool tookIt,
      @required String id,
      @required bool done,
      @required DateTime executedDate})
      : super(
            name: name,
            dosage: dosage,
            quantity: quantity,
            frequency: frequency,
            initialDate: initialDate,
            finalDate: finalDate,
            observation: observation,
            tookIt: tookIt,
            id: id,
            done: done,
            executedDate: executedDate);

  static Map<dynamic, dynamic> toJson(MedicationModel model) {
    Map<dynamic, dynamic> json = {};
    if (model.name != null) json['name'] = model.name;
    if (model.dosage != null) json['dosage'] = model.dosage;
    if (model.quantity != null) json['quantity'] = model.quantity;
    if (model.frequency != null) json['frequency'] = model.frequency;
    if (model.initialDate != null)
      json['initialDate'] = model.initialDate.millisecondsSinceEpoch;
    if (model.finalDate != null)
      json['finalDate'] = model.finalDate.millisecondsSinceEpoch;
    if (model.executedDate != null)
      json['executedDate'] = model.executedDate.millisecondsSinceEpoch;
    if (model.observation != null) json['observation'] = model.observation;
    if (model.tookIt != null) json['tookIt'] = model.tookIt;
    if (model.id != null) json['id'] = model.id;
    if (model.done != null) json['done'] = model.done;
    return json;
  }

  factory MedicationModel.fromJson(Map<dynamic, dynamic> json) {
    if (json == null) return null;
    return MedicationModel(
      name: json['name'],
      dosage: (json['dosage'] is int)
          ? (json['dosage'] as int).toDouble()
          : json['dosage'],
      frequency: json['frequency'],
      quantity: json['quantity'],
      initialDate: (json['initialDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['initialDate']),
      finalDate: (json['finalDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['finalDate']),
      executedDate: (json['executedDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['executedDate']),
      observation: json['observation'],
      tookIt: json['tookIt'],
      id: json['id'],
      done: json['done'],
    );
  }

  factory MedicationModel.fromEntity(Medication medication) {
    if (medication == null) return null;
    return MedicationModel(
        name: medication.name,
        dosage: medication.dosage,
        frequency: medication.frequency,
        quantity: medication.quantity,
        initialDate: medication.initialDate,
        finalDate: medication.finalDate,
        executedDate: medication.executedDate,
        observation: medication.observation,
        tookIt: medication.tookIt,
        id: medication.id,
        done: medication.done);
  }
}
