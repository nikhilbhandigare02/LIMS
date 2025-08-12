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

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  late LoginBloc loginBloc;
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _captchaController = TextEditingController();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    loginBloc = LoginBloc(loginRepository: LoginRepository());

    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

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
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [
          //     Color(0xFF60A5FA),
          //     Color(0xFF3B82F6),
          //     Color(0xFF60A5FA),
          //   ],
          // ),
        ),
        child: BlocProvider(
          create: (_) => loginBloc,
          child: SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    const SizedBox(height: 20),


                    const SizedBox(height: 30),

                    // Main Login Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const SizedBox(height: 30),

                          // Welcome text
                          const Text(
                            "Login Here",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF130160),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Authorized Personnel Only",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Decorative avatar section with security icon
                          // Replace the existing logo section (around line 138-179) with this updated code:

// Decorative avatar section with security icon
                          Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: 90,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16), // Rounded rectangle
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                        spreadRadius: 2,
                                      ),
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.1),
                                      width: 1,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Image.asset(
                                        'assets/logo.png',
                                        height: 70,
                                        width: 60,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),


                              ],
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Form with updated styling
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Email Input with new styling
                                Container(
                                  child: EmailInput(
                                    formkey: _formKey,
                                    emailFocusNode: emailFocusNode,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                Container(
                                  child: PasswordInput(
                                    formkey: _formKey,
                                    passwordFocusNode: passFocusNode,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF7F8F9),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFF1E3A8A).withOpacity(0.1),
                                    ),
                                  ),
                                  child: CaptchaWidget(controller: _captchaController),
                                ),
                                const SizedBox(height: 6),

                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, RouteName.forgotPasswordScreen);
                                    },
                                    child: const Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                        color: customColors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 6),

                                LoginButton(formkey: _formKey),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, RouteName.registerScreen);
                              },
                              child: const Text.rich(
                                TextSpan(
                                  text: "Don't have an account? ",
                                  style: TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: "Create one",
                                      style: TextStyle(
                                        color: customColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}