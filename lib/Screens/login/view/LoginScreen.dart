import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_inspector/Screens/login/repository/loginRepository.dart';
import 'package:food_inspector/config/Routes/RouteName.dart';

import '../../../core/widgets/RegistrationInput/Curved.dart';

import '../../../core/widgets/loginWidgets/CaptchaWidget.dart';
import '../../../core/widgets/loginWidgets/EmailInputWidget.dart';
import '../../../core/widgets/loginWidgets/PasswordInputWidget.dart';
import '../../../core/widgets/loginWidgets/submitButton.dart';
import '../bloc/loginBloc.dart';
import '../../../config/Themes/colors/colorsTheme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginBloc loginBloc;
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _captchaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loginBloc = LoginBloc(loginRepository: LoginRepository());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocProvider(
        create: (_) => loginBloc,
        child: Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: CurvedClipper(),
                  child: Container(
                    height: 220,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                     color: customColors.primary,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 220,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 40, left: 24),
                  child: const Text(

                    'FSO LOGIN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      shadows: [Shadow(color: Colors.black26, blurRadius: 2)],
                    ),
                  ),
                ),
              ],
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Avatar + Greeting

                      Row(
                        children: [

                          const SizedBox(width: 12),

                        ],
                      ),



                      const SizedBox(height: 30),

                      EmailInput(
                        formkey: _formKey,
                        emailFocusNode: emailFocusNode,
                      ),
                      const SizedBox(height: 10),
                      PasswordInput(
                          formkey: _formKey, passwordFocusNode: passFocusNode),

                      const SizedBox(height: 10),

                      // Captcha
                      CaptchaWidget(controller: _captchaController),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, RouteName.forgotPasswordScreen);
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(color: customColors.primary),
                          ),
                        ),
                      ),

                      // Submit button with styling
                      const SizedBox(height: 10),
                      LoginButton(formkey: _formKey),

                      const SizedBox(height: 20),

                      // Footer - Register prompt
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(color: customColors.black87),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RouteName.registerScreen);
                            },
                            child: Text(
                              'Create one',
                              style: TextStyle(color: customColors.primary),
                            ),
                          ),
                        ],
                      ),
                       const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
