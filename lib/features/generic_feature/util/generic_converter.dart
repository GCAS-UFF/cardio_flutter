import 'package:cardio_flutter/features/appointments/data/models/appointment_model.dart';
import 'package:cardio_flutter/features/appointments/domain/entities/appointment.dart';
import 'package:cardio_flutter/features/biometrics/data/models/biometric_model.dart';
import 'package:cardio_flutter/features/biometrics/domain/entities/biometric.dart';
import 'package:cardio_flutter/features/liquids/data/models/liquid_model.dart';
import 'package:cardio_flutter/features/liquids/domain/entities/liquid.dart';
import 'package:cardio_flutter/features/medications/data/models/medication_model.dart';
import 'package:cardio_flutter/features/medications/domain/entities/medication.dart';
import 'package:firebase_database/firebase_database.dart';

class GenericConverter {
  
  static Map<dynamic, dynamic>? genericToJson<Model>(String type, Model model) {
    if (type == "liquid") {
      // CORREÇÃO: Chamada via instância e sem argumentos
      return (model as LiquidModel).toJson();
    } else if (type == "biometric") {
      return (model as BiometricModel).toJson();
    } else if (type == "appointment") {
      return (model as AppointmentModel).toJson();
    } else if (type == "medication") {
      return (model as MedicationModel).toJson();
    } else {
      return null;
    }
  }

  static Model? genericFromJson<Model>(String type, Map<dynamic, dynamic> json) {
    if (type == "liquid") {
      return LiquidModel.fromJson(json) as Model?;
    } else if (type == "biometric") {
      return BiometricModel.fromJson(json) as Model?;
    } else if (type == "appointment") {
      return AppointmentModel.fromJson(json) as Model?;
    } else if (type == "medication") {
      return MedicationModel.fromJson(json) as Model?;
    } else {
      return null;
    }
  }

  static Model? genericModelFromEntity<Entity, Model extends Entity>(
      String type, Entity entity) {
    if (type == "liquid") {
      return (LiquidModel.fromEntity(entity as Liquid) as Model?);
    } else if (type == "biometric") {
      return (BiometricModel.fromEntity(entity as Biometric) as Model?);
    } else if (type == "appointment") {
      return (AppointmentModel.fromEntity(entity as Appointment) as Model?);
    } else if (type == "medication") {
      return (MedicationModel.fromEntity(entity as Medication) as Model?);
    } else {
      return null;
    }
  }

  static Model? genericFromDataSnapshot<Model>(
      String type, DataSnapshot dataSnapshot, bool done) {
    final snapshotValue = dataSnapshot.value;
    if (snapshotValue == null) return null;

    Map<dynamic, dynamic> objectMap = Map<dynamic, dynamic>.from(snapshotValue as Map);

    objectMap['id'] = dataSnapshot.key;
    objectMap['done'] = done;

    return genericFromJson<Model>(type, objectMap);
  }

  static List<Model> genericFromDataSnapshotList<Model>(
      String type, DataSnapshot dataSnapshot, bool done) {
    final snapshotValue = dataSnapshot.value;
    if (snapshotValue == null) return [];

    List<Model> result = [];
    
    Map<dynamic, dynamic> objectTodoMap = Map<dynamic, dynamic>.from(snapshotValue as Map);
    
    for (MapEntry<dynamic, dynamic> entry in objectTodoMap.entries) {
      Map<dynamic, dynamic> map = Map<dynamic, dynamic>.from(entry.value as Map);
      map['id'] = entry.key;
      map['done'] = done;
      
      Model? converted = genericFromJson<Model>(type, map);
      if (converted != null) {
        result.add(converted);
      }
    }

    return result;
  }
}