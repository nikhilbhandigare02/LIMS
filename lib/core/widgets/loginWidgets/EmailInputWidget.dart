import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_inspector/features/login/bloc/loginBloc.dart';

import '../../utils/validators.dart';


class Emailinput extends StatelessWidget {
  final FocusNode EmailFocusNode;
  final formkey;

  const Emailinput({
    super.key,
    required this.formkey,
    required this.EmailFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state){
      return TextFormField(
        keyboardType: TextInputType.emailAddress,
        focusNode: EmailFocusNode,
        style: TextStyle(fontSize: 16, color: Colors.black87),
        decoration: InputDecoration(
          hintText: 'Enter your email',
          hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
          prefixIcon: Icon(Icons.email, color: Colors.blueAccent),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blueAccent, width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        onChanged: (value) {
          context.read<LoginBloc>().add(UsernameEvent(username: value));
        },
        onFieldSubmitted: (value) {},
        validator: Validators.validatePass,
      );
    });
  }
}
