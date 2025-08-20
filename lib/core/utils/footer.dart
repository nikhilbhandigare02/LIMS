import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '© Designed & Developed by Alphonsol',
      style: TextStyle(
        color: Colors.grey.withOpacity(0.6),
        fontSize: 12,
      ),
      textAlign: TextAlign.center,
    );
  }
}
