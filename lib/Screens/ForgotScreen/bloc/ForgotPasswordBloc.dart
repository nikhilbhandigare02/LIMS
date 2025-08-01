import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/ForgotPasswordRepository.dart';
import 'ForgotPasswordEvent.dart';
import 'ForgotPasswordState.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordRepository repository;
  
  ForgotPasswordBloc({required this.repository}) : super(const ForgotPasswordInitial()) {
    
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ResetForgotPasswordState>(_onResetState);
  }
  
  Future<void> _onSendOtp(SendOtpEvent event, Emitter<ForgotPasswordState> emit) async {
    emit(const ForgotPasswordLoading());
    
    try {
      final success = await repository.sendOtp(event.mobileNumber);
      
      if (success) {
        emit(const OtpSentSuccess());
      } else {
        emit(const ForgotPasswordError('Failed to send OTP'));
      }
    } catch (e) {
      emit(ForgotPasswordError('Error sending OTP: ${e.toString()}'));
    }
  }
  
  Future<void> _onVerifyOtp(VerifyOtpEvent event, Emitter<ForgotPasswordState> emit) async {
    emit(const ForgotPasswordLoading());
    
    try {
      final success = await repository.verifyOtp(event.mobileNumber, event.otp);
      
      if (success) {
        emit(const OtpVerifiedSuccess());
      } else {
        emit(const ForgotPasswordError('Invalid OTP'));
      }
    } catch (e) {
      emit(ForgotPasswordError('Error verifying OTP: ${e.toString()}'));
    }
  }
  
  void _onResetState(ResetForgotPasswordState event, Emitter<ForgotPasswordState> emit) {
    emit(const ForgotPasswordInitial());
  }
} 