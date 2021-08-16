import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings('mipmap/ic_launcher'));

    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      //that payloasd i swroking as a route string
      if (payload != null) Navigator.of(context).pushNamed(payload);
    });
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
              "mychannel", "mychannel channel", "this is our channel",
              importance: Importance.max, priority: Priority.high));
      await _notificationsPlugin.show(id, message.notification!.title,
          message.notification!.title, notificationDetails,
          payload: message.data["route"]);
    } catch (e) {
      print('this is the exception from notification channe ' + e.toString());
    }
  }
}
