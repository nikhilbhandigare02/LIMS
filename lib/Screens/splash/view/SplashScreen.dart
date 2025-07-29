import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../SplashService.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  SplashService splashService = SplashService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashService.isLodin(BuildContext, context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Splash Screen'),),
    );
  }
}
