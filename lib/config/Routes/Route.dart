import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_inspector/Screens/RequestSlipNumber/requestSlipNumber.dart';
import 'package:food_inspector/Screens/login/OTPVerification/View/OtpVerification.dart';
 import 'package:food_inspector/Screens/login/view/LoginScreen.dart';
import 'package:food_inspector/Screens/registration/view/registration.dart';
import 'package:food_inspector/config/Routes/RouteName.dart';
import '../../Screens/ForgotScreen/View/ForgotScreen.dart';
import '../../Screens/ForgotScreen/View/ResetPasswordScreen.dart';
import '../../Screens/FORM6/view/form6_landing_screen.dart';

import '../../Screens/Help_Support/view/Help_Suport.dart';
import '../../Screens/Sample list/view/SampleList.dart';
import '../../Screens/SlipRequestDetails/SlipRequestDetailsScreen.dart';
import '../../Screens/Setting/view/Setting.dart';
import '../../Screens/UpdateSample/view/UpdateSample.dart';
import '../../Screens/about_us/view/aboutUS.dart';
import '../../Screens/profile/view/ProfileScreen.dart';
import '../../Screens/registration/view/registration.dart';
import '../../Screens/splash/view/SplashScreen.dart';
import '../../Screens/update_password/view/UpdatePassword.dart';

class Routes{
static Route<dynamic> generateRoute(RouteSettings setting){
  switch (setting.name){
    case RouteName.splashScreen:
      return  MaterialPageRoute(builder: (context) => Splashscreen(),);
    case RouteName.homeScreen:
      return  MaterialPageRoute(builder: (context) => Form6LandingScreen(),);
    case RouteName.updateScreen:
      return  MaterialPageRoute(builder: (context) => UpdatePasswordScreen(),);
    case RouteName.forgotPasswordScreen:
      return  MaterialPageRoute(builder: (context) => ForgotScreen(),);
    case RouteName.resetPasswordScreen:
      return  MaterialPageRoute(builder: (context) => ResetPasswordScreen(),);
    case RouteName.loginScreen:
      return  MaterialPageRoute(builder: (context) => LoginScreen(),);
    case RouteName.registrationScreen:
      return  MaterialPageRoute(builder: (context) => RegistrationScreen());
    case RouteName.AboutUsScreen:
      return  MaterialPageRoute(builder: (context) => AboutUsScreen());
    case RouteName.profileScreen:
      return  MaterialPageRoute(builder: (context) => UserProfileScreen(),);
    case RouteName.SampleAnalysisScreen:
      return  MaterialPageRoute(builder: (context) => SampleAnalysisScreen(),);
    case RouteName.supportScreen:
      return  MaterialPageRoute(builder: (context) => HelpSuport(),);
    case RouteName.registerScreen:
      return  MaterialPageRoute(builder: (context) => RegistrationScreen(),);
    case RouteName.settingScreen:
      return  MaterialPageRoute(builder: (context) => Setting(),);
    case RouteName.OTPVerificationScreen:
      return  MaterialPageRoute(builder: (context) => OtpVerificationScreen(),);
    case RouteName.requestForSlip:
      return  MaterialPageRoute(builder: (context) => Requestslipnumber(),);
    case RouteName.SlipRequestDetailsScreen:
      return  MaterialPageRoute(builder: (context) => SealRequestDetailsScreen(),);
    default:
      return MaterialPageRoute(builder: (context) {
        return Scaffold(
          body: Text('No Route Found'),
        );
      });
  }
}
}