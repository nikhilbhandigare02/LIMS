import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/Routes/RouteName.dart';
import '../../../config/Themes/colors/colorsTheme.dart';
import '../../../core/widgets/RegistrationInput/CustomTextField.dart';
import '../../../core/widgets/RegistrationInput/PasswordBoxInput.dart';
import '../../../core/widgets/RegistrationInput/Curved.dart';
import '../../../core/utils/validators.dart';
import '../bloc/ForgotPasswordBloc.dart';
import '../bloc/ForgotPasswordEvent.dart';
import '../bloc/ForgotPasswordState.dart';
import '../repository/ForgotPasswordRepository.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _otpController = TextEditingController();
  late ForgotPasswordBloc forgotPasswordBloc;

  @override
  void initState() {
    super.initState();
    forgotPasswordBloc = ForgotPasswordBloc(repository: ForgotPasswordRepository());
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _otpController.dispose();
    forgotPasswordBloc.close();
    super.dispose();
  }

  void _sendOtp() {
    if (_formKey.currentState!.validate()) {
      forgotPasswordBloc.add(SendOtpEvent(_mobileController.text));
    }
  }

  void _verifyOtp() {
    if (_formKey.currentState!.validate()) {
      forgotPasswordBloc.add(VerifyOtpEvent(_mobileController.text, _otpController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => forgotPasswordBloc,
      child: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state is OtpSentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("OTP sent to your mobile number"),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is OtpVerifiedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("OTP verified successfully"),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate to reset password screen
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.pushNamed(context, RouteName.resetPasswordScreen);
            });
          } else if (state is ForgotPasswordError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? "An error occurred"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor:   Colors.grey[100],
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
                            "Forgot Password",
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
                          Icons.lock_reset,
                          color: customColors.primary,
                          size: 50,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),
                // Card-like form area
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Mobile Number Input
                        CustomTextField(
                          label: 'Mobile Number',
                          icon: Icons.phone,

                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: Validators.validateMobileNumber,
                          onChanged: (value) {
                            _mobileController.text = value;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Send OTP Button
                        BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                          builder: (context, state) {
                            if (state is ForgotPasswordLoading && !state.isOtpSent) {
                              return Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: customColors.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const TextButton(
                                  onPressed: null,
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              );
                            }
                            if (!state.isOtpSent) {
                              return SizedBox(
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
                                  onPressed: _sendOtp,
                                  child: const Text(
                                    'Send OTP',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        // OTP Input (show after OTP is sent)
                        BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                          builder: (context, state) {
                            if (state.isOtpSent) {
                              return Column(
                                children: [
                                  const SizedBox(height: 20),
                                  PasswordBoxInput(
                                    label: 'Enter OTP',
                                    length: 6,
                                    obscureText: false,
                                    onChanged: (value) {
                                      _otpController.text = value;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  // Verify OTP Button
                                  if (!state.isOtpVerified)
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
                                        onPressed: state is ForgotPasswordLoading ? null : _verifyOtp,
                                        child: state is ForgotPasswordLoading
                                            ? const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : const Text(
                                                'Verify OTP',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                      ),
                                    ),
                                ],
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        const SizedBox(height: 25),
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
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(color: customColors.primary),
                              ),
                            ),
                          ],
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
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
