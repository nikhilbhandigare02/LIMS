import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/Routes/RouteName.dart';
import '../../../config/Themes/colors/colorsTheme.dart';
import '../../../core/widgets/RegistrationInput/CustomTextField.dart';
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
    
    _mobileController.addListener(() {
      final text = _mobileController.text;
      // Keep only digits and max 10 characters
      final filtered = text.replaceAll(RegExp(r'[^0-9]'), '');
      if (filtered.length > 10) {
        _mobileController.text = filtered.substring(0, 10);
        _mobileController.selection = TextSelection.fromPosition(
          TextPosition(offset: _mobileController.text.length),
        );
      } else if (text != filtered) {
        _mobileController.text = filtered;
        _mobileController.selection = TextSelection.fromPosition(
          TextPosition(offset: _mobileController.text.length),
        );
      }
    });
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
                      'FORGOT PASSWORD',
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
                        
                        // Mobile Number Input
                        CustomTextField(
                          label: 'Mobile Number',
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
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
                                  borderRadius: BorderRadius.circular(5),
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
                              return Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: customColors.primary,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: TextButton(
                                  onPressed: _sendOtp,
                                  child: const Text(
                                    'Send OTP',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
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
                                  CustomTextField(
                                    label: 'Enter OTP',
                                    icon: Icons.security,
                                    keyboardType: TextInputType.number,
                                    validator: Validators.validateOtp,
                                    onChanged: (value) {
                                      _otpController.text = value;
                                    },
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
                                  // Verify OTP Button
                                  if (!state.isOtpVerified)
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: customColors.primary,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: state is ForgotPasswordLoading
                                          ? const TextButton(
                                              onPressed: null,
                                              child: SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2,
                                                ),
                                              ),
                                            )
                                          : TextButton(
                                              onPressed: _verifyOtp,
                                              child: const Text(
                                                'Verify OTP',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
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
                                Navigator.pop(context);
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
        ),
      ),
    );
  }
}
