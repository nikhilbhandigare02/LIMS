import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_inspector/Screens/update_password/BLOC/UpdatePassBloc.dart' hide UpdatePassButton;
import 'package:food_inspector/Screens/update_password/repository/UpdatePassRepository.dart';
import 'package:food_inspector/core/widgets/UpdatePassWidget/ConfirmPasswordInput.dart';

import '../../../config/Routes/RouteName.dart';
import '../../../core/utils/Message.dart';
import '../../../core/utils/enums.dart';
import '../../../core/widgets/RegistrationInput/Curved.dart';

import '../../../core/widgets/UpdatePassWidget/CurrentPasswordInputField.dart';
import '../../../core/widgets/UpdatePassWidget/NewPasswordInput.dart';
import '../../../core/widgets/UpdatePassWidget/UpdatePassWidget.dart';

import '../../../config/Themes/colors/colorsTheme.dart';
import '../../../core/widgets/RegistrationInput/CustomTextField.dart';
import '../../../core/utils/validators.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen>
    with TickerProviderStateMixin {

  late UpdatePasswordBloc updatePasswordBloc;
  final _formKey = GlobalKey<FormState>();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;

  @override
  void initState() {
    super.initState();
    updatePasswordBloc = UpdatePasswordBloc(updatePassRepository: UpdatePassRepository());

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    updatePasswordBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: updatePasswordBloc,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: const [
                        Icon(Icons.arrow_back_ios, color: customColors.primary),
                        SizedBox(width: 10),
                        Text(
                          "Update Password",
                          style: TextStyle(
                            color: customColors.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 70,
                      backgroundColor: Color(0xFFF2F2F2),
                    ),
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: customColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_outline,
                        color: customColors.primary,
                        size: 50,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: BlocListener<UpdatePasswordBloc, UpdatePasswordState>(
                  listener: (context, state) {
                    switch (state.apiStatus) {
                      case ApiStatus.loading:
                        Message.showTopRightOverlay(
                          context,
                          'Loading...',
                          MessageType.info,
                        );
                        break;
                      case ApiStatus.success:
                        Message.showTopRightOverlay(
                          context,
                          state.message,
                          MessageType.success,
                        );
                        Navigator.pop(context);
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
                  child: BlocBuilder<UpdatePasswordBloc, UpdatePasswordState>(
                    buildWhen: (previous, current) =>
                    previous.Username != current.Username ||
                        previous.NewPassword != current.NewPassword ||
                        previous.confirmPassword != current.confirmPassword ||
                        previous.apiStatus != current.apiStatus,
                    builder: (context, state) {
                      return Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              label: 'Username',
                              icon: Icons.person_outline,
                              obscureText: false,
                              isPassword: false,
                              value: state.Username,
                              validator: Validators.validateUsername,
                              onChanged: (value) {
                                context.read<UpdatePasswordBloc>().add(updateUsernameEvent(username: value));
                              },
                            ),

                            const SizedBox(height: 16),
                            CustomTextField(
                              label: 'Old Password',
                              icon: Icons.lock_outline,
                              obscureText: _obscureOldPassword,
                              isPassword: true,
                              value: state.confirmPassword,
                              validator: Validators.validateOldPassword,
                              onChanged: (value) {
                                context.read<UpdatePasswordBloc>().add(ConformPasswordEvent(confirmPassword: value));
                              },
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureOldPassword ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureOldPassword = !_obscureOldPassword;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: 'New Password',
                              icon: Icons.lock,
                              obscureText: _obscureNewPassword,
                              isPassword: true,
                              value: state.NewPassword,
                              validator: Validators.validatePassword,
                              onChanged: (value) {
                                context.read<UpdatePasswordBloc>().add(NewPasswordEvent(NewPassword: value));
                              },
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureNewPassword = !_obscureNewPassword;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 25),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: customColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  elevation: 0,
                                ),
                                onPressed: state.apiStatus == ApiStatus.loading
                                    ? null
                                    : () async {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<UpdatePasswordBloc>().add(UpdatePassButtonEvent());
                                  }
                                  Navigator.pop(context);

                                  final secureStorage = const FlutterSecureStorage();
                                  final loginDataStr = await secureStorage.read(key: 'loginData');
                                  int passResetFlag = 0;

                                  if (loginDataStr != null) {
                                    final loginDataMap = jsonDecode(loginDataStr) as Map<String, dynamic>;
                                    final passResetStr = loginDataMap['PassResetFlag'] ?? '0';
                                    passResetFlag = int.tryParse(passResetStr.toString()) ?? 0;
                                  }
                                  Navigator.pop(context);
                                },

                                child: state.apiStatus == ApiStatus.loading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text(
                                  'UPDATE PASSWORD',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '© 2024 Food Safety Organization',
                              style: TextStyle(
                                color: Colors.grey.withOpacity(0.6),
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
