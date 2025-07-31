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
            keyboardType: TextInputType.emailAddress,
            focusNode: emailFocusNode,
            style: const TextStyle(fontSize: 16, color: customColors.black87),

            decoration: InputDecoration(
              hintText: 'Enter your email',
              hintStyle: TextStyle( fontSize: 16),
              prefixIcon: const Icon(Icons.email, color: customColors.primary),
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
            onChanged: (value) {
              context.read<LoginBloc>().add(UsernameEvent(username: value));
            },
            onFieldSubmitted: (value) {},
            validator: Validators.validateUsername,
          ),
        );
      },
    );
  }
}
