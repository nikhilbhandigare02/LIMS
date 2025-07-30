import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Screens/login/bloc/loginBloc.dart';
import '../../../config/Themes/colors/colorsTheme.dart';
import '../../utils/validators.dart';

class PasswordInput extends StatefulWidget {
  final FocusNode passwordFocusNode;
  final formkey;

  const PasswordInput({
    super.key,
    required this.formkey,
    required this.passwordFocusNode,
  });

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (current, previous) => current.password != previous.password,
      builder: (context, state) {
        return TextFormField(
          focusNode: widget.passwordFocusNode,
          obscureText: _obscureText,
          style: const TextStyle(fontSize: 16, color: customColors.black87),
          decoration: InputDecoration(
            hintText: 'Enter your password',
            hintStyle: TextStyle( fontSize: 16),
            prefixIcon: const Icon(Icons.lock_outline, color: customColors.primary),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: customColors.black87,
              ),
              onPressed: _toggleVisibility,
            ),
            filled: true,
            fillColor: customColors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: customColors.greyDivider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: customColors.primary, width: 0.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: customColors.greyDivider),
            ),
          ),
          onChanged: (value) {
            context.read<LoginBloc>().add(PasswordEvent(password: value));
          },
          onFieldSubmitted: (value) {},
          validator: (value) => Validators.validateEmptyField(value, 'Password'),
        );
      },
    );
  }
}
