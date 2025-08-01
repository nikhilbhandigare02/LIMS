import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_inspector/Screens/update_password/BLOC/UpdatePassBloc.dart';
import 'package:food_inspector/config/Routes/RouteName.dart';
import 'package:food_inspector/config/Themes/colors/colorsTheme.dart';
import 'package:food_inspector/core/utils/enums.dart';
import 'package:food_inspector/core/utils/Message.dart'; // Make sure this has MessageType enum and showTopRightOverlay

import '../../../Screens/login/bloc/loginBloc.dart';

class UpdatePassButton extends StatelessWidget {
  final GlobalKey<FormState> formkey;

  const UpdatePassButton({super.key, required this.formkey});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdatePasswordBloc, UpdatePasswordState>(
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
              'Update password Successful',
              MessageType.success,
            );
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.pushReplacementNamed(context, RouteName.homeScreen);
            });
            break;

          case ApiStatus.error:
            Message.showTopRightOverlay(
              context,
              'update Failed',
              MessageType.error,
            );
            break;

          default:
            break;
        }
      },
      child: BlocBuilder<UpdatePasswordBloc, UpdatePasswordState>(
        buildWhen: (current, previous) => false, // Button UI doesn't change except loader
        builder: (context, state) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: customColors.primary,
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextButton(
              onPressed: () {
                if (formkey.currentState!.validate()) {
                  context.read<UpdatePasswordBloc>().add(UpdatePassButtonEvent());
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
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
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
