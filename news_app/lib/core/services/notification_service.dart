import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  Future<void> initialize() async {
    if (Firebase.apps.isEmpty) {
      return;
    }

    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      provisional: false,
      sound: true,
    );
  }
}
