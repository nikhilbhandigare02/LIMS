import 'dart:math';
import 'package:flutter/material.dart';
import 'package:food_inspector/core/utils/validators.dart';
import '../../../config/Themes/colors/colorsTheme.dart';

class CaptchaWidget extends StatefulWidget {
  final TextEditingController controller;

  const CaptchaWidget({super.key, required this.controller});

  @override
  State<CaptchaWidget> createState() => CaptchaWidgetState();
}

class CaptchaWidgetState extends State<CaptchaWidget> {
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
    // Clear input so user re-enters for new captcha
    widget.controller.clear();
  }

  void refreshCaptcha() {
    _generateCaptcha();
  }

  String _generateRandomCode(int length) {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rand = Random();
    return List.generate(length, (index) => chars[rand.nextInt(chars.length)]).join();
  }

  String? _validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Captcha is required';
    }
    if (value.trim().toUpperCase() != _captchaCode) {
      return 'Captcha is incorrect';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        // First Column - CAPTCHA Display Section
        Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
    Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
    color:Colors.white,
    borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(
    color: customColors.primary,
    width: 1,
    ),
    ),
    child: Text(
    _captchaCode,
    style: const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: 3,
    color: customColors.primary,
    ),
    ),
    ),
    Container(
    decoration: BoxDecoration(
    color: const Color(0xFF4B3DFE).withOpacity(0.1),
    borderRadius: BorderRadius.circular(8),
    ),
    child: IconButton(
    icon: const Icon(
    Icons.refresh,
    color: customColors.primary,
    ),
    onPressed: _generateCaptcha,
    tooltip: "Refresh Captcha",
    ),
    )
    ],
    ),
    ),
    ],
    ),


    const SizedBox(height: 6),


    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    TextFormField(
    controller: widget.controller,
    style: const TextStyle(
    fontSize: 16,
    color: Colors.black87,
    ),
    decoration: InputDecoration(
    hintText: 'Enter Captcha',
    hintStyle: const TextStyle(
    fontSize: 16,
    color: Colors.grey,
    ),
    prefixIcon: const Icon(
    Icons.verified_user_outlined,
    color: customColors.primary,
    ),
    filled: true,
    fillColor: const Color(0xFFF7F8F9),
    contentPadding: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 16,
    ),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
    color: customColors.primary,
    width: 1.5,
    ),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide.none,
    ),
    errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
    color: Colors.redAccent,
    width: 1.0,
    ),
    ),
    focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
    color: Colors.redAccent,
    width: 1.5,
    ),
    ),
    ),
    validator: _validate,
    ),
    ],
    ),
    ],
    );
  }
}