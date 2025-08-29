import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/widgets/AppHeader/AppHeader.dart';

class Requestsealnumber extends StatefulWidget {
  const Requestsealnumber({super.key});

  @override
  State<Requestsealnumber> createState() => _RequestsealnumberState();
}

class _RequestsealnumberState extends State<Requestsealnumber> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        screenTitle: 'Form VI',
        username: 'Rajan',
        userId: 'S1234',
        showBack: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(),
      ),

    );
  }
}
