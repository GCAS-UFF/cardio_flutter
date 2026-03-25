import 'dart:math';
import 'package:cardio_flutter/core/platform/settings.dart';
import 'package:cardio_flutter/core/utils/date_helper.dart';
import 'package:cardio_flutter/features/appointments/domain/entities/appointment.dart';
import 'package:cardio_flutter/features/biometrics/domain/entities/biometric.dart';
import 'package:cardio_flutter/features/exercises/domain/entities/exercise.dart';
import 'package:cardio_flutter/features/liquids/domain/entities/liquid.dart';
import 'package:cardio_flutter/features/generic_feature/util/generic_converter.dart';
import 'package:cardio_flutter/features/medications/domain/entities/medication.dart';
import 'package:cardio_flutter/resources/arrays.dart';
import 'package:cardio_flutter/resources/keys.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NotificationManager {
  static const int APPOINTMENT_NOTIFICATION_ID = 50;
  static const int BIOMETRIC_NOTIFICATION_ID = 60;
  static const int EXERCISE_NOTIFICATION_ID = 70;
  static const int LIQUID_NOTIFICATION_ID = 80;
  static const int MEDICATION_NOTIFICATION_ID = 90;

  final int dayInMilliseconds = 24 * 60 * 60 * 1000;

  late NotificationDetails _appointmentChannel;
  late NotificationDetails _biometricChannel;
  late NotificationDetails _exerciseChannel;
  late NotificationDetails _liquidChannel;
  late NotificationDetails _medicationChannel;

  final FlutterLocalNotificationsPlugin localNotificationsPlugin;
  final FirebaseDatabase firebaseDatabase;
  final Settings settings;

  NotificationManager({
    required this.localNotificationsPlugin,
    required this.firebaseDatabase,
    required this.settings,
  });

  Future<void> init() async {
    tz.initializeTimeZones();

    _appointmentChannel = _createChannel("Appointments");
    _biometricChannel = _createChannel("Biometrics");
    _exerciseChannel = _createChannel("Exercise");
    _liquidChannel = _createChannel("Liquids");
    _medicationChannel = _createChannel("Medication");

    if (settings.getUserType() == null || settings.getUserType() != Keys.PATIENT_TYPE) {
      return;
    }
    
    String? patientId = settings.getUserId();
    if (patientId == null) return;

    await _initializeNotifications();

    _initializeAppointment(patientId, APPOINTMENT_NOTIFICATION_ID, _appointmentChannel);
    _initializeBiometric(patientId, BIOMETRIC_NOTIFICATION_ID, _biometricChannel);
    _initializeExercise(patientId, EXERCISE_NOTIFICATION_ID, _exerciseChannel);
    _initializeLiquid(patientId, LIQUID_NOTIFICATION_ID, _liquidChannel);
    _initializeMedication(patientId, MEDICATION_NOTIFICATION_ID, _medicationChannel);
  }

  Future<void> _initializeNotifications() async {
    const android = AndroidInitializationSettings('app_logo');
    const iOS = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: android, iOS: iOS);
    
    // Na v21 o parâmetro é NOMEADO. Tente 'initializationSettings' ou 'settings'
    // O seu erro diz que 'settings' é o que ele espera:
    await localNotificationsPlugin.initialize(
      settings: initSettings, 
    );
  }

  static NotificationDetails _createChannel(String channelName) {
    var androidChannel = AndroidNotificationDetails(
      channelName,
      channelName,
      channelDescription: channelName,
      styleInformation: const BigTextStyleInformation(""),
      importance: Importance.max,
      priority: Priority.max,
      ongoing: true,
    );
    return NotificationDetails(android: androidChannel, iOS: const DarwinNotificationDetails());
  }

  Future<void> singleNotification({
    required NotificationDetails channel,
    required DateTime datetime,
    required String title,
    required String body,
    required int startId,
  }) async {
    int id = _generateNotificationId(startId);
    
    await localNotificationsPlugin.zonedSchedule(
      id: id, // Nomeado agora!
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(datetime, tz.local),
      notificationDetails: channel,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: id.toString(),
    );
  }

  int _generateNotificationId(int startId) {
    var rng = Random();
    return int.parse("$startId${rng.nextInt(99999)}");
  }

  Future<void> _cleanNotifications(int startId) async {
    var notifications = await localNotificationsPlugin.pendingNotificationRequests();
    for (var element in notifications) {
      if (element.id.toString().startsWith(startId.toString())) {
        await localNotificationsPlugin.cancel(id: element.id);
      }
    }
  }

  Future<void> _initializeAppointment(String patientId, int startId, NotificationDetails channel) async {
    await _cleanNotifications(startId);
    firebaseDatabase.ref().child("Patient").child(patientId).child('ToDo').child("Appointment").onValue.listen((event) async {
      var snapshot = event.snapshot;
      if (snapshot.value == null) return;

      List<Appointment> appointments = GenericConverter.genericFromDataSnapshotList("appointment", snapshot, false);

      for (var appointment in appointments) {
        if (appointment.appointmentDate != null && appointment.appointmentDate!.isAfter(DateTime.now())) {
          // Notificação 1 dia antes
          DateTime oneDayBefore = appointment.appointmentDate!.subtract(const Duration(days: 1));
          if (oneDayBefore.isAfter(DateTime.now())) {
            await singleNotification(
              channel: channel,
              startId: startId,
              title: "Consulta amanhã!",
              body: "Você tem ${appointment.expertise} em ${appointment.address}",
              datetime: oneDayBefore,
            );
          }
          // Notificação 2 horas antes
          DateTime hoursBefore = appointment.appointmentDate!.subtract(const Duration(hours: 2));
          if (hoursBefore.isAfter(DateTime.now())) {
            await singleNotification(
              channel: channel,
              startId: startId,
              title: "Consulta em breve!",
              body: "Sua consulta é em 2 horas em ${appointment.address}",
              datetime: hoursBefore,
            );
          }
        }
      }
    });
  }

  Future<void> _initializeBiometric(String patientId, int startId, NotificationDetails channel) async {
    await _cleanNotifications(startId);
    firebaseDatabase.ref().child("Patient").child(patientId).child('ToDo').child("Biometric").onValue.listen((event) async {
      var snapshot = event.snapshot;
      if (snapshot.value == null) return;

      List<Biometric> biometrics = GenericConverter.genericFromDataSnapshotList("biometric", snapshot, false);

      for (var biometric in biometrics) {
        if (biometric.initialDate != null && biometric.finalDate != null && biometric.times != null) {
          for (var time in biometric.times!) {
            DateTime? initial = DateHelper.addTimeToDate(time, biometric.initialDate);
            DateTime? finalDate = DateHelper.addTimeToDate(time, biometric.finalDate);
            if (initial == null || finalDate == null) continue;

            for (int i = initial.millisecondsSinceEpoch; i <= finalDate.millisecondsSinceEpoch; i += dayInMilliseconds) {
              DateTime notificationTime = DateTime.fromMillisecondsSinceEpoch(i);
              if (notificationTime.isAfter(DateTime.now())) {
                await singleNotification(
                  channel: channel,
                  startId: startId,
                  title: "Atenção!!",
                  body: "Não se esqueça de nos dizer como você está hoje",
                  datetime: notificationTime,
                );
              }
            }
          }
        }
      }
    });
  }

  Future<void> _initializeExercise(String patientId, int startId, NotificationDetails channel) async {
    await _cleanNotifications(startId);
    firebaseDatabase.ref().child("Patient").child(patientId).child('ToDo').child("Exercise").onValue.listen((event) async {
      var snapshot = event.snapshot;
      if (snapshot.value == null) return;

      List<Exercise> exercises = GenericConverter.genericFromDataSnapshotList("exercise", snapshot, false);

      for (var exercise in exercises) {
        if (exercise.initialDate != null && exercise.finalDate != null && exercise.times != null) {
          for (var time in exercise.times!) {
            DateTime? initial = DateHelper.addTimeToDate(time, exercise.initialDate);
            DateTime? finalDate = DateHelper.addTimeToDate(time, exercise.finalDate);
            if (initial == null || finalDate == null) continue;

            for (int i = initial.millisecondsSinceEpoch; i <= finalDate.millisecondsSinceEpoch; i += dayInMilliseconds) {
              DateTime notificationTime = DateTime.fromMillisecondsSinceEpoch(i);
              if (notificationTime.isAfter(DateTime.now())) {
                await singleNotification(
                  channel: channel,
                  startId: startId,
                  title: "Atenção!!",
                  body: "Não se esqueça de se exercitar hoje",
                  datetime: notificationTime,
                );
              }
            }
          }
        }
      }
    });
  }

  Future<void> _initializeLiquid(String patientId, int startId, NotificationDetails channel) async {
    await _cleanNotifications(startId);
    int toDoCount = 0; 

    firebaseDatabase.ref().child("Patient").child(patientId).child('ToDo').child("Liquid").orderByChild("initialdate").onValue.listen((event) {
      toDoCount = 0;
      var snapshot = event.snapshot;
      if (snapshot.value == null) return;
      List<Liquid> toDoLiquids = GenericConverter.genericFromDataSnapshotList("liquid", snapshot, false);
      for (var liq in toDoLiquids) {
        DateTime? initDate = DateHelper.addTimeToDate("00:00", liq.initialDate);
        DateTime? finDate = DateHelper.addTimeToDate("23:59", liq.finalDate);
        if (initDate != null && finDate != null && DateTime.now().isAfter(initDate) && DateTime.now().isBefore(finDate)) {
          toDoCount += (liq.mililitersPerDay ?? 0);
        }
      }
    });

    firebaseDatabase.ref().child("Patient").child(patientId).child('Done').child("Liquid").orderByChild("executedDate").onValue.listen((event) async {
      int count = 0;
      var snapshot = event.snapshot;
      if (snapshot.value == null) return;

      List<Liquid> liquids = GenericConverter.genericFromDataSnapshotList("liquid", snapshot, true);
      for (var liquid in liquids) {
        if (liquid.quantity != null && liquid.reference != null) {
          int refValue = Arrays.reference[liquid.reference] ?? 0;
          count += (refValue * liquid.quantity!);
        }
      }

      if (toDoCount == 0) return;
      
      if (count >= (toDoCount * 0.8) && count < toDoCount * 0.9) {
        await singleNotification(
            channel: channel,
            datetime: DateTime.now().add(const Duration(seconds: 3)),
            title: "Limite de Líquidos próximo",
            body: "Você já tomou mais de 80% do volume recomendado para hoje",
            startId: startId);
      } else if (count >= toDoCount) {
        await singleNotification(
            channel: channel,
            datetime: DateTime.now().add(const Duration(seconds: 3)),
            title: "Limite de Líquidos excedido",
            body: "Você já excedeu o volume de líquidos recomendado para hoje",
            startId: startId);
      }
    });
  }

  Future<void> _initializeMedication(String patientId, int startId, NotificationDetails channel) async {
    await _cleanNotifications(startId);
    firebaseDatabase.ref().child("Patient").child(patientId).child('ToDo').child("Medication").onValue.listen((event) async {
      var snapshot = event.snapshot;
      if (snapshot.value == null) return;

      List<Medication> medications = GenericConverter.genericFromDataSnapshotList("medication", snapshot, false);

      for (var medication in medications) {
        if (medication.initialDate != null && medication.finalDate != null && medication.times != null) {
          for (var time in medication.times!) {
            DateTime? initial = DateHelper.addTimeToDate(time, medication.initialDate);
            DateTime? finalDate = DateHelper.addTimeToDate(time, medication.finalDate);
            if (initial == null || finalDate == null) continue;

            for (int i = initial.millisecondsSinceEpoch; i <= finalDate.millisecondsSinceEpoch; i += dayInMilliseconds) {
              DateTime notificationTime = DateTime.fromMillisecondsSinceEpoch(i);
              if (notificationTime.isAfter(DateTime.now())) {
                await singleNotification(
                  channel: channel,
                  startId: startId,
                  title: medication.name ?? "Medicamento",
                  body: "Hora de tomar seu medicamento: ${medication.name}",
                  datetime: notificationTime,
                );
              }
            }
          }
        }
      }
    });
  }
}