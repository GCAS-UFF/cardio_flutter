import 'package:meta/meta.dart';
import 'package:cardio_flutter/features/appointments/domain/entities/appointment.dart';

class AppointmentModel extends Appointment {
  AppointmentModel(
      {
      @required DateTime appointmentDate,
      @required String adress,
      @required String expertise,
      @required String justification,
      @required bool went,
      @required String id,
      @required bool done, 
      @required DateTime executedDate})
      : super(
            id: id,
            went: went,
            executedDate: executedDate,
            done : done,
            justification:justification,
            appointmentDate: appointmentDate,
            adress: adress,
            expertise: expertise);

  static Map<dynamic, dynamic> toJson(AppointmentModel appointmentModel) {
    Map<dynamic, dynamic> json = {};
    if (appointmentModel.executedDate != null)
      json['executedDate'] = appointmentModel.executedDate.millisecondsSinceEpoch;
    if (appointmentModel.appointmentDate != null)
      json['appointmentDate'] = appointmentModel.appointmentDate.millisecondsSinceEpoch;
    if (appointmentModel.adress != null) json['adress'] = appointmentModel.adress;
    if (appointmentModel.expertise != null) json['expertise'] = appointmentModel.expertise;
    if (appointmentModel.went != null) json['went'] = appointmentModel.went;
    if (appointmentModel.justification != null) json['justification'] = appointmentModel.justification;

    return json;
  }

  factory AppointmentModel.fromJson(Map<dynamic, dynamic> json) {
    if (json == null) return null;
    return AppointmentModel(
      adress: json['adress'],
      appointmentDate: (json['appointmentDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['appointmentDate']),
      executedDate: (json['executedDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['executedDate']),
      expertise: json['expertise'],
      went: json['went'],
      id: json['id'],
      done : json['done'],
      justification : json['justification'],
    );
  }

  factory AppointmentModel.fromEntity(Appointment appointment) {
    if (appointment == null) return null;
    return AppointmentModel(
        adress: appointment.adress,
        appointmentDate: appointment.appointmentDate,
        expertise: appointment.expertise,
        executedDate: appointment.executedDate,
        done: appointment.done,
        id: appointment.id,
        justification: appointment.justification,
        went: appointment.went);
  }
}
