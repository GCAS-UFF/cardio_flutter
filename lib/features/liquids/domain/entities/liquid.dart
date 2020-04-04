import 'package:cardio_flutter/features/generic_feature/domain/entities/base_entity.dart';
import 'package:meta/meta.dart';

class Liquid extends BaseEntity {
  final int mililitersPerDay;
  final String name;
  final int quantity;
  final String reference;

  Liquid({
    this.name,
    this.quantity,
    this.reference,
    this.mililitersPerDay,
    id,
    initialDate,
    finalDate,
    executedDate,
    @required done,
  }) : super(
            id: id,
            initialDate: initialDate,
            finalDate: finalDate,
            executedDate: executedDate,
            done: done);

  @override
  List<Object> get props => [
        mililitersPerDay,
        initialDate,
        finalDate,
        executedDate,
        done,
        name,
        quantity,
        reference,
      ];
}
