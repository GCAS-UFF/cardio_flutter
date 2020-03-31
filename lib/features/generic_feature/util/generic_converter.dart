import 'package:cardio_flutter/features/liquids/data/models/liquid_model.dart';
import 'package:cardio_flutter/features/liquids/domain/entities/liquid.dart';
import 'package:firebase_database/firebase_database.dart';

class GenericConverter {
  static Map<dynamic, dynamic> genericToJson<Model>(String type, Model model) {
    if (type == "liquid") {
      return LiquidModel.toJson(model as LiquidModel);
    } else {
      return null;
    }
  }

  static Model genericFromDataSnapshot<Model>(
      String type, DataSnapshot snapshot) {
    if (type == "liquid") {
      return (LiquidModel.fromDataSnapshot(snapshot) as Model);
    } else {
      return null;
    }
  }

  static Model genericModelFromEntity<Entity, Model extends Entity>(
      String type, Entity entity) {
    if (type == "liquid") {
      return (LiquidModel.fromEntity(entity as Liquid) as Model);
    } else {
      return null;
    }
  }
}
