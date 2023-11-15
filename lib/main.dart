import 'package:flutter/material.dart';
import 'package:flutter_learning/view/Home_Screen.dart';
import 'package:flutter_learning/view/user_login.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          // primaryColor: Color(0xFF075E54),
          colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.teal, accentColor: Color(0XFF128C7E))),
      home: LoginPage(),
    );
  }
}
