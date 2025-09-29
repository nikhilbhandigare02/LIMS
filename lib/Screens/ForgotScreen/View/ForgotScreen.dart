import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/Routes/RouteName.dart';
import '../../../config/Themes/colors/colorsTheme.dart';
import '../../../core/utils/Message.dart';
import '../../../core/utils/enums.dart';
import '../../../core/utils/footer.dart';
import '../../../core/widgets/RegistrationInput/CustomTextField.dart';
import '../../../core/widgets/RegistrationInput/PasswordBoxInput.dart';
import '../../../core/utils/validators.dart';
import '../bloc/ForgotPasswordBloc.dart';
import '../repository/ForgotPasswordRepository.dart';

class ForgotScreen extends StatelessWidget {
  ForgotScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordBloc(
        forgotPasswordRepository: ForgotPasswordRepository(),
      ),
      child: Scaffold(
        backgroundColor: customColors.grey100,
        body: SafeArea(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                 SizedBox(height: 20),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        children:  [
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
                 SizedBox(height: 15),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                       CircleAvatar(
                        radius: 70,
                        backgroundColor: customColors.lightGreyCircle,
                      ),
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: customColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child:  Icon(
                          Icons.lock_reset,
                          color: customColors.primary,
                          size: 50,
                        ),
                      ),
                    ],
                  ),
                ),
                 SizedBox(height: 35),
                Expanded(
                  child: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
                    listenWhen: (previous, current) {
                      return previous.apiStatus != current.apiStatus;
                    },
                    listener: (context, state) {
                      // OTP send success
                      if (state.apiStatus == ApiStatus.success && state.isOtpSent && !state.isOtpVerified) {
                        Message.showTopRightOverlay(
                          context,
                          state.message,
                          MessageType.success,
                        );
                      }

                      // OTP verify success
                      else if (state.apiStatus == ApiStatus.success && state.isOtpVerified) {
                        Message.showTopRightOverlay(
                          context,
                          'OTP Verified Succesfully',
                          MessageType.success,
                        );

                        Future.delayed( Duration(seconds: 2), () {
                          Navigator.pushNamed(context, RouteName.resetPasswordScreen);
                        });
                      }

                      else if (state.apiStatus == ApiStatus.error) {
                        Message.showTopRightOverlay(
                          context,
                          state.message,
                          MessageType.error,
                        );
                      }
                    },
                    child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                      buildWhen: (current, previous) =>
                          current.email != previous.email ||
                          current.apiStatus != previous.apiStatus ||
                          current.isOtpSent != previous.isOtpSent ||
                          current.otp != previous.otp,
                      builder: (context, state) {
                        final bloc = context.read<ForgotPasswordBloc>();

                        return ListView(
                          children: [
                            Container(
                              padding:  EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: customColors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: customColors.shadowGrey08,
                                    blurRadius: 16,
                                    offset:  Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Form(
                                child: Column(
                                  children: [
                                    CustomTextField(
                                      label: 'Enter Email',
                                      icon: Icons.email,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: Validators.validateEmail,
                                      value: state
                                          .email,
                                      enabled: !(state.isOtpSent), // 🔒 disable once OTP is sent
                                      onChanged: (value) {
                                        if (!state.isOtpSent) { // 🔐 block changes if OTP sent
                                          context.read<ForgotPasswordBloc>().add(EmailEvent(email: value));
                                        }
                                      },
                                    ),
                                     SizedBox(height: 16),

                                    // Send OTP Button
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: customColors.primary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          padding:  EdgeInsets.symmetric(
                                            vertical: 18,
                                          ),
                                          elevation: 0,
                                        ),
                                        onPressed:
                                            (state.apiStatus ==
                                                    ApiStatus.loading ||
                                                state.email.isEmpty ||
                                                Validators.validateEmail(
                                                      state.email,
                                                    ) !=
                                                    null)
                                            ? null
                                            : () {
                                                bloc.add(sendOTPEvent());
                                              },
                                        child:
                                            state.apiStatus ==
                                                    ApiStatus.loading &&
                                                !state.isOtpSent
                                            ?  SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      color: customColors.white,
                                                      strokeWidth: 2,
                                                    ),
                                              )
                                            :  Text(
                                                'SEND OTP',
                                                style: TextStyle(
                                                  color: customColors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                      ),
                                    ),

                                    if (
                                        state.isOtpSent) ...[
                                       SizedBox(height: 20),
                                      AnimatedOtpInput(
                                        length: 6,
                                        obscureText: false,
                                        value: state.otp,
                                        validator: (value) => Validators.validateOTP(value, length: 6),
                                        onChanged: (value) {
                                          bloc.add(OTPEvent(value));
                                        },
                                      ),
                                       SizedBox(height: 16),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                customColors.primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            padding:  EdgeInsets.symmetric(
                                              vertical: 18,
                                            ),
                                            elevation: 0,
                                          ),
                                          onPressed: (state.apiStatus == ApiStatus.loading ||
                                                  Validators.validateOTP(state.otp, length: 6) != null)
                                              ? null
                                              : () {
                                                  context
                                                      .read<ForgotPasswordBloc>()
                                                      .add(verifyOTPEvent());
                                                },
                                          child:
                                              state.apiStatus ==
                                                      ApiStatus.loading &&
                                                  !state.isOtpSent
                                              ?  SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                        color: customColors.white,
                                                        strokeWidth: 2,
                                                      ),
                                                )
                                              :  Text(
                                                  'VERIFY OTP',
                                                  style: TextStyle(
                                                    color: customColors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ],
                                     SizedBox(height: 25),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Remember your password? ",
                                          style: TextStyle(
                                            color: customColors.black87,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Login',
                                            style: TextStyle(
                                              color: customColors.primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                     SizedBox(height: 10),
                                     Footer(),
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
                 SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

