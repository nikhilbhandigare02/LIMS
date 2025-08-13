part of 'ForgotPasswordBloc.dart';

class ForgotPasswordState extends Equatable {
  final String email;
  final String otp;
  final String message;
  final ApiStatus apiStatus;
  final bool isOtpSent;
  final bool isOtpVerified; // new


  const ForgotPasswordState({
    this.email = '',
    this.otp = '',
    this.message = '',
    this.apiStatus = ApiStatus.initial,
    this.isOtpSent = false,
    this.isOtpVerified = false,
  });

  ForgotPasswordState copyWith({
    bool? isOtpVerified, // new
    String? email,
    String? otp,
    String? message,
    ApiStatus? apiStatus,
    bool? isOtpSent,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      otp: otp ?? this.otp,
      message: message ?? this.message,
      apiStatus: apiStatus ?? this.apiStatus,
      isOtpSent: isOtpSent ?? this.isOtpSent,
      isOtpVerified: isOtpVerified ?? this.isOtpVerified,

    );
  }

  @override
  List<Object?> get props => [email, message, apiStatus, isOtpSent,otp, isOtpVerified];
}
