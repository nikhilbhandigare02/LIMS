import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('About Us'),
      //   centerTitle: true,
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      //   foregroundColor: Colors.blue, // Text & icon color
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back_ios),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      // ),
      // backgroundColor: Colors.white,
      // body: Padding(
      //   padding: const EdgeInsets.all(24.0),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     children: [
      //       // Logo centered
      //       Center(
      //         child: Image.asset(
      //           'assets/logo.png',
      //           height: 80,
      //           fit: BoxFit.contain,
      //         ),
      //       ),
      //
      //       const SizedBox(height: 32),
      //
      //       // Title
      //       const Text(
      //         'Empowering Businesses with 360° Tech Solutions',
      //         textAlign: TextAlign.center,
      //         style: TextStyle(
      //           fontSize: 22,
      //           fontWeight: FontWeight.bold,
      //           color: Colors.black87,
      //         ),
      //       ),
      //
      //       const SizedBox(height: 16),
      //
      //       // Description
      //       const Text(
      //         'Alphonsol is a new-age 360-degree technology solution provider offering end-to-end services — from product conceptualization to maturity. With 15 years of experience, Alphonsol delivers embedded tech to changemakers across Healthcare, Insurance, and Banking.',
      //         textAlign: TextAlign.center,
      //         style: TextStyle(
      //           fontSize: 16,
      //           color: Colors.black54,
      //           height: 1.5,
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
