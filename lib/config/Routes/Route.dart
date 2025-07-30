import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_inspector/config/Routes/RouteName.dart';


import '../../Screens/FAQ/view/FAQScreen.dart';
import '../../Screens/Help_Support/view/Help_Suport.dart';
import '../../Screens/Setting/view/Setting.dart';
import '../../Screens/home/view/HomeScreen.dart';
import '../../Screens/login/view/LoginScreen.dart';
import '../../Screens/profile/view/ProfileScreen.dart';
import '../../Screens/splash/view/SplashScreen.dart';

class Routes{
static Route<dynamic> generateRoute(RouteSettings setting){
  switch (setting.name){
    case RouteName.splashScreen:
      return  MaterialPageRoute(builder: (context) => Splashscreen(),);
    case RouteName.homeScreen:
      return  MaterialPageRoute(builder: (context) => Homescreen(),);
    case RouteName.loginScreen:
      return  MaterialPageRoute(builder: (context) => LoginScreen(),);
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