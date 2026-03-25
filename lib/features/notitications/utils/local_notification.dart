import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({super.key});

  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    tz.initializeTimeZones();
    
    var initializeAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializeDarwin = const DarwinInitializationSettings(); 
    
    var initSettings = InitializationSettings(
      android: initializeAndroid, 
      iOS: initializeDarwin,
    );

    // CORREÇÃO FINAL: O parâmetro obrigatório é 'settings'
    await localNotificationsPlugin.initialize(
      settings: initSettings, 
    );
  }

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  Future<void> singleNotification(
      DateTime datetime, String message, String subtext, int hashcode) async {
    
    var androidChannel = const AndroidNotificationDetails(
      'channel-id',
      'channel-name',
      channelDescription: 'channel-description',
      importance: Importance.max,
      priority: Priority.max,
    );

    var platformChannel = NotificationDetails(
      android: androidChannel, 
      iOS: const DarwinNotificationDetails(),
    );

    // CORREÇÃO: Parâmetros nomeados conforme a versão estável mais recente
    await localNotificationsPlugin.zonedSchedule(
      id: hashcode,
      title: message,
      body: subtext,
      scheduledDate: tz.TZDateTime.from(datetime, tz.local),
      notificationDetails: platformChannel,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: hashcode.toString(),
    );
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    tz.initializeTimeZones();
    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var darwin = const DarwinInitializationSettings();
    var initSettings = InitializationSettings(android: android, iOS: darwin);
    
    // Ajuste do parâmetro nomeado para 'settings'
    await localNotificationsPlugin.initialize(settings: initSettings); 
  }

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  Future<void> singleNotification(
      DateTime datetime, String message, String subtext, int hashcode) async {
    
    var androidChannel = const AndroidNotificationDetails(
      'channel-id',
      'channel-name',
      channelDescription: 'channel-description',
      importance: Importance.max,
      priority: Priority.max,
    );

    var platformChannel = NotificationDetails(
      android: androidChannel, 
      iOS: const DarwinNotificationDetails(),
    );

    await localNotificationsPlugin.zonedSchedule(
      id: hashcode,
      title: message,
      body: subtext,
      scheduledDate: tz.TZDateTime.from(datetime, tz.local),
      notificationDetails: platformChannel,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Example')),
      body: const Center(child: Text('Notification App')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.notifications),
        onPressed: () async {
          DateTime scheduledDate = DateTime.now().add(const Duration(seconds: 5));
          await singleNotification(
            scheduledDate,
            "Tomar Remédio",
            "Não esqueça da medicação",
            98123871,
          );
        },
      ),
    );
  }
}