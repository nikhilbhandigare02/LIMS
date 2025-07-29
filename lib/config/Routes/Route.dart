import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_inspector/config/Routes/RouteName.dart';
import 'package:food_inspector/features/FAQ/view/FAQScreen.dart';
import 'package:food_inspector/features/Help_Support/view/Help_Suport.dart';
import 'package:food_inspector/features/Setting/view/Setting.dart';
import 'package:food_inspector/features/home/view/HomeScreen.dart';
import 'package:food_inspector/features/login/view/LoginScreen.dart';
import 'package:food_inspector/features/profile/view/ProfileScreen.dart';
import 'package:food_inspector/features/splash/view/SplashScreen.dart';

class Routes{
static Route<dynamic> generateRoute(RouteSettings setting){
  switch (setting.name){
    case RouteName.splashScreen:
      return  MaterialPageRoute(builder: (context) => Splashscreen(),);
    case RouteName.homeScreen:
      return  MaterialPageRoute(builder: (context) => Homescreen(),);
    case RouteName.loginScreen:
      return  MaterialPageRoute(builder: (context) => Loginscreen(),);
    case RouteName.profileScreen:
      return  MaterialPageRoute(builder: (context) => Profilescreen(),);
    case RouteName.faqScreen:
      return  MaterialPageRoute(builder: (context) => Faqscreen(),);
    case RouteName.supportScreen:
      return  MaterialPageRoute(builder: (context) => HelpSuport(),);
    case RouteName.settingScreen:
      return  MaterialPageRoute(builder: (context) => Setting(),);
    default:
      return MaterialPageRoute(builder: (context) {
        return Scaffold(
          body: Text('No Route Found'),
        );
      });
  }
}
}