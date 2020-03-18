import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Appointment extends Equatable {
  final DateTime timeOfAppointment;
  final DateTime appointmentDate;
  final String adress;
  final String expertise;
  final bool went;
  final String id;

  Appointment({
    this.id,
    this.went,
    @required this.timeOfAppointment,
    @required this.appointmentDate,
    @required this.adress,
    @required this.expertise,
  });

  @override
  List<Object> get props => [
        adress,
        expertise,
        appointmentDate,
        timeOfAppointment,
        went,
        id
      ];
}
