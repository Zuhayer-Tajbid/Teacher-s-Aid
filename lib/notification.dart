import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'dart:typed_data';

NotificationDetails notificationDetails() {
  return NotificationDetails(
    android: AndroidNotificationDetails(
      'daily',
      'Daily Notification',
      priority: Priority.high,
      importance: Importance.max,
      styleInformation: BigTextStyleInformation(''),
      vibrationPattern:
          Int64List.fromList([0, 500, 1000, 500]), // Vibrate pattern
      enableVibration: true, // Enable vibration
    ),
    iOS: DarwinNotificationDetails(),
  );
}

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initNotification() async {
    if (_isInitialized) return;

    try {
      tz.initializeTimeZones();
      final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(currentTimeZone));
    } catch (e) {
      print("Error initializing time zones: $e");
    }

    const AndroidInitializationSettings initSettingAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initSettingIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: initSettingAndroid,
      iOS: initSettingIOS,
    );

    await notificationPlugin.initialize(initSettings);

    // Check and request notification permissions for Android 13+
    try {
      if (await notificationPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ==
          false) {
        await notificationPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
      }
    } catch (e) {
      print("Error checking or requesting notification permissions: $e");
    }

    _isInitialized = true;
  }

  NotificationDetails notificationDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'daily',
        'Daily Notification',
        priority: Priority.high,
        importance: Importance.max,
        styleInformation: BigTextStyleInformation(''),
        vibrationPattern:
            Int64List.fromList([0, 500, 1000, 500]), // Vibrate pattern
        enableVibration: true,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    return notificationPlugin.show(id, title, body, notificationDetails());
  }

  Future<void> scheduleNotification({
    int id = 1,
    required String title,
    required String body,
    required DateTime scheduleTime,
    //int minlater = 7,
  }) async {
    try {
      final now = tz.TZDateTime.now(tz.local);
      //var scheduledDate = now.add(Duration(seconds: minlater));
      final tz.TZDateTime tzScheduleTime =
          tz.TZDateTime.from(scheduleTime, tz.local);

      await notificationPlugin.zonedSchedule(
        id,
        title,
        body,
        tzScheduleTime,
        // scheduledDate,
        notificationDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: '',
      );

      print("Notification scheduled");
    } catch (e) {
      print("Error scheduling notification: $e");
    }
  }

  Future<void> cancelAllNotification() async {
    await notificationPlugin.cancelAll();
  }
}
