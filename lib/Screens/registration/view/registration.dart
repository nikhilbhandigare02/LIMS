import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_inspector/Screens/registration/Repository/resisterRepository.dart';
import 'package:food_inspector/config/Routes/RouteName.dart';
import 'package:food_inspector/core/utils/validators.dart';

import '../../../config/Themes/colors/colorsTheme.dart';
import '../../../core/widgets/RegistrationInput/Curved.dart';
import '../../../core/widgets/RegistrationInput/CustomTextField.dart';
import '../../../core/widgets/RegistrationInput/RegistrationWidget.dart';
import '../../../core/widgets/RoundButton/RoundButton.dart';
import '../bloc/registrationBloc.dart';


class RegistrationScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegistrationBloc(regRepository: registerRepository()),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: Column(
          children: [
            // Curved Header
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
                    'FSO REGISTRATION',
                    textAlign: TextAlign.center,
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

            // Scrollable Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: BlocBuilder<RegistrationBloc, RegistrationState>(
                    builder: (context, state) {
                      final bloc = context.read<RegistrationBloc>();

                      return Column(
                        children: [
                          const SizedBox(height: 10),
                          CustomTextField(
                            label: 'Full Name',
                            icon: Icons.account_circle,
                            initialValue: state.name,
                            validator: Validators.validateName,
                            onChanged: (val) =>
                                bloc.add(NameChanged(val)),
                          ),

                          const SizedBox(height: 10),
                          CustomTextField(
                            label: 'Contact',
                            icon: Icons.phone,
                            initialValue: state.username,
                            validator: Validators.validateUsername,
                            onChanged: (val) =>
                                bloc.add(UsernameChanged(val)),
                          ),

                          const SizedBox(height: 10),
                          CustomTextField(
                            label: 'Email',
                            icon: Icons.email_outlined,
                            initialValue: state.email,
                            keyboardType: TextInputType.emailAddress,
                            validator: Validators.validateEmail,
                            onChanged: (val) =>
                                bloc.add(EmailChanged(val)),
                          ),


                          const SizedBox(height: 10),
                          // COUNTRY
                          BlocBuilder<RegistrationBloc, RegistrationState>(
                            builder: (context, state) {
                              return Column(
                                children: [


                                  const SizedBox(height: 10),

                                  buildDropdownField(
                                    label: 'Select District',
                                    value: state.selectedDistrict,
                                    items: state.districts,
                                    icon: Icons.location_city,
                                    validator: Validators.validateDistrict,

                                    onChanged: (value) {
                                      context.read<RegistrationBloc>().add(DistrictNameChanged(value!));
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            label: 'Location',
                            icon: Icons.work,
                            initialValue: state.name,
                            validator: Validators.validateName,
                            onChanged: (val) =>
                                bloc.add(NameChanged(val)),
                          ),

                          const SizedBox(height: 10),
                          CustomTextField(
                            label: 'designation',
                            icon: Icons.work,
                            initialValue: state.name,
                            validator: Validators.validateName,
                            onChanged: (val) =>
                                bloc.add(NameChanged(val)),
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            label: 'Username',
                            icon: Icons.person,
                            initialValue: state.username,
                            validator: Validators.validateUsername,
                            onChanged: (val) =>
                                bloc.add(UsernameChanged(val)),
                          ),


                          const SizedBox(height: 10),
                          CustomTextField(
                            label: 'Password',
                            icon: Icons.lock,
                            obscureText: true,
                            isPassword: true, // required to show toggle icon
                            validator: Validators.validatePassword,
                            onChanged: (val) => print(val),
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            label: ' Confirm Password',
                            icon: Icons.lock,
                            obscureText: true,
                            isPassword: true, // required to show toggle icon
                            validator: Validators.validatePassword,
                            onChanged: (val) => print(val),
                          ),

                          const SizedBox(height: 10),
                          RoundButton(
                            text: 'Register Account',
                            onPressed: () {
                              final formState = _formKey.currentState;
                              if (formState != null && formState.validate()) {
                                context.read<RegistrationBloc>().add(FormSubmitted());
                              }
                            },
                          ),

                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: TextStyle(color: customColors.black87),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, RouteName.loginScreen);
                                },
                                child: const Text(
                                  "Sign In",
                                  style: TextStyle(fontWeight: FontWeight.w600, color: customColors.primary),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
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
