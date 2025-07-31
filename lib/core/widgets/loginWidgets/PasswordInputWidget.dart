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
          child: TextFormField(
            focusNode: widget.passwordFocusNode,
            obscureText: _obscureText,
            style: const TextStyle(fontSize: 16, color: customColors.black87),
            decoration: InputDecoration(
              hintText: 'Enter your password',
              hintStyle: const TextStyle(fontSize: 16),
              prefixIcon: const Icon(Icons.lock_outline, color: customColors.primary),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: customColors.black87,
                ),
                onPressed: _toggleVisibility,
              ),
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) {
              context.read<LoginBloc>().add(PasswordEvent(password: value));
            },
            validator: (value) => Validators.validateEmptyField(value, 'Password'),
          ),
        );
      },
    );
  }
}
