import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
        children: [
          TextSpan(
            text: '© $currentYear Designed & Developed by ',
            style: const TextStyle(
             // fontWeight: FontWeight.bold,
            ),
          ),
          const TextSpan(
            text: 'Alph',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const TextSpan(
            text: 'o',
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          const TextSpan(
            text: 'nsol',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}