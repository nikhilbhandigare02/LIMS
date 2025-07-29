import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/AppHeader/AppHeader.dart';

class HelpSuport extends StatefulWidget {
  const HelpSuport({super.key});

  @override
  State<HelpSuport> createState() => _HelpSuportState();
}

class _HelpSuportState extends State<HelpSuport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        screenTitle: "Help & Support",
        username: "Rajeev Ranjan",
        userId: "394884",
        showBack: true,
      ),
    );
  }
}
