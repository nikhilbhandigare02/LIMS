import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_inspector/Screens/update_password/BLOC/UpdatePassBloc.dart' hide UpdatePassButton;
import 'package:food_inspector/core/widgets/UpdatePassWidget/ConfirmPasswordInput.dart';

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
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final FocusNode currentpassFocusNode = FocusNode();
  final FocusNode newpassFocusNode = FocusNode();
  final FocusNode oldpassFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    updatePasswordBloc = UpdatePasswordBloc();

    // Initialize animations
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
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            const SizedBox(height: 20),
            // Header with back button
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.arrow_back_ios,
                        color: customColors.primary,
                      ),
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
            // Decorative avatar section
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
            // Card-like form area
            BlocProvider(
              create: (_) => updatePasswordBloc,
              child: Container(
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Current Password
                      CustomTextField(
                        label: 'Current Password',
                        icon: Icons.lock_outline,
                        obscureText: true,
                        isPassword: true,
                        validator: Validators.validatePassword,
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 16),
                      // New Password
                      CustomTextField(
                        label: 'New Password',
                        icon: Icons.lock,
                        obscureText: true,
                        isPassword: true,
                        validator: Validators.validatePassword,
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 16),
                      // Confirm Password
                      CustomTextField(
                        label: 'Confirm Password',
                        icon: Icons.lock_outline,
                        obscureText: true,
                        isPassword: true,
                        validator: Validators.validatePassword,
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 25),
                      // Update Password Button
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
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Call Bloc event or update logic here
                            }
                          },
                          child: const Text(
                            'Update Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
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
                ),
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: Colors.blue[600],
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}