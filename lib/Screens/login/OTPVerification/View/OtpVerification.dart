import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_inspector/Screens/login/OTPVerification/Repository/OTPVerificationRepository.dart';
import 'package:food_inspector/Screens/login/OTPVerification/bloc/OTPBloc.dart';
import 'package:food_inspector/config/Routes/RouteName.dart';
import 'package:food_inspector/core/utils/Message.dart';
import 'package:food_inspector/core/utils/validators.dart';
import 'package:food_inspector/core/widgets/AppHeader/AppHeader.dart';
import '../../../../config/Themes/colors/colorsTheme.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/widgets/RegistrationInput/CustomTextField.dart';

class OtpVerificationScreen extends StatefulWidget {
   OtpVerificationScreen({Key? key}) : super(key: key);

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  String _otpValue = '';
  String? _otpError;
  final int _otpLength = 6;

  void _onOtpChanged(String value) {
    setState(() {
      _otpValue = value;
      _otpError = null; // clear error while typing
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          OTPVerificationBloc(otpverificationrepository: Otpverificationrepository()),
      child: BlocListener<OTPVerificationBloc, VerifyOTPState>(
        listener: (context, state) {
          if (state.apiStatus == ApiStatus.success && state.isOtpVerified) {
           Message.showTopRightOverlay(context, 'Otp Verified Succesfully', MessageType.success);
            Navigator.pushReplacementNamed(context, RouteName.SampleAnalysisScreen);
          }

          if (state.apiStatus == ApiStatus.error) {
            Message.showTopRightOverlay(context, 'Wrong OTP, Please enter valid otp', MessageType.success);
          }
        },
        child:BlocBuilder<OTPVerificationBloc, VerifyOTPState>(
          builder: (context, state) {
            // Update _otpError from Bloc state
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (state.apiStatus == ApiStatus.error && state.message.isNotEmpty) {
                setState(() {
                  _otpError = state.message;
                });
              } else {
                setState(() {
                  _otpError = null;
                });
              }
            });

            return Scaffold(
                    backgroundColor: Colors.grey[100],
              body: Padding(
                padding:  EdgeInsets.all(16.0),
                child: Column(
                  children: [
                     SizedBox(height: 18),
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
                     SizedBox(height: 30),
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                           CircleAvatar(
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
                            child:  Icon(
                              Icons.lock_reset,
                              color: customColors.primary,
                              size: 50,
                            ),
                          ),
                        ],
                      ),
                    ),
                     SizedBox(height: 50),

                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            blurRadius: 16,
                            offset:  Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding:  EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                             Text(
                              "Enter the 6-digit OTP sent to your register email id",
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),

                            AnimatedOtpInput(
                              length: _otpLength,
                              value: _otpValue,
                              onChanged: _onOtpChanged,
                              validator: Validators.validateOTP,
                            ),

                            if (_otpError != null)
                              Padding(
                                padding:  EdgeInsets.only(top: 16.0),
                                child: Text(
                                  _otpError!,
                                  style:  TextStyle(color: Colors.red, fontSize: 14),
                                ),
                              ),

                             SizedBox(height: 50),

                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: customColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding:  EdgeInsets.symmetric(vertical: 14),
                                  elevation: 0,
                                ),
                                onPressed: (state.apiStatus == ApiStatus.loading)
                                    ? null
                                    : () {
                                  context.read<OTPVerificationBloc>().add(LoginOTPEvent(_otpValue));
                                  context.read<OTPVerificationBloc>().add(verifyLoginOTPEvent());
                                },
                                child: state.apiStatus == ApiStatus.loading
                                    ?  SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                    :  Text(
                                  'VERIFY OTP',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            );
          },
        ),

      ),
    );
  }
}
