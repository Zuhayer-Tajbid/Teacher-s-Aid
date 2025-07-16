import 'package:flutter/material.dart';
import 'package:practice/notification.dart';
import 'package:practice/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();

  runApp(MaterialApp(
    theme: ThemeData(primarySwatch: Colors.blueGrey),
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
}
