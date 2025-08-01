import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_inspector/Screens/update_password/BLOC/UpdatePassBloc.dart' hide UpdatePassButton;
import 'package:food_inspector/core/widgets/UpdatePassWidget/ConfirmPasswordInput.dart';

import '../../../core/widgets/RegistrationInput/Curved.dart';

import '../../../core/widgets/UpdatePassWidget/CurrentPasswordInputField.dart';
import '../../../core/widgets/UpdatePassWidget/NewPasswordInput.dart';
import '../../../core/widgets/UpdatePassWidget/UpdatePassWidget.dart';

import '../../../config/Themes/colors/colorsTheme.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  late UpdatePasswordBloc updatePasswordBloc;
  final FocusNode currentpassFocusNode = FocusNode();
  final FocusNode newpassFocusNode = FocusNode();
  final FocusNode oldpassFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    updatePasswordBloc = UpdatePasswordBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocProvider(
        create: (_) => updatePasswordBloc,
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

                    'Update Password',
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
                   

                      const SizedBox(height: 40),
                      CurrentPasswordInput(
                          formkey: _formKey, passwordFocusNode: currentpassFocusNode),

                      const SizedBox(height: 10),
                      NewPasswordInput(
                          formkey: _formKey, passwordFocusNode: newpassFocusNode),

                      const SizedBox(height: 10),

                      ConfirmPasswordInput(
                          formkey: _formKey, passwordFocusNode: oldpassFocusNode),



                      const SizedBox(height: 20),
                        UpdatePassButton(formkey: _formKey,),

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
