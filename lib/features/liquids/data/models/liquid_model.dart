import 'package:cardio_flutter/features/liquids/domain/entities/liquid.dart';
import 'package:meta/meta.dart';

class LiquidModel extends Liquid {
  LiquidModel(
      {@required int mililitersPerDay,
      @required DateTime initialDate,
      @required DateTime finalDate,
      @required DateTime executedDate,
      @required bool done,
      @required String name,
      @required int quantity,
      @required int reference,
      @required String id})
      : super(
            mililitersPerDay: mililitersPerDay,
            initialDate: initialDate,
            finalDate: finalDate,
            executedDate: executedDate,
            done: done,
            name: name,
            quantity: quantity,
            reference: reference,
            id: id);

  static Map<dynamic, dynamic> toJson(LiquidModel model) {
    Map<dynamic, dynamic> json = {};
    if (model.initialDate != null)
      json['initialDate'] = model.initialDate.millisecondsSinceEpoch;
    if (model.finalDate != null)
      json['finalDate'] = model.finalDate.millisecondsSinceEpoch;
    if (model.mililitersPerDay != null)
      json['mililitersPerDay'] = model.mililitersPerDay;
    if (model.name != null) json['name'] = model.name;
    if (model.quantity != null) json['quantity'] = model.quantity;
    if (model.reference != null)
      json['reference'] = model.reference;
    if (model.executedDate != null)
      json['executedDate'] = model.executedDate.millisecondsSinceEpoch;

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
      executedDate: (json['executedDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['executedDate']),
      done: json['done'],
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
      executedDate: liquid.executedDate,
      done: liquid.done,
    );
  }
}
