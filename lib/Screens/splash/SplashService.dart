import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:food_inspector/config/Routes/RouteName.dart';

class SplashService {
  void isLodin(BuildContext, context) {
    Timer(
      Duration(seconds: 3),
      () => Navigator.pushNamedAndRemoveUntil(
        context,
        RouteName.loginScreen,
        (route) => false,
      ),
    );
  }
}
