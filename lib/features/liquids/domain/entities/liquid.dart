import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Liquid extends Equatable {
  final int mililitersPerDay;
  final DateTime initialDate;
  final DateTime finalDate;
  final String name;
  final int quantity;
  final String reference;
  final DateTime time;
  final String id;

  Liquid({
    this.id,
    this.name,
    this.quantity,
    this.reference,
    this.time,
    @required this.mililitersPerDay,
    @required this.initialDate,
    @required this.finalDate,
  });

  @override
  List<Object> get props => [
        mililitersPerDay,
        initialDate,
        finalDate,
        name,
        quantity,
        reference,
        time
      ];
}
