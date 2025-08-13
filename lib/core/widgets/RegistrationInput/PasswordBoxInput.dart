import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../config/Themes/colors/colorsTheme.dart';

class PasswordBoxInput extends StatefulWidget {
  final String label;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final int length;
  final bool obscureText;

  const PasswordBoxInput({
    super.key,
    required this.label,
    this.validator,
    this.onChanged,
    this.length = 6, // default 6 digits for OTP
    this.obscureText = true,
  });

  @override
  State<PasswordBoxInput> createState() => _PasswordBoxInputState();
}

class _PasswordBoxInputState extends State<PasswordBoxInput> {
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];
  String _password = '';

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.length; i++) {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length == 1) {
      // Move to next box
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else if (value.isEmpty && index > 0) {
      // Move to previous box on backspace
      _focusNodes[index - 1].requestFocus();
    }

    // Update password string
    _password = _controllers.map((controller) => controller.text).join();
    widget.onChanged?.call(_password);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(widget.length, (index) {
                return Container(
                  width: 40, // smaller width
                  height: 40, // smaller height
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: _focusNodes[index].hasFocus
                            ? customColors.primary
                            : Colors.grey[400]!,
                        width: 2,
                      ),
                    ),
                    color: Colors.transparent,
                  ),
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    obscureText: widget.obscureText,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(1),
                    ],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: customColors.primary,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (value) => _onChanged(value, index),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
