import 'package:flutter/material.dart';
import '../../../config/Routes/RouteName.dart';
import '../../../config/Themes/colors/colorsTheme.dart';
import '../../../core/widgets/RegistrationInput/CustomTextField.dart';
import '../../../core/widgets/RegistrationInput/Curved.dart';
import '../../../core/utils/validators.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      // Check if passwords match
      if (_newPasswordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Passwords do not match"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password reset successfully"),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back to login screen
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushNamedAndRemoveUntil(context, RouteName.loginScreen, (route) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
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
                  'RESET PASSWORD',
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
                    const SizedBox(height: 30),
                    
                    // New Password Input
                    CustomTextField(
                      label: 'New Password',
                      icon: Icons.lock,
                      obscureText: true,
                      isPassword: true,
                      validator: Validators.validatePassword,
                      onChanged: (value) {
                        _newPasswordController.text = value;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Confirm Password Input
                    CustomTextField(
                      label: 'Confirm Password',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      isPassword: true,
                      validator: (value) => Validators.validateConfirmPassword(value, _newPasswordController.text),
                      onChanged: (value) {
                        _confirmPasswordController.text = value;
                      },
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Reset Password Button
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: customColors.primary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextButton(
                        onPressed: _resetPassword,
                        child: const Text(
                          'Reset Password',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Back to Login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Remember your password? ",
                          style: TextStyle(color: customColors.black87),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(context, RouteName.loginScreen, (route) => false);
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(color: customColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 