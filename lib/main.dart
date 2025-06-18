import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:fully_tamil/pages/login/home_page.dart'; // Import your login page
import 'package:fully_tamil/pages/login/routes.dart'; // Import your routes
import 'package:fully_tamil/pages/SplashView.dart'; // Import your splash screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: Platform.isAndroid
        ? const FirebaseOptions(
            apiKey: "AIzaSyDqZBqEB9G-xCLX7UvbMLzCLCaZwFnibro",
            appId: "1:157129670943:android:356d5d62939e4c1548302a",
            messagingSenderId: "157129670943",
            projectId: "fully-tamil")
        : null,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: SplashRoute,
      routes: routes,
      title: 'FULLY TAMIL',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashView(), // Splash screen to decide initial page
    );
  }
}
