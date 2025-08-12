import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/Routes/RouteName.dart';
import '../../../config/Themes/colors/colorsTheme.dart';
import '../../../core/utils/enums.dart';
import '../../../core/widgets/RegistrationInput/CustomTextField.dart';
import '../../../core/widgets/RegistrationInput/PasswordBoxInput.dart';
import '../../../core/utils/validators.dart';
import '../bloc/ForgotPasswordBloc.dart';
import '../repository/ForgotPasswordRepository.dart';

class ForgotScreen extends StatelessWidget {
  ForgotScreen({super.key});

  final _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordBloc(forgotPasswordRepository: ForgotPasswordRepository()),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 20),
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
                Expanded(
                  child: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
                    // Only listen when apiStatus changes to success with OTP sent, or changes to error
                    listenWhen: (previous, current) {
                      return previous.apiStatus != current.apiStatus &&
                          ( (current.apiStatus == ApiStatus.success && current.isOtpSent) || current.apiStatus == ApiStatus.error );
                    },
                    listener: (context, state) {
                      if (state.apiStatus == ApiStatus.success && state.isOtpSent) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message.isNotEmpty ? state.message : 'OTP sent successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else if (state.apiStatus == ApiStatus.error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message.isNotEmpty ? state.message : 'An error occurred'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                      buildWhen: (current, previous) =>
                      current.email != previous.email ||
                          current.apiStatus != previous.apiStatus ||
                          current.isOtpSent != previous.isOtpSent,
                      builder: (context, state) {
                        final bloc = context.read<ForgotPasswordBloc>();

                        return ListView(
                          children: [
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
                                child: Column(
                                  children: [
                                    // Email Input
                                    CustomTextField(
                                      label: 'Enter Email',
                                      icon: Icons.email,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: Validators.validateEmail,
                                      value: state.email, // current email from bloc state
                                      onChanged: (value) {
                                        bloc.add(EmailEvent(value));
                                      },
                                    ),
                                    const SizedBox(height: 16),

                                    // Send OTP Button
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
                                        onPressed: (state.apiStatus == ApiStatus.loading ||
                                            state.email.isEmpty ||
                                            Validators.validateEmail(state.email) != null)
                                            ? null
                                            : () {
                                          bloc.add(sendOTPEvent());
                                        },
                                        child: state.apiStatus == ApiStatus.loading && !state.isOtpSent
                                            ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                            : const Text(
                                          'Send OTP',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),

                                    if (state.apiStatus == ApiStatus.success && state.isOtpSent) ...[
                                      const SizedBox(height: 20),
                                      AnimatedOtpInput(
                                        length: 6,
                                        obscureText: false,
                                        value: state.email,
                                        onChanged: (value) {
                                          bloc.add(EmailEvent(value));
                                        },
                                      ),
                                      const SizedBox(height: 16),
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
                                            // TODO: Add verify OTP event here
                                          },
                                          child: const Text(
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
                                    const SizedBox(height: 25),
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
                          ],
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
      ),
    );
  }
}
