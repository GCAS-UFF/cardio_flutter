import 'package:cardio_flutter/features/biometrics/data/models/biometric_model.dart';
import 'package:cardio_flutter/features/biometrics/domain/entities/biometric.dart';
import 'package:cardio_flutter/features/liquids/data/models/liquid_model.dart';
import 'package:cardio_flutter/features/liquids/domain/entities/liquid.dart';
import 'package:firebase_database/firebase_database.dart';

class GenericConverter {
  static Map<dynamic, dynamic> genericToJson<Model>(String type, Model model) {
    if (type == "liquid") {
      return LiquidModel.toJson(model as LiquidModel);
    } else if (type == "biometric") {
      return BiometricModel.toJson(model as BiometricModel);
    } else {
      return null;
    }
  }

  static Model genericFromJson<Model>(String type, Map<dynamic, dynamic> json) {
    if (type == "liquid") {
      return LiquidModel.fromJson(json) as Model;
    } else if (type == "biometric") {
      return BiometricModel.fromJson(json) as Model;
    } else {
      return null;
    }
  }

  static Model genericModelFromEntity<Entity, Model extends Entity>(
      String type, Entity entity) {
    if (type == "liquid") {
      return (LiquidModel.fromEntity(entity as Liquid) as Model);
    } else if (type == "biometric") {
      return (BiometricModel.fromEntity(entity as Biometric) as Model);
    } else {
      return null;
    }
  }

  static Model genericFromDataSnapshot<Model>(
      String type, DataSnapshot dataSnapshot, bool done) {
    if (dataSnapshot == null) return null;

    Map<dynamic, dynamic> objectMap =
        dataSnapshot.value as Map<dynamic, dynamic>;

    objectMap['id'] = dataSnapshot.key;
    objectMap['done'] = done;

    return genericFromJson<Model>(type, objectMap);
  }

  static List<Model> genericFromDataSnapshotList<Model>(
      String type, DataSnapshot dataSnapshot, bool done) {
    if (dataSnapshot == null) return null;

    List<Model> result = List<Model>();
    Map<dynamic, dynamic> objectTodoMap =
        dataSnapshot.value as Map<dynamic, dynamic>;
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
}
