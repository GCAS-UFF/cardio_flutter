import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class BaseEntity extends Equatable {
  final DateTime initialDate;
  final DateTime finalDate;
  final DateTime executedDate;
  final bool done;

  BaseEntity(
      {@required this.initialDate,
      @required this.finalDate,
      @required this.executedDate,
      @required this.done});
}
