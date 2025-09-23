import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_inspector/config/Routes/RouteName.dart';

import '../FORM6/bloc/Form6Bloc.dart';
import '../FORM6/repository/form6Repository.dart';
import '../FORM6/view/form6_landing_screen.dart';
import '../login/view/LoginScreen.dart';

class SplashService {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  void isLogin(BuildContext context) async {
    Timer(
      const Duration(seconds: 3),
          () {
        // Navigate to login screen in all cases; the login screen will handle
        // whether to show quick login options (biometric/password-only)
        // based on previously saved login state in secure storage.
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteName.loginScreen,
              (route) => false,
        );
        }
    );
  }
}
