part of 'ForgotPasswordBloc.dart';

abstract class ForgotPasswordEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmailEvent extends ForgotPasswordEvent {
  final String email;
  EmailEvent({required this.email});
  @override
  List<Object?> get props => [email];
}
class NewForgotPassEvent extends ForgotPasswordEvent {
  final String newPassword;
  NewForgotPassEvent({required this.newPassword});
  @override
  List<Object?> get props => [newPassword];
}
class ConfirmForgotPassEvent extends ForgotPasswordEvent {
  final String confirmPassword;
  ConfirmForgotPassEvent({required this.confirmPassword});
  @override
  List<Object?> get props => [confirmPassword];
}
class OTPEvent extends ForgotPasswordEvent {
  final String otp;

  OTPEvent(this.otp);

  @override
  List<Object?> get props => [otp];
}

class sendOTPEvent extends ForgotPasswordEvent {}

class verifyOTPEvent extends ForgotPasswordEvent {}

class SubmitResetPasswordEvent extends ForgotPasswordEvent {}