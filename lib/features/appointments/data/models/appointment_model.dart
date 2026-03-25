import 'package:cardio_flutter/features/appointments/domain/entities/appointment.dart';

class AppointmentModel extends Appointment {
  AppointmentModel({
    required DateTime appointmentDate,
    required String address,
    required String expertise,
    String? justification,
    bool? went,
    String? id,           // 1. Mudado de String para String?
    required bool done,
    DateTime? executedDate, // 2. Mudado de DateTime para DateTime?
  }) : super(
          id: id,
          went: went,
          executedDate: executedDate,
          done: done,
          justification: justification,
          appointmentDate: appointmentDate,
          address: address,
          expertise: expertise,
        );

  Map<dynamic, dynamic> toJson() {
    return {
      'id': id,
      'done': done,
      'executedDate': executedDate?.millisecondsSinceEpoch,
      'appointmentDate': appointmentDate?.millisecondsSinceEpoch,
      'expertise': expertise,
      'address': address,
      'went': went,
      'justification': justification,
      'initialDate': initialDate.millisecondsSinceEpoch,
      'finalDate': finalDate.millisecondsSinceEpoch,
    };
  }

  factory AppointmentModel.fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) throw Exception("JSON is null");

    return AppointmentModel(
      address: json['address'] ?? json['adress'] ?? "",
      appointmentDate: (json['appointmentDate'] == null)
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(json['appointmentDate']),
      // 4. Se executado for nulo, mantemos null (correto para tarefas pendentes)
      executedDate: (json['executedDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['executedDate']),
      expertise: json['expertise'] ?? "",
      went: json['went'],
      id: json['id'],
      done: json['done'] ?? false,
      justification: json['justification'],
    );
  }

  static AppointmentModel? fromEntity(Appointment? appointment) {
    if (appointment == null) return null;
    return AppointmentModel(
      address: appointment.address,
      appointmentDate: appointment.appointmentDate,
      expertise: appointment.expertise,
      executedDate: appointment.executedDate, // Agora ambos são DateTime?
      done: appointment.done,
      id: appointment.id,                     // Agora ambos são String?
      justification: appointment.justification,
      went: appointment.went,
    );
  }
}