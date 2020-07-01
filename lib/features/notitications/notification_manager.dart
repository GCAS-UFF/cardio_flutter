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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meta/meta.dart';

class NotificationManager {
  static const int APPOINTMENT_NOTIFICATION_ID = 50;
  static const int BIOMETRIC_NOTIFICATION_ID = 60;
  static const int EXERCISE_NOTIFICATION_ID = 70;
  static const int LIQUID_NOTIFICATION_ID = 80;
  static const int MEDICATION_NOTIFICATION_ID = 90;

  final int dayInMiliseconds = 24 * 60 * 60 * 1000;

  // Create channels
  var _appointmentChannel = _createChannel("Appointments");
  var _biometricChannel = _createChannel("Biometrics");
  var _exerciseChannel = _createChannel("Exercise");
  var _liquidChannel = _createChannel("Liquids");
  var _medicationChannel = _createChannel("Medication");

  final FlutterLocalNotificationsPlugin localNotificationsPlugin;
  final FirebaseDatabase firebaseDatabase;
  final Settings settings;

  NotificationManager(
      {@required this.localNotificationsPlugin,
      @required this.firebaseDatabase,
      @required this.settings});

  Future<void> init() async {
    if (settings.getUserType() == null ||
        settings.getUserType() != Keys.PATIENT_TYPE) {
      return;
    }
    String patientId = settings.getUserId();

    await _initializeNotifications();

    await _initializeAppointment(
        patientId, APPOINTMENT_NOTIFICATION_ID, _appointmentChannel);
    await _initializeBiometric(
        patientId, BIOMETRIC_NOTIFICATION_ID, _biometricChannel);
    await _initializeExercise(
        patientId, EXERCISE_NOTIFICATION_ID, _exerciseChannel);
    await _initializeLiquid(patientId, LIQUID_NOTIFICATION_ID, _liquidChannel);
    await _initializeMedication(
        patientId, MEDICATION_NOTIFICATION_ID, _medicationChannel);
  }

  Future<void> _initializeNotifications() async {
    var initializeAndroid = AndroidInitializationSettings('app_logo');
    var initializeIOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(initializeAndroid, initializeIOS);
    await localNotificationsPlugin.initialize(initSettings);
  }

  static NotificationDetails _createChannel(String channelName) {
    var androidChannel = AndroidNotificationDetails(
      channelName,
      channelName,
      channelName,
      styleInformation: BigTextStyleInformation(""),
      importance: Importance.Max,
      priority: Priority.Max,
    );
    var iosChannel = IOSNotificationDetails();
    return NotificationDetails(androidChannel, iosChannel);
  }

  Future singleNotification(
      {@required NotificationDetails channel,
      @required DateTime datetime,
      @required String title,
      @required String body,
      @required int startId,
      String sound}) async {
    int id = _generateNotificationId(startId);
    localNotificationsPlugin.schedule(id, title, body, datetime, channel,
        payload: id.toString());
  }

  int _generateNotificationId(int startId) {
    var rng = new Random();
    String id = "$startId${rng.nextInt(99999)}";
    return int.parse(id);
  }

  Future<void> _cleanNotifications(int startId) async {
    var notifications =
        await localNotificationsPlugin.pendingNotificationRequests();
    notifications.forEach(
      (element) {
        String currentId = element.id.toString();
        if (currentId.startsWith(startId.toString())) {
          localNotificationsPlugin.cancel(element.id);
        }
      },
    );
  }

  Future<void> _initializeAppointment(
      String patientId, int startId, NotificationDetails channel) async {
    await _cleanNotifications(startId);

    firebaseDatabase
        .reference()
        .child("Patient")
        .child(patientId)
        .child('ToDo')
        .child("Appointment")
        .onValue
        .listen((event) async {
      var snapshot = event.snapshot;
      if (snapshot == null) return;

      print("[Appointment] ${snapshot.value}");

      List<Appointment> appointments =
          GenericConverter.genericFromDataSnapshotList(
              "appointment", snapshot, false);

      appointments.forEach((appointment) async {
        if (appointment.appointmentDate != null &&
            appointment.appointmentDate.millisecondsSinceEpoch >
                DateTime.now().millisecondsSinceEpoch) {
          DateTime oneDayBefore =
              appointment.appointmentDate.subtract(new Duration(days: 1));
          if (oneDayBefore.isAfter(DateTime.now())) {
            await singleNotification(
              channel: channel,
              startId: startId,
              title:
                  "${appointment.expertise} no dia ${DateHelper.convertDateToString(appointment.appointmentDate)}",
              body:
                  "Você possui uma consulta de ${appointment.expertise} às ${DateHelper.getTimeFromDate(appointment.appointmentDate)} em ${appointment.adress}",
              datetime: oneDayBefore,
            );
          }

          DateTime hoursBefore =
              appointment.appointmentDate.subtract(new Duration(hours: 2));
          if (hoursBefore.isAfter(DateTime.now())) {
            await singleNotification(
              channel: channel,
              startId: startId,
              title:
                  "${appointment.expertise} no dia ${DateHelper.convertDateToString(appointment.appointmentDate)}",
              body:
                  "Você possui uma consulta de ${appointment.expertise} às ${DateHelper.getTimeFromDate(appointment.appointmentDate)} em ${appointment.adress}",
              datetime: hoursBefore,
            );
          }
        }
      });
    });
  }

  Future<void> _initializeBiometric(
      String patientId, int startId, NotificationDetails channel) async {
    //Clean all current notifications
    await _cleanNotifications(startId);
    // Getting firebase reference and start listen for changes
    firebaseDatabase
        .reference()
        .child("Patient")
        .child(patientId)
        .child('ToDo')
        .child("Biometric")
        .onValue
        .listen((event) async {
      // Get changed snapshot
      var snapshot = event.snapshot;
      // Don't do nothing if theres no record
      if (snapshot == null) return;

      print("[Biometic] ${snapshot.value}");

      //Get list of all entries
      List<Biometric> biometrics = GenericConverter.genericFromDataSnapshotList(
          "biometric", snapshot, false);

      // Set a new alarm for each combination of day and time
      biometrics.forEach((biometric) {
        if (biometric != null &&
            biometric.initialDate != null &&
            biometric.finalDate != null &&
            biometric.times != null) {
          // Go through all the times registred
          biometric.times.forEach(
            (time) async {
              int initialTime =
                  DateHelper.addTimeToDate(time, biometric.initialDate)
                      .millisecondsSinceEpoch;
              int finalTime =
                  DateHelper.addTimeToDate(time, biometric.finalDate)
                      .millisecondsSinceEpoch;
              // Go to all days corresponding to all times
              for (int i = initialTime;
                  i <= finalTime;
                  i = i + dayInMiliseconds) {
                DateTime notificationTime =
                    DateTime.fromMillisecondsSinceEpoch(i);
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
            },
          );
        }
      });
    });
  }

  Future<void> _initializeExercise(
      String patientId, int startId, NotificationDetails channel) async {
    //Clean all current notifications
    await _cleanNotifications(startId);
    // Getting firebase reference and start listen for changes
    firebaseDatabase
        .reference()
        .child("Patient")
        .child(patientId)
        .child('ToDo')
        .child("Exercise")
        .onValue
        .listen((event) async {
      // Get changed snapshot
      var snapshot = event.snapshot;
      // Don't do nothing if theres no record
      if (snapshot == null) return;

      print("[Exercise] ${snapshot.value}");

      //Get list of all entries
      List<Exercise> exercises = GenericConverter.genericFromDataSnapshotList(
          "exercise", snapshot, false);

      // Set a new alarm for each combination of day and time
      exercises.forEach((exercise) {
        if (exercise != null &&
            exercise.initialDate != null &&
            exercise.finalDate != null &&
            exercise.times != null) {
          // Go through all the times registred
          exercise.times.forEach(
            (time) async {
              int initialTime =
                  DateHelper.addTimeToDate(time, exercise.initialDate)
                      .millisecondsSinceEpoch;
              int finalTime = DateHelper.addTimeToDate(time, exercise.finalDate)
                  .millisecondsSinceEpoch;
              // Go to all days corresponding to all times
              for (int i = initialTime;
                  i <= finalTime;
                  i = i + dayInMiliseconds) {
                DateTime notificationTime =
                    DateTime.fromMillisecondsSinceEpoch(i);
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
            },
          );
        }
      });
    });
  }

  Future<void> _initializeLiquid(
      String patientId, int startId, NotificationDetails channel) async {
    //Clean all current notifications
    await _cleanNotifications(startId);
    int toDoCount;

    //Count mililiters recomenden to drink that day
    firebaseDatabase
        .reference()
        .child("Patient")
        .child(patientId)
        .child('ToDo')
        .child("Liquid")
        .orderByChild("initialdate")
        .onValue
        .listen((event) async {
      toDoCount = 0;
      var toDoSsnapshot = event.snapshot;
      if (toDoSsnapshot == null) return;
      List<Liquid> toDoLiquids = GenericConverter.genericFromDataSnapshotList(
          "liquid", toDoSsnapshot, false);
      toDoLiquids.forEach((toDoLiquid) {
        if (DateTime.now().isAfter(
                DateHelper.addTimeToDate("00:00", toDoLiquid.initialDate)) &&
            DateTime.now().isBefore(
                DateHelper.addTimeToDate("23:59", toDoLiquid.finalDate))) {
          toDoCount = toDoCount + toDoLiquid.mililitersPerDay;
        }
      });
    });
    // Getting firebase reference and start listen for changes
    firebaseDatabase
        .reference()
        .child("Patient")
        .child(patientId)
        .child('Done')
        .child("Liquid")
        .orderByChild("executedDate")
        .onValue
        .listen((event) async {
      int count = 0;
      // Get changed snapshot
      var snapshot = event.snapshot;
      // Don't do nothing if theres no record
      if (snapshot == null) return;

      print("[Liquid] ${snapshot.value}");

      //Get list of all entries
      List<Liquid> liquids = GenericConverter.genericFromDataSnapshotList(
          "liquid", snapshot, true);

      // Set a new alarm for each combination of day and time, só que não
      liquids.forEach((liquid) async {
        if (liquid != null &&
            liquid.executedDate != null &&
            liquid.quantity != null &&
            liquid.reference != null) {
          count =
              count + (Arrays.reference[liquid.reference] * liquid.quantity);
          print("count:$count");
          print("todocount:$toDoCount");
        }
      });
      if (toDoCount == null || toDoCount == 0) return;
      if (count >= (toDoCount * 0.8) && count < toDoCount * 0.9) {
        await singleNotification(
            channel: channel,
            datetime: DateTime.now().add(Duration(seconds: 3)),
            title: "Limite de Líquidos ingeridos próximo",
            body:
                "Você já tomou mais de 80% do volume de líquidos ingeridos recomendado para hoje",
            startId: startId);
      } else if (count >= (toDoCount * 0.9) && count < toDoCount * 1) {
        await singleNotification(
            channel: channel,
            datetime: DateTime.now().add(Duration(seconds: 3)),
            title: "Limite de Líquidos ingeridos próximo",
            body:
                "Você já tomou mais de 90% do volume de líquidos ingeridos recomendado para hoje",
            startId: startId);
      } else if (count >= toDoCount) {
        singleNotification(
            channel: channel,
            datetime: DateTime.now().add(Duration(seconds: 3)),
            title: "Limite de Líquidos ingeridos excedido",
            body:
                "Você já excedeu o volume de líquidos ingeridos recomendado para hoje",
            startId: startId);
      } else {
        return;
      }
    });
  }

  Future<void> _initializeMedication(
      String patientId, int startId, NotificationDetails channel) async {
    //Clean all current notifications
    await _cleanNotifications(startId);
    // Getting firebase reference and start listen for changes
    firebaseDatabase
        .reference()
        .child("Patient")
        .child(patientId)
        .child('ToDo')
        .child("Medication")
        .onValue
        .listen((event) async {
      // Get changed snapshot
      var snapshot = event.snapshot;
      // Don't do nothing if theres no record
      if (snapshot == null) return;

      print("[Medication] ${snapshot.value}");

      //Get list of all entries
      List<Medication> medications =
          GenericConverter.genericFromDataSnapshotList(
              "medication", snapshot, false);

      // Set a new alarm for each combination of day and time
      medications.forEach((medication) {
        if (medication != null &&
            medication.initialDate != null &&
            medication.finalDate != null &&
            medication.times != null) {
          // Go through all the times registred
          medication.times.forEach(
            (time) {
              int initialTime =
                  DateHelper.addTimeToDate(time, medication.initialDate)
                      .millisecondsSinceEpoch;
              int finalTime =
                  DateHelper.addTimeToDate(time, medication.finalDate)
                      .millisecondsSinceEpoch;
              // Go to all days corresponding to all times
              for (int i = initialTime;
                  i <= finalTime;
                  i = i + dayInMiliseconds) {
                DateTime notificationTime =
                    DateTime.fromMillisecondsSinceEpoch(i);
                if (notificationTime.isAfter(DateTime.now())) {
                  singleNotification(
                    channel: channel,
                    startId: startId,
                    title: medication.name,
                    body:
                        "Você precisa consumir ${medication.quantity} de ${medication.dosage} de ${medication.name}",
                    datetime: notificationTime,
                  );
                }
              }
            },
          );
        }
      });
    });
  }
}
