abstract class ForgotPasswordEvent {}

class SendOtpEvent extends ForgotPasswordEvent {
  final String mobileNumber;
  
  SendOtpEvent(this.mobileNumber);
}

class VerifyOtpEvent extends ForgotPasswordEvent {
  final String mobileNumber;
  final String otp;
  
  VerifyOtpEvent(this.mobileNumber, this.otp);
}

class ResetForgotPasswordState extends ForgotPasswordEvent {} 