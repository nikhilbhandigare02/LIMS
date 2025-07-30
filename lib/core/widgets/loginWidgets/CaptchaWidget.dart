import 'dart:math';
import 'package:flutter/material.dart';
import '../../../config/Themes/colors/colorsTheme.dart';

class CaptchaWidget extends StatefulWidget {
  final TextEditingController controller;

  const CaptchaWidget({super.key, required this.controller});

  @override
  State<CaptchaWidget> createState() => _CaptchaWidgetState();
}

class _CaptchaWidgetState extends State<CaptchaWidget> {
  late String _captchaCode;

  @override
  void initState() {
    super.initState();
    _generateCaptcha();
  }

  void _generateCaptcha() {
    setState(() {
      _captchaCode = _generateRandomCode(6);
    });
  }

  String _generateRandomCode(int length) {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rand = Random();
    return List.generate(length, (index) => chars[rand.nextInt(chars.length)]).join();
  }

  bool validateCaptcha() {
    return widget.controller.text.trim().toUpperCase() == _captchaCode;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // CAPTCHA Display
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: customColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: customColors.black87.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _captchaCode,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
              IconButton(
                icon: Icon(Icons.refresh, color: customColors.black87),
                onPressed: _generateCaptcha,
                tooltip: "Refresh Captcha",
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Input Field
        TextFormField(
          controller: widget.controller,
          decoration: const InputDecoration(
            labelText: "Enter Captcha",
            border: OutlineInputBorder(),
          ),
          validator: (_) {
            if (!validateCaptcha()) {
              return "Captcha does not match";
            }
            return null;
          },
        ),
      ],
    );
  }
}