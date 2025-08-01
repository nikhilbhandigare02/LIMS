import '../../../core/utils/enums.dart';

abstract class ForgotPasswordState {
  final bool isOtpSent;
  final bool isOtpVerified;
  final String? errorMessage;
  
  const ForgotPasswordState({
    this.isOtpSent = false,
    this.isOtpVerified = false,
    this.errorMessage,
  });
}

class ForgotPasswordInitial extends ForgotPasswordState {
  const ForgotPasswordInitial() : super();
}

class ForgotPasswordLoading extends ForgotPasswordState {
  const ForgotPasswordLoading() : super();
}

class OtpSentSuccess extends ForgotPasswordState {
  const OtpSentSuccess() : super(isOtpSent: true);
}

class OtpVerifiedSuccess extends ForgotPasswordState {
  const OtpVerifiedSuccess() : super(isOtpSent: true, isOtpVerified: true);
}

class ForgotPasswordError extends ForgotPasswordState {
  const ForgotPasswordError(String errorMessage) : super(errorMessage: errorMessage);
} 