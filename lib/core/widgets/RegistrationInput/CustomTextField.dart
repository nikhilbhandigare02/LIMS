import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../config/Themes/colors/colorsTheme.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool obscureText;
  final String value; // controlled input value
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final bool isPassword;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.value = '',
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.isPassword = false,
    this.maxLength,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 16, color: customColors.black87),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
        prefixIcon: Icon(icon, color: customColors.primary),
        filled: true,
        fillColor: const Color(0xFFF7F8F9),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: customColors.primary, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        counterText: maxLength != null ? '' : null,
      ),
      validator: validator,
      keyboardType: keyboardType,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
    );
  }
}



class AnimatedOtpInput extends StatefulWidget {
  final int length;
  final bool obscureText;
  final String value;
  final ValueChanged<String> onChanged;

  const AnimatedOtpInput({
    Key? key,
    this.length = 6,
    this.obscureText = false,
    required this.onChanged, this.value = '',
  }) : super(key: key);

  @override
  _AnimatedOtpInputState createState() => _AnimatedOtpInputState();
}

class _AnimatedOtpInputState extends State<AnimatedOtpInput> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    _controllers = List.generate(widget.length, (_) => TextEditingController());

    for (int i = 0; i < widget.length; i++) {
      _controllers[i].addListener(() {
        final currentText = _controllers.map((c) => c.text).join();
        widget.onChanged(currentText);
      });
    }
  }

  @override
  void dispose() {
    _focusNodes.forEach((fn) => fn.dispose());
    _controllers.forEach((c) => c.dispose());
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.isEmpty) {
      if (index > 0) _focusNodes[index - 1].requestFocus();
    } else {
      if (index + 1 != widget.length) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
  }

  Widget _buildOtpBox(int index) {
    final controller = _controllers[index];
    final focusNode = _focusNodes[index];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 32,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: focusNode.hasFocus ? Colors.blue : Colors.grey.shade400,
            width: focusNode.hasFocus ? 3 : 1.5,
          ),
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        obscureText: widget.obscureText,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: (value) => _onChanged(index, value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) => _buildOtpBox(index)),
    );
  }
}
