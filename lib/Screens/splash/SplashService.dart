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

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (_) => BlocProvider(
          //       create: (_) => SampleFormBloc(form6repository: Form6Repository()),
          //       child: Form6LandingScreen(),
          //     ),
          //   ),
          // );
        }
      },
    );
  }
}
