import 'package:cardio_flutter/features/appointments/data/models/appointment_model.dart';
import 'package:cardio_flutter/features/appointments/domain/entities/appointment.dart';
import 'package:cardio_flutter/features/biometrics/data/models/biometric_model.dart';
import 'package:cardio_flutter/features/biometrics/domain/entities/biometric.dart';
import 'package:cardio_flutter/features/exercises/domain/entities/exercise.dart';
import 'package:cardio_flutter/features/liquids/data/models/liquid_model.dart';
import 'package:cardio_flutter/features/liquids/domain/entities/liquid.dart';
import 'package:cardio_flutter/features/medications/data/models/medication_model.dart';
import 'package:cardio_flutter/features/medications/domain/entities/medication.dart';
import 'package:firebase_database/firebase_database.dart';

class GenericConverter {
  static Map<dynamic, dynamic> genericToJson<Model>(String type, Model model) {
    if (type == "liquid") {
      return LiquidModel.toJson(model as LiquidModel);
    } else if (type == "biometric") {
      return BiometricModel.toJson(model as BiometricModel);
    } else if (type == "appointment") {
      return AppointmentModel.toJson(model as AppointmentModel);
    } else if (type == "medication") {
      return MedicationModel.toJson(model as MedicationModel);
    } else {
      return null;
    }
  }

  static Model genericFromJson<Model>(String type, Map<dynamic, dynamic> json) {
    if (type == "liquid") {
      return LiquidModel.fromJson(json) as Model;
    } else if (type == "biometric") {
      return BiometricModel.fromJson(json) as Model;
    } else if (type == "appointment") {
      return AppointmentModel.fromJson(json) as Model;
    } else if (type == "medication") {
      return MedicationModel.fromJson(json) as Model;
    } else {
      return null;
    }
  }

  static Model genericModelFromEntity<Entity, Model extends Entity>(String type, Entity entity) {
    if (type == "liquid") {
      return (LiquidModel.fromEntity(entity as Liquid) as Model);
    } else if (type == "biometric") {
      return (BiometricModel.fromEntity(entity as Biometric) as Model);
    } else if (type == "appointment") {
      return (AppointmentModel.fromEntity(entity as Appointment) as Model);
    } else if (type == "medication") {
      return (MedicationModel.fromEntity(entity as Medication) as Model);
    } else {
      return null;
    }
  }

  static Model genericFromDataSnapshot<Model>(String type, DataSnapshot dataSnapshot, bool done) {
    if (dataSnapshot == null) return null;

    Map<dynamic, dynamic> objectMap = dataSnapshot.value as Map<dynamic, dynamic>;

    objectMap['id'] = dataSnapshot.key;
    objectMap['done'] = done;

    return genericFromJson<Model>(type, objectMap);
  }

  static List<Model> genericFromDataSnapshotList<Model>(String type, DataSnapshot dataSnapshot, bool done) {
    if (dataSnapshot == null) return null;

    List<Model> result = List<Model>();
    Map<dynamic, dynamic> objectTodoMap = dataSnapshot.value as Map<dynamic, dynamic>;
    if (objectTodoMap != null) {
      for (MapEntry<dynamic, dynamic> entry in objectTodoMap.entries) {
        Map<dynamic, dynamic> map = entry.value;
        map['id'] = entry.key;
        map['done'] = done;
        result.add(genericFromJson(type, map));
      }
    }

    return result;
  }

  static String mapEntity(dynamic entity) {
    if (entity is Biometric) {
      return "biometric";
    } else if (entity is Liquid) {
      return "liquid";
    } else if (entity is Medication) {
      return "medicine";
    } else if (entity is Appointment) {
      return "appointment";
    } else if (entity is Exercise) {
      return "exercise";
    } else {
      print("[JP - GenericConverter] entity estranha no mapEntity");
      return "unknown";
    }
  }

  static bool isAction(dynamic entity) {
    if (entity is Biometric) {
      return entity.done;
    } else if (entity is Liquid) {
      return entity.done;
    } else if (entity is Medication) {
      return entity.done;
    } else if (entity is Appointment) {
      return entity.done;
    } else if (entity is Exercise) {
      return entity.done;
    } else {
      print("[JP - GenericConverter] entity estranha no isAction");
      return false;
    }
  }
}
