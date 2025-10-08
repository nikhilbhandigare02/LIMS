import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_inspector/Screens/update_password/BLOC/UpdatePassBloc.dart';
import '../../../Screens/login/bloc/loginBloc.dart';
import '../../../config/Themes/colors/colorsTheme.dart';
import '../../utils/validators.dart';

class ConfirmPasswordInput extends StatefulWidget {
  final FocusNode passwordFocusNode;
  final formkey;

  const ConfirmPasswordInput({
    super.key,
    required this.formkey,
    required this.passwordFocusNode,
  });

  @override
  State<ConfirmPasswordInput> createState() => _ConfirmPasswordInputState();
}

class _ConfirmPasswordInputState extends State<ConfirmPasswordInput> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdatePasswordBloc, UpdatePasswordState>(
      buildWhen: (current, previous) => current.confirmPassword != previous.confirmPassword,
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
              hintText: 'Confirm new password',
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
              context.read<UpdatePasswordBloc>().add(ConformPasswordEvent(confirmPassword: value));
            },
            validator: (value) => Validators.validateEmptyField(context,value, 'Password'),
          ),
        );
      },
    );
  }
}
