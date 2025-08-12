import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../config/Themes/colors/colorsTheme.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool obscureText;
  final String value;  // Pass current text here from Bloc state
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
    this.value = '',  // Default empty
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.isPassword = false,
    this.maxLength,
    this.inputFormatters,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
    _controller = TextEditingController(text: widget.value);
    _controller.addListener(() {
      if (widget.onChanged != null && _controller.text != widget.value) {
        widget.onChanged!(_controller.text);
      }
    });
  }

  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      final oldSelection = _controller.selection;
      _controller.text = widget.value;

      final newSelection = oldSelection.baseOffset > widget.value.length
          ? TextSelection.collapsed(offset: widget.value.length)
          : oldSelection;
      _controller.selection = newSelection;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      obscureText: _obscure,
      style: const TextStyle(fontSize: 16, color: customColors.black87),
      decoration: InputDecoration(
        hintText: widget.label,
        hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
        prefixIcon: Icon(widget.icon, color: customColors.primary),
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscure = !_obscure;
            });
          },
        )
            : null,
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
        counterText: widget.maxLength != null ? '' : null,
      ),
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatters,
    );
  }
}
