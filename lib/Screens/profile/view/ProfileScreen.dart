import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/AppHeader/AppHeader.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        screenTitle: "Profile",
        username: "Rajeev Ranjan",
        userId: "394884",
        showBack: true,
      ),
    );
  }
}
