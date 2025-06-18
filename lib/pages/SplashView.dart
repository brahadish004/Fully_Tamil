import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fully_tamil/pages/login/shared_preferences_service.dart';
import 'package:fully_tamil/pages/login/routes.dart';
import 'package:fully_tamil/pages/home.dart';
import 'package:fully_tamil/pages/login/home_page.dart';

class SplashView extends StatefulWidget {
  @override
  SplashViewState createState() => SplashViewState();
}

class SplashViewState extends State<SplashView> {
  final PrefService _prefService = PrefService();

  @override
  void initState() {
    super.initState();

    _prefService.readCache("password").then((value) {
      print(value.toString());
      if (value != null) {
        return Timer(Duration(seconds: 0),
            () => Navigator.of(context).pushNamed(HomeRoute));
      } else {
        return Timer(Duration(seconds: 0),
            () => Navigator.of(context).pushNamed(LoginRoute));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/Tamil_Logo.png"),
      ),
    );
  }
}
