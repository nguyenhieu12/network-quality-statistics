import 'package:firebase_messaging/firebase_messaging.dart';

class Messaging {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    final token = await _firebaseMessaging.getToken();

    print('Token: $token');

    _firebaseMessaging.subscribeToTopic('topic');

    // FirebaseMessaging.onBackgroundMessage(handleMessage);
  }

  // Future<void> handleMessage(RemoteMessage message) async {
  //   print('Title: ${message.notification!.title ?? 'Null'}');
  //   print('Body: ${message.notification!.body ?? 'Null'}');
  //   print('Payload: ${message.data}');
  // }
}
