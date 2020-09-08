import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  print(message);
}

class ExternalNotificationManager {
  final FirebaseMessaging firebaseMessaging;

  ExternalNotificationManager({@required this.firebaseMessaging});

  void init() {
    firebaseMessaging.configure(
      onBackgroundMessage: myBackgroundMessageHandler,
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print(token);
    });
  }
}
