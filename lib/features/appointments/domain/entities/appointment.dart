import 'package:cardio_flutter/features/generic_feature/domain/entities/base_entity.dart';
import 'package:meta/meta.dart';

class Appointment extends BaseEntity {
  final DateTime appointmentDate;
  final String adress;
  final String expertise;
  final bool went;

  Appointment({
    id,
    executedDate,
    done,
    this.went,
    @required this.appointmentDate,
    @required this.adress,
    @required this.expertise,
  }) : super(
            id: id,
            initialDate: appointmentDate,
            finalDate: appointmentDate,
            executedDate: executedDate,
            done: done);

  @override
  List<Object> get props =>
      [adress, expertise, appointmentDate, went, id, done, executedDate];
}
