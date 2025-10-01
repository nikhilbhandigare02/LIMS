import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_inspector/config/Routes/RouteName.dart';



class SplashService {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  void isLogin(BuildContext context) async {
    Timer(
      const Duration(seconds: 3),
          () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteName.loginScreen,
              (route) => false,
        );
        }
    );
  }
}
