import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_inspector/features/login/bloc/loginBloc.dart';
import '../../utils/validators.dart';

class Passwordinput extends StatefulWidget {
  final FocusNode PasswordFocusNode;
  final formkey;

  const Passwordinput({
    super.key,
    required this.formkey,
    required this.PasswordFocusNode,
  });

  @override
  State<Passwordinput> createState() => _PasswordinputState();
}

class _PasswordinputState extends State<Passwordinput> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(buildWhen: (current, previous) => current.username != previous.username,
        builder: (context, state){
      return TextFormField(
        focusNode: widget.PasswordFocusNode,
        obscureText: _obscureText,
        style: TextStyle(fontSize: 16, color: Colors.black87),
        decoration: InputDecoration(
          hintText: 'Enter your password',
          hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
          prefixIcon: Icon(Icons.lock_outline, color: Colors.blueAccent),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey[600],
            ),
            onPressed: _toggleVisibility,
          ),
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
          context.read<LoginBloc>().add(PasswordEvent(password: value));
        },
        onFieldSubmitted: (value) {},
        validator: (value) => Validators.validateEmptyField(value, 'Password'),
      );
    });
  }
}
