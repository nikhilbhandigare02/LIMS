

part of 'OTPBloc.dart';
abstract class OTPVerificationEvent extends Equatable{
  @override
  List<Object?> get props => [];
}
class LoginOTPEvent extends OTPVerificationEvent {
  final String otp;

  LoginOTPEvent(this.otp);

  @override
  List<Object?> get props => [otp];
}

class verifyLoginOTPEvent extends OTPVerificationEvent {}
