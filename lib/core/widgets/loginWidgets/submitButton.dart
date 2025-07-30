import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_inspector/config/Routes/RouteName.dart';
import 'package:food_inspector/config/Themes/colors/colorsTheme.dart';
import 'package:food_inspector/core/utils/enums.dart';
import '../../../Screens/login/bloc/loginBloc.dart';
import '../../utils/Message.dart'; // make sure this import is correct

class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formkey;

  const LoginButton({super.key, required this.formkey});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (current, previous) => current.apiStatus != previous.apiStatus,
      listener: (context, state) {
        if (state.apiStatus == ApiStatus.success) {
          Message.showTopRightOverlay(context, 'Login Successful', Colors.green);
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacementNamed(context, RouteName.homeScreen);
          });
        }

        if (state.apiStatus == ApiStatus.loading) {
          Message.showTopRightOverlay(context, 'Logging in...', Colors.blue);
        }

        if (state.apiStatus == ApiStatus.error) {
          Message.showTopRightOverlay(context, 'Login Failed', Colors.redAccent);
        }

      },
      child: BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (current, previous) => false,
        builder: (context, state) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: customColors.primary,
              borderRadius: BorderRadius.circular(3),
            ),
            child: TextButton(
              onPressed: () {
                if (formkey.currentState!.validate()) {
                  context.read<LoginBloc>().add(LoginButtonEvent());
                }
              },
              child: state.apiStatus == ApiStatus.loading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : const Text(
                'Login',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
