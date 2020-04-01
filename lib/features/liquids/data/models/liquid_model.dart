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

  static Map<dynamic, dynamic> toJson(LiquidModel liquidModel) {
    Map<dynamic, dynamic> json = {};
    if (liquidModel.initialDate != null)
      json['initialDate'] = liquidModel.initialDate.millisecondsSinceEpoch;
    if (liquidModel.finalDate != null)
      json['finalDate'] = liquidModel.finalDate.millisecondsSinceEpoch;
    if (liquidModel.mililitersPerDay != null)
      json['mililitersPerDay'] = liquidModel.mililitersPerDay;
    if (liquidModel.name != null) json['name'] = liquidModel.name;
    if (liquidModel.quantity != null) json['quantity'] = liquidModel.quantity;
    if (liquidModel.reference != null)
      json['reference'] = liquidModel.reference;
    if (liquidModel.executedDate != null)
      json['executedDate'] = liquidModel.executedDate;

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
      executedDate: json['executedDate'],
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
