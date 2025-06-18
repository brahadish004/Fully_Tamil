import 'package:fully_tamil/pages/login/home_page.dart';
import 'package:fully_tamil/pages/home.dart';
import 'package:fully_tamil/pages/SplashView.dart';

const String SplashRoute = "/splash";
const String HomeRoute = "/main";
const String LoginRoute = "/home";

final routes = {
  SplashRoute: (context) => SplashView(),
  HomeRoute: (context) => MyHomePage(),
  LoginRoute: (context) => Home()
};
