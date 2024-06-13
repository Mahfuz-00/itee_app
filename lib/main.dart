import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:rename_app/rename_app.dart';

import 'UI/Pages/Splashscreen UI/splashscreenUI.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(0, 162, 222, 1), // Change the status bar color here
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ITEE Exam Registration App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(0, 162, 222, 1)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

