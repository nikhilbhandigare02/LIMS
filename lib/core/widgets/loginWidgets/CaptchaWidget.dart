import 'dart:math';
import 'package:flutter/material.dart';
import 'package:food_inspector/core/utils/validators.dart';
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
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
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
                icon: const Icon(Icons.refresh, color: customColors.black87),
                onPressed: _generateCaptcha,
                tooltip: "Refresh Captcha",
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        // CAPTCHA Input Field
        Container(
          decoration: BoxDecoration(
            color: customColors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextFormField(
            controller: widget.controller,
            style: const TextStyle(fontSize: 16, color: customColors.black87),
            decoration: InputDecoration(
              hintText: 'Enter Captcha',
              hintStyle: const TextStyle(fontSize: 16),
              prefixIcon: const Icon(Icons.verified_user_outlined, color: customColors.primary),
              filled: true,
              fillColor: customColors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: customColors.greyDivider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: customColors.primary, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: customColors.greyDivider),
              ),
            ),
            validator: Validators.validateCaptcha,
          ),
        ),
      ],
    );
  }
}
