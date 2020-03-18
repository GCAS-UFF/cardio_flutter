import 'package:cardio_flutter/features/liquids/domain/entities/liquid.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';

class LiquidModel extends Liquid {
  LiquidModel(
      {@required int mililitersPerDay,
      @required DateTime initialDate,
      @required DateTime finalDate,
      String name,
      int quantity,
      String reference,
      DateTime time,
      String id})
      : super(
            mililitersPerDay: mililitersPerDay,
            initialDate: initialDate,
            finalDate: finalDate,
            name: name,
            quantity: quantity,
            reference: reference,
            time: time,
            id: id);

  Map<dynamic, dynamic> toJson() {
    Map<dynamic, dynamic> json = {};
    if (initialDate != null)
      json['initialDate'] = initialDate.millisecondsSinceEpoch;
    if (finalDate != null) json['finalDate'] = finalDate.millisecondsSinceEpoch;
    if (mililitersPerDay != null) json['mililitersPerDay'] = mililitersPerDay;
    if (name != null) json['name'] = name;
    if (quantity != null) json['quantity'] = quantity;
    if (id != null) json['id'] = id;
    if (reference != null) json['reference'] = reference;
    if (time != null) json['time'] = time;

    return json;
  }

  factory LiquidModel.fromJson(Map<dynamic, dynamic> json) {
    if (json == null) return null;
    return LiquidModel(
      mililitersPerDay: json['mililitersPerDay'],
      initialDate: (json['initialDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['initialDate']),
      finalDate: (json['finalDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['finalDate']),
      name: json['name'],
      quantity: json['quantity'],
      id: json['id'],
      reference: json['reference'],
      time: json['time'],
    );
  }

  factory LiquidModel.fromEntity(Liquid liquid) {
    if (liquid == null) return null;
    return LiquidModel(
        finalDate: liquid.finalDate,
        initialDate: liquid.initialDate,
        mililitersPerDay: liquid.mililitersPerDay,
        name: liquid.name,
        quantity: liquid.quantity,
        id: liquid.id,
        reference: liquid.reference,
        time: liquid.time);
  }

  factory LiquidModel.fromDataSnapshot(
    DataSnapshot dataSnapshot,
  ) {
    if (dataSnapshot == null) return null;

    Map<dynamic, dynamic> objectMap =
        dataSnapshot.value as Map<dynamic, dynamic>;

    objectMap['id'] = dataSnapshot.key;

    return LiquidModel.fromJson(objectMap);
  }

  static List<LiquidModel> fromDataSnapshotList(DataSnapshot dataSnapshot) {
    if (dataSnapshot == null) return null;

    List<LiquidModel> result = List<LiquidModel>();
    Map<dynamic, dynamic> objectTodoMap =
        dataSnapshot.value as Map<dynamic, dynamic>;
    if (objectTodoMap != null) {
      for (MapEntry<dynamic, dynamic> entry in objectTodoMap.entries) {
        Map<dynamic, dynamic> liquidMap = entry.value;
        liquidMap['id'] = entry.key;
        print(liquidMap);
        result.add(LiquidModel.fromJson(liquidMap));
      }
    }
    return result;
  }
}
