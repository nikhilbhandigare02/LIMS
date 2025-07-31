import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_inspector/Screens/login/repository/loginRepository.dart';
import 'package:food_inspector/config/Routes/RouteName.dart';

import '../../../core/widgets/RegistrationInput/Curved.dart';
import '../../../core/widgets/loginWidgets/PasswordInputWidget.dart';
import '../../../core/widgets/loginWidgets/submitButton.dart';
import '../../../Screens/login/bloc/loginBloc.dart';
import '../../../config/Themes/colors/colorsTheme.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  late LoginBloc loginBloc;
  final FocusNode currentPasswordFocusNode = FocusNode();
  final FocusNode newPasswordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loginBloc = LoginBloc(loginRepository: LoginRepository());
  }

  @override
  void dispose() {
    currentPasswordFocusNode.dispose();
    newPasswordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    if (value.length < 6) {
      return '$fieldName must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != _newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _updatePassword() {
    if (_formKey.currentState!.validate()) {
      // Handle password update logic here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Password updated successfully!"),
          backgroundColor: customColors.primary,
          duration: const Duration(seconds: 2),
        ),
      );

      // Navigate back or to login screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocProvider(
        create: (_) => loginBloc,
        child: Column(
          children: [
            // Header with curved design
            Stack(
              children: [
                ClipPath(
                  clipper: CurvedClipper(),
                  child: Container(
                    height: 220,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
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
                  padding: const EdgeInsets.only(top: 40, left: 24, right: 24),
                  child: Row(
                    children: [
                      // Back button
                      Container(
                        margin: const EdgeInsets.only(right: 16),
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      // Title
                      const Expanded(
                        child: Text(
                          'UPDATE PASSWORD',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            shadows: [Shadow(color: Colors.black26, blurRadius: 2)],
                          ),
                        ),
                      ),
                      // Empty space for balance
                      const SizedBox(width: 56),
                    ],
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
                      // Avatar + Greeting Section
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: customColors.primary,
                            child: Icon(
                              Icons.lock_reset,
                              color: customColors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Secure Your Account",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: customColors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Update your password",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: customColors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // Security Tips Card
                      Container(
                        margin: const EdgeInsets.only(bottom: 30),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue[200]!, width: 1),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: customColors.primary,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Password Security Tips",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: customColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Use 8+ characters with mix of letters, numbers & symbols",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: customColors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Current Password Field
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: TextFormField(
                          controller: _currentPasswordController,
                          focusNode: currentPasswordFocusNode,
                          obscureText: true,
                          validator: (value) => _validatePassword(value, 'Current password'),
                          decoration: InputDecoration(
                            labelText: 'Current Password',
                            hintText: 'Enter your current password',
                            prefixIcon: Icon(Icons.lock_outline, color: customColors.primary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: customColors.primary, width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),

                      // New Password Field
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: TextFormField(
                          controller: _newPasswordController,
                          focusNode: newPasswordFocusNode,
                          obscureText: true,
                          validator: (value) => _validatePassword(value, 'New password'),
                          decoration: InputDecoration(
                            labelText: 'New Password',
                            hintText: 'Enter your new password',
                            prefixIcon: Icon(Icons.lock, color: customColors.primary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: customColors.primary, width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),

                      // Confirm Password Field
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: TextFormField(
                          controller: _confirmPasswordController,
                          focusNode: confirmPasswordFocusNode,
                          obscureText: true,
                          validator: _validateConfirmPassword,
                          decoration: InputDecoration(
                            labelText: 'Confirm New Password',
                            hintText: 'Re-enter your new password',
                            prefixIcon: Icon(Icons.lock_clock, color: customColors.primary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: customColors.primary, width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),

                      // Update Password Button
                      Container(
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [customColors.primary, Color(0xFF42A5F5)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: customColors.primary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _updatePassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'UPDATE PASSWORD',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),


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