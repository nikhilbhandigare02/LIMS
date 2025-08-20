part of 'ForgotPasswordBloc.dart';

class ForgotPasswordState extends Equatable {
  final String email;
  final String otp;
  final String message;
  final String newPassword;
  final String confirmPassword;
  final ApiStatus apiStatus;
  final bool isOtpSent;
  final bool isOtpVerified;


  const ForgotPasswordState({
    this.email = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.otp = '',
    this.message = '',
    this.apiStatus = ApiStatus.initial,
    this.isOtpSent = false,
    this.isOtpVerified = false,
  });

  ForgotPasswordState copyWith({
    bool? isOtpVerified, // new
    String? email,
    String? newPassword,
    String? confirmPassword,
    String? otp,
    String? message,
    ApiStatus? apiStatus,
    bool? isOtpSent,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      otp: otp ?? this.otp,
      message: message ?? this.message,
      apiStatus: apiStatus ?? this.apiStatus,
      isOtpSent: isOtpSent ?? this.isOtpSent,
      isOtpVerified: isOtpVerified ?? this.isOtpVerified,

    );
  }

  @override
  List<Object?> get props => [email, message, apiStatus, isOtpSent,otp, isOtpVerified, newPassword, confirmPassword];
}

