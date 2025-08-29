import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_inspector/config/Routes/RouteName.dart';

class SplashService {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  void isLogin(BuildContext context) async {
    final String? loginFlag = await secureStorage.read(key: 'isLogin');
    final String? verifyflag = await secureStorage.read(key: 'isVerify');

    Timer(
      const Duration(seconds: 3),
          () {
        if (loginFlag == '1' && verifyflag == '1') {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteName.SampleAnalysisScreen,
                (route) => false,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteName.loginScreen,
                (route) => false,
          );
        }
      },
    );
  }
}
