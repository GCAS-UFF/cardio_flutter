import 'package:cardio_flutter/features/generic_feature/domain/entities/base_entity.dart';

class Liquid extends BaseEntity {
  // 1. Campos marcados como nuláveis (?) para evitar erro de inicialização
  final int? mililitersPerDay;
  final String? name;
  final int? quantity;
  final String? reference;

  Liquid({
    this.name,
    this.quantity,
    this.reference,
    this.mililitersPerDay,
    super.id,
    required super.initialDate,
    required super.finalDate,
    super.executedDate,
    required super.done, // 'done' costuma ser obrigatório por lógica de negócio
  });

  @override
  // 2. Mudado para List<Object?> para aceitar os campos com '?'
  List<Object?> get props => [
        mililitersPerDay,
        initialDate,
        finalDate,
        executedDate,
        done,
        name,
        quantity,
        reference,
        id,
      ];
}