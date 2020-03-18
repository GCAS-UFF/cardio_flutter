import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';
import 'package:cardio_flutter/features/appointments/domain/entities/appointment.dart';

class AppointmentModel extends Appointment {
  AppointmentModel(
      {@required DateTime timeOfAppointment,
      @required DateTime appointmentDate,
      @required String adress,
      @required String expertise,
      bool went,
      String id})
      : super(
            id: id,
            went: went,
            timeOfAppointment: timeOfAppointment,
            appointmentDate: appointmentDate,
            adress: adress,
            expertise: expertise);

  Map<dynamic, dynamic> toJson() {
    Map<dynamic, dynamic> json = {};
    if (timeOfAppointment != null)
      json['timeOfAppointment'] = timeOfAppointment.millisecondsSinceEpoch;
    if (appointmentDate != null)
      json['appointmentDate'] = appointmentDate.millisecondsSinceEpoch;
    if (adress != null) json['adress'] = adress;
    if (expertise != null) json['expertise'] = expertise;
    if (went != null) json['went'] = went;
    if (id != null) json['id'] = id;

    return json;
  }

  factory AppointmentModel.fromJson(Map<dynamic, dynamic> json) {
    if (json == null) return null;
    return AppointmentModel(
      adress: json['adress'],
      appointmentDate: (json['appointmentDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['appointmentDate']),
      timeOfAppointment: (json['timeOfAppointment'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['appointmentDate']),
      expertise: json['expertise'],
      went: json['went'],
      id: json['id'],
    );
  }

  factory AppointmentModel.fromEntity(Appointment appointment) {
    if (appointment == null) return null;
    return AppointmentModel(
        adress: appointment.adress,
        appointmentDate: appointment.appointmentDate,
        expertise: appointment.expertise,
        timeOfAppointment: appointment.timeOfAppointment,
        id: appointment.id,
        went: appointment.went);
  }

  factory AppointmentModel.fromDataSnapshot(
      DataSnapshot dataSnapshot, bool went) {
    if (dataSnapshot == null) return null;

    Map<dynamic, dynamic> objectMap =
        dataSnapshot.value as Map<dynamic, dynamic>;

    objectMap['id'] = dataSnapshot.key;
    objectMap['went'] = true;

    return AppointmentModel.fromJson(objectMap);
  }

  static List<AppointmentModel> fromDataSnapshotList(
      DataSnapshot dataSnapshot, bool went) {
    if (dataSnapshot == null) return null;

    List<AppointmentModel> result = List<AppointmentModel>();
    Map<dynamic, dynamic> objectTodoMap =
        dataSnapshot.value as Map<dynamic, dynamic>;
    if (objectTodoMap != null) {
      for (MapEntry<dynamic, dynamic> entry in objectTodoMap.entries) {
        Map<dynamic, dynamic> appointmentMap = entry.value;
        appointmentMap['id'] = entry.key;
        appointmentMap['went'] = true;
        print(appointmentMap);
        result.add(AppointmentModel.fromJson(appointmentMap));
      }
    }

    return result;
  }
}
