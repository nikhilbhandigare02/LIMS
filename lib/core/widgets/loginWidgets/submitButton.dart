import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_inspector/core/utils/enums.dart';
import 'package:food_inspector/features/login/bloc/loginBloc.dart';
import '../../../config/Routes/RouteName.dart';
import '../../../config/Themes/colors/colorsTheme.dart';
import '../../utils/Message.dart';


class Loginbutton extends StatelessWidget {
  final GlobalKey<FormState> formkey;

  const Loginbutton({super.key, required this.formkey});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(listener: (context, state){
      if(state.apiStatus == ApiStatus.success){
        Message.showTopRightOverlay(context, 'Login Succesfull');
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushReplacementNamed(context, RouteName.homeScreen);
        });
      }else if(state.apiStatus == ApiStatus.error){
        Message.showTopRightOverlay(context, 'Failed to Login');
      }
    }, child: ElevatedButton(
      onPressed: () {
        if (formkey.currentState!.validate()) {
          BlocProvider.of<LoginBloc>(context).add(LoginButtonEvent());
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: customColors.ButtonColors,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state.apiStatus == ApiStatus.loading) {
            return const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            );
          }
          return const Text('Login', style: TextStyle(color: Colors.white, fontSize: 18));
        },
      ),
    ),);

  }
}
