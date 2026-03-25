import 'package:firebase_messaging/firebase_messaging.dart';

// 1. O handler de segundo plano agora recebe um 'RemoteMessage'
// Ele deve continuar sendo uma função de nível superior (fora de classes)
Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class ExternalNotificationManager {
  final FirebaseMessaging firebaseMessaging;

  // 2. Trocamos @required por required
  ExternalNotificationManager({required this.firebaseMessaging});

  Future<void> init() async {
    // 3. Em vez de 'configure', usamos listeners específicos
    
    // Mensagens com o app em primeiro plano (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: ${message.data}");
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification?.title}');
      }
    });

    // Mensagens quando o usuário clica na notificação com o app em background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp (onResume): ${message.data}");
    });

    // 4. Configura o handler de segundo plano (Background/Terminated)
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

    // 5. Verifica se o app foi aberto através de uma notificação (onLaunch)
    RemoteMessage? initialMessage = await firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      print("getInitialMessage (onLaunch): ${initialMessage.data}");
    }

    // 6. Permissões (Substitui requestNotificationPermissions e IosNotificationSettings)
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: true,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    // 7. Token (ajustado para Null Safety)
    firebaseMessaging.getToken().then((String? token) {
      if (token != null) {
        print("Firebase Token: $token");
      }
    });
  }
}