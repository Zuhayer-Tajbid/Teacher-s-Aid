import 'package:flutter/material.dart';
import 'package:practice/result_page.dart';
import 'package:practice/teacher_selection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    loadScreen();
  }

  Future<void> loadScreen() async {
    var preff = await SharedPreferences.getInstance();
    bool isLogged = preff.getBool('isLogged') ?? false;
    String name = preff.getString('name') ?? '';
    String code = preff.getString('code') ?? 'NIM';

    Future.delayed(
      Duration(seconds: 4),
      () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => isLogged
                    ? ResultsPage(selectedTeacher: code, name: name)
                    : TeacherSelectionPage()),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/image/screen.jpg'),
                fit: BoxFit.cover)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/image/logo.png',
              )
            ],
          ),
        ),
      ),
    );
  }
}
