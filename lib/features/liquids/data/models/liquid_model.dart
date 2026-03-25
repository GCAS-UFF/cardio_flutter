import 'package:cardio_flutter/features/liquids/domain/entities/liquid.dart';

class LiquidModel extends Liquid {
  LiquidModel({
    required super.mililitersPerDay,
    required super.initialDate,
    required super.finalDate,
    required super.executedDate,
    required super.done,
    required super.name,
    required super.quantity,
    required super.reference,
    required super.id,
  });

  // 1. Removi o 'static' e o parâmetro. Agora você chama model.toJson()
  Map<dynamic, dynamic> toJson() {
    return {
      // Uso do '!' pois o construtor garante que não são nulos nesta classe
      'initialDate': initialDate!.millisecondsSinceEpoch,
      'finalDate': finalDate!.millisecondsSinceEpoch,
      'mililitersPerDay': mililitersPerDay,
      'name': name,
      'quantity': quantity,
      'reference': reference,
      'executedDate': executedDate?.millisecondsSinceEpoch,
      'done': done,
    };
  }

  factory LiquidModel.fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) throw Exception("JSON de Líquidos nulo");
    
    return LiquidModel(
      mililitersPerDay: json['mililitersPerDay'] ?? 0,
      initialDate: (json['initialDate'] == null)
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(json['initialDate']),
      finalDate: (json['finalDate'] == null)
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(json['finalDate']),
      name: json['name'] ?? "",
      quantity: json['quantity'] ?? 0,
      id: json['id'] ?? "",
      reference: json['reference'] ?? "",
      executedDate: (json['executedDate'] == null)
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(json['executedDate']),
      done: json['done'] ?? false,
    );
  }

  // 2. Mudado para static retornando opcional para evitar erro de 'Null'
  static LiquidModel? fromEntity(Liquid? liquid) {
    if (liquid == null) return null;
    return LiquidModel(
      finalDate: liquid.finalDate ?? DateTime.now(),
      initialDate: liquid.initialDate ?? DateTime.now(),
      mililitersPerDay: liquid.mililitersPerDay ?? 0,
      name: liquid.name ?? "",
      quantity: liquid.quantity ?? 0,
      id: liquid.id ?? "",
      reference: liquid.reference ?? "",
      executedDate: liquid.executedDate ?? DateTime.now(),
      done: liquid.done,
    );
  }
}