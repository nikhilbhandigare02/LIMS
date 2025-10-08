import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_inspector/l10n/app_localizations.dart';

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
    String _localizedMessage(BuildContext ctx, String msg) {
      final l10n = AppLocalizations.of(ctx);
      if (l10n == null || msg.isEmpty) return msg;
      // Map known Bloc messages to localized strings
      if (msg == 'No response from server') return l10n.serverNoResponse;
      if (msg.startsWith('Something went wrong:')) {
        final idx = msg.indexOf(':');
        final err = idx != -1 && idx + 1 < msg.length ? msg.substring(idx + 1).trim() : '';
        return l10n.somethingWentWrong(err);
      }
      if (msg == 'Failed to decrypt server response.') return l10n.error;
      if (msg == 'OTP sent successfully') {
        // Fallback: show generic success if specific key not generated yet
        return l10n.success;
      }
      return msg; // default
    }
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
                            AppLocalizations.of(context)!.forgotPass,
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
                          _localizedMessage(context, state.message),
                          MessageType.success,
                        );
                      }

                      // OTP verify success
                      else if (state.apiStatus == ApiStatus.success && state.isOtpVerified) {
                        Message.showTopRightOverlay(
                          context,
                          AppLocalizations.of(context)!.otpVerifiedSuccessfully,
                          MessageType.success,
                        );

                        Future.delayed( Duration(seconds: 2), () {
                          Navigator.pushNamed(context, RouteName.resetPasswordScreen);
                        });
                      }

                      else if (state.apiStatus == ApiStatus.error) {
                        Message.showTopRightOverlay(
                          context,
                          _localizedMessage(context, state.message),
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
                                      label: "${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.email}",
                                      icon: Icons.email,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: Validators.validateEmail,
                                      value: state
                                          .email,
                                      enabled: !(state.isOtpSent),
                                      onChanged: (value) {
                                        if (!state.isOtpSent) {
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
                                                AppLocalizations.of(context)!.sendOtp,
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
                                                  AppLocalizations.of(context)!.verifyOTP,
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
                                         "${ AppLocalizations.of(context)!.rememberPass}? ",
                                          style: TextStyle(
                                            color: customColors.black87,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)!.login,
                                            style: TextStyle(
                                              color: customColors.primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                     SizedBox(height: 20),
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

