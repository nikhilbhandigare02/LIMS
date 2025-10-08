import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Screens/login/bloc/loginBloc.dart';
import '../../../config/Themes/colors/colorsTheme.dart';
import '../../utils/validators.dart';

class EmailInput extends StatelessWidget {
  final FocusNode emailFocusNode;
  final formkey;

  const EmailInput({
    super.key,
    required this.formkey,
    required this.emailFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (current, previous) => current.username != previous.username,
      builder: (context, state) {
        return TextFormField(
          keyboardType: TextInputType.emailAddress,
          focusNode: emailFocusNode,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: 'Enter Username',
            hintStyle: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            prefixIcon: const Icon(
              Icons.person_2,
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
          onChanged: (value) {
            context.read<LoginBloc>().add(UsernameEvent(username: value));
          },
          onFieldSubmitted: (value) {}

        );
      },
    );
  }
}