import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title:${message.notification?.title}');
  print('body:${message.notification?.title}');
  print('payload:${message.data}');
}

class firebaseAPI {
  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final FCMToken = await _firebaseMessaging.getToken();
    print('token  voila ca ici  ho : $FCMToken');
    // fWAXLvLZRSGUr2XZ0cgl6I:APA91bHup9nI4Q0PhnDQ8rfbmnMhswM4y9eq7gdrWc1kAFhWyILpIHeL7FcoB9bdD9v8z5y3TacUyCgyyJF_VFBaHamytBjySLz6iz4HAS56QbgVvklSWc8h-9ev_ZRfzDe0sJwcEtvL
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
