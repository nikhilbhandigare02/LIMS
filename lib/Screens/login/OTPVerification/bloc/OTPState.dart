
part of 'OTPBloc.dart';

class VerifyOTPState extends Equatable{
  final String otp;
  final ApiStatus apiStatus;
  final String message;
  final bool isOtpVerified;


  const VerifyOTPState({
    this.otp = '',
    this.message = '',
    this.apiStatus = ApiStatus.initial,
    this.isOtpVerified = false,

  });

  VerifyOTPState copyWith({
    String? otp,
    String? message,
    ApiStatus? apiStatus,
    bool? isOtpVerified, // new

  }){
    return VerifyOTPState(
      otp: otp ?? this.otp,
      message: message ?? this.message,
      apiStatus: apiStatus ?? this.apiStatus,
      isOtpVerified: isOtpVerified ?? this.isOtpVerified,

    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [otp, message, apiStatus, isOtpVerified];
}