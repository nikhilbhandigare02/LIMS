import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_inspector/Screens/FORM6/repository/form6Repository.dart';
import 'package:food_inspector/config/Routes/RouteName.dart';
import 'package:food_inspector/config/Themes/colors/colorsTheme.dart';
import 'package:food_inspector/core/utils/enums.dart';
import 'package:food_inspector/core/utils/Message.dart'; // Make sure this has MessageType enum and showTopRightOverlay

import '../../../Screens/FORM6/bloc/Form6Bloc.dart';
import '../../../Screens/FORM6/view/form6_landing_screen.dart';
import '../../../Screens/login/bloc/loginBloc.dart';

class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formkey;

  const LoginButton({super.key, required this.formkey});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (current, previous) =>
      current.apiStatus != previous.apiStatus,
      listener: (context, state) {
        switch (state.apiStatus) {
          case ApiStatus.loading:
            Message.showTopRightOverlay(
              context,
              'Logging in...',
              MessageType.info,
            );
            break;

          case ApiStatus.success:
            Message.showTopRightOverlay(
              context,
              state.message,
              MessageType.success,
            );
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => SampleFormBloc(form6repository: Form6Repository()),
                    child: Form6LandingScreen(),
                  ),
                ),
              );
            });

            break;

          case ApiStatus.error:
            Message.showTopRightOverlay(
              context,
              state.message,
              MessageType.error,
            );
            break;

          default:
            break;
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (current, previous) => false,
        builder: (context, state) {
          return SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: customColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 18),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              onPressed: state.apiStatus == ApiStatus.loading
                  ? null
                  : () {
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
                'Sign in',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}