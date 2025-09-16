import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_inspector/Screens/ForgotScreen/repository/ForgotPasswordRepository.dart';

import '../../../common/ENcryption_Decryption/AES.dart';
import '../../../common/ENcryption_Decryption/key.dart';
import '../../../core/utils/enums.dart';
part 'ForgotPasswordEvent.dart';
part 'ForgotPasswordState.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState>{
  final ForgotPasswordRepository forgotPasswordRepository;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  ForgotPasswordBloc({required this.forgotPasswordRepository}) : super(const ForgotPasswordState()) {
    on<EmailEvent>(email);
    on<NewForgotPassEvent>(newPassword);
    on<ConfirmForgotPassEvent>(confirmPassword);
    on<sendOTPEvent>(sentOTP);
    on<OTPEvent>(OTP);
    on<verifyOTPEvent>(VerifyOTP);
    on<SubmitResetPasswordEvent>(_onSubmitResetPassword);
  }
  void email(EmailEvent event, Emitter<ForgotPasswordState> emit) {
    print(state.email);
    emit(state.copyWith(email: event.email));
  }
  void OTP(OTPEvent event, Emitter<ForgotPasswordState> emit) {
    print(state.otp);
    emit(state.copyWith(otp: event.otp));
  }
  void confirmPassword(ConfirmForgotPassEvent event, Emitter<ForgotPasswordState> emit) {
    print(state.confirmPassword);
    emit(state.copyWith(confirmPassword: event.confirmPassword));
  }
  void newPassword(NewForgotPassEvent event, Emitter<ForgotPasswordState> emit) {
    print(state.newPassword);
    emit(state.copyWith(newPassword: event.newPassword));
  }


  Future<void> sentOTP(
      sendOTPEvent event,
      Emitter<ForgotPasswordState> emit,
      ) async {
    emit(state.copyWith(apiStatus: ApiStatus.loading, message: ''));

    try {
      final sendOTPData = {
        'UserMailId': state.email,
      };

      final session = await encryptWithSession(
        data: sendOTPData,
        rsaPublicKeyPem: rsaPublicKeyPem,
      );

      final encryptedResponse = await forgotPasswordRepository.ForgotPassApi(session.payloadForServer);

      if (encryptedResponse == null) {
        emit(state.copyWith(
          apiStatus: ApiStatus.error,
          message: 'No response from server',
        ));
        return;
      }

      print('Encrypted response received: $encryptedResponse');

      String? decryptedString;

      try {
        final String encryptedDataBase64 =
        (encryptedResponse['encryptedData'] ?? encryptedResponse['EncryptedData']) as String;
        final String serverIvBase64 =
        (encryptedResponse['iv'] ?? encryptedResponse['IV']) as String;

        decryptedString = utf8.decode(
          aesCbcDecrypt(
            base64ToBytes(encryptedDataBase64),
            session.aesKeyBytes,
            base64ToBytes(serverIvBase64),
          ),
        );

        print('Decrypted response: $decryptedString');
      } catch (e) {
        print('Primary decryption failed: $e');
        try {
          final String encryptedAESKey =
          (encryptedResponse['encryptedAESKey'] ?? encryptedResponse['EncryptedAESKey']) as String;
          final String encryptedData =
          (encryptedResponse['encryptedData'] ?? encryptedResponse['EncryptedData']) as String;
          final String iv = (encryptedResponse['iv'] ?? encryptedResponse['IV']) as String;

          decryptedString = await decrypt(
            encryptedAESKeyBase64: encryptedAESKey,
            encryptedDataBase64: encryptedData,
            ivBase64: iv,
            rsaPrivateKeyPem: rsaPrivateKeyPem,
          );

          print('Decrypted fallback response: $decryptedString');
        } catch (e2) {
          print('Fallback decryption failed: $e2');
          emit(state.copyWith(
            apiStatus: ApiStatus.error,
            message: 'Failed to decrypt server response.',
          ));
          return;
        }
      }

      final Map<String, dynamic> otpResponse = jsonDecode(decryptedString);

      print('OTP Verification Code: ${otpResponse['verificationCode']}');
      print('OTP Email: ${otpResponse['Email']}');
      print('OTP UserId: ${otpResponse['UserId']}');

      await secureStorage.write(key: 'otpVerificationCode', value: otpResponse['verificationCode'] ?? '');
      await secureStorage.write(key: 'otpEmail', value: otpResponse['Email'] ?? '');
      await secureStorage.write(key: 'otpUserId', value: otpResponse['UserId']?.toString() ?? '');

      emit(state.copyWith(
        apiStatus: ApiStatus.success,
        message: 'OTP sent successfully',
        isOtpSent: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        apiStatus: ApiStatus.error,
        message: 'Something went wrong: $e',
      ));
    }
  }

  Future<void> VerifyOTP(
      verifyOTPEvent event,
      Emitter<ForgotPasswordState> emit,
      ) async {

    if (state.otp.isEmpty || state.otp.length != 6 || !RegExp(r'^\d{6}$').hasMatch(state.otp)) {
      emit(state.copyWith(
        apiStatus: ApiStatus.error,
        message: 'OTP is required and must be 6 digits.',
      ));
      return;
    }
    emit(state.copyWith(apiStatus: ApiStatus.loading, message: '', ));

    try {

      final storedUserId = await secureStorage.read(key: 'otpUserId');

      if (storedUserId == null || storedUserId.isEmpty) {
        emit(state.copyWith(
          apiStatus: ApiStatus.error,
          message: 'User ID not found in secure storage.',
        ));
        return;
      }
      final verifyOTPData = {
        'verificationCode': state.otp,
        'Email': state.email,
        'UserId': storedUserId,
      };

      final session = await encryptWithSession(
        data: verifyOTPData,
        rsaPublicKeyPem: rsaPublicKeyPem,
      );

      final encryptedResponse = await forgotPasswordRepository.VerifyOTPApi(session.payloadForServer);

      if (encryptedResponse != null) {
        print('Encrypted response received: $encryptedResponse');

        try {
          final String encryptedDataBase64 =
          (encryptedResponse['encryptedData'] ?? encryptedResponse['EncryptedData']) as String;
          final String serverIvBase64 =
          (encryptedResponse['iv'] ?? encryptedResponse['IV']) as String;

          final String decrypted = utf8.decode(
            aesCbcDecrypt(
              base64ToBytes(encryptedDataBase64),
              session.aesKeyBytes,
              base64ToBytes(serverIvBase64),
            ),
          );

          print('Decrypted response: $decrypted');

        } catch (e) {
          print('Failed to decrypt response: $e');
          try {
            final String encryptedAESKey =
            (encryptedResponse['encryptedAESKey'] ?? encryptedResponse['EncryptedAESKey']) as String;
            final String encryptedData =
            (encryptedResponse['encryptedData'] ?? encryptedResponse['EncryptedData']) as String;
            final String iv = (encryptedResponse['iv'] ?? encryptedResponse['IV']) as String;

            final String decryptedFallback = await decrypt(
              encryptedAESKeyBase64: encryptedAESKey,
              encryptedDataBase64: encryptedData,
              ivBase64: iv,
              rsaPrivateKeyPem: rsaPrivateKeyPem,
            );

            print('Decrypted fallback response: $decryptedFallback');

            await secureStorage.write(key: 'loginData', value: decryptedFallback);

            final Map<String, dynamic> fallbackMap = jsonDecode(decryptedFallback);
            final String? fallbackToken = fallbackMap['Token'];

            if (fallbackToken != null && fallbackToken.isNotEmpty) {
              await secureStorage.write(key: 'authToken', value: fallbackToken);
              print('Fallback auth token stored securely.');
            } else {
              print('Token not found in fallback response.');
            }
          } catch (e2) {
            print('Fallback decryption failed: $e2');
            emit(state.copyWith(
              apiStatus: ApiStatus.error,
              message: 'Failed to decrypt server response.',
            ));
            return;
          }
        }

        emit(state.copyWith(
          apiStatus: ApiStatus.success,
          message: state.message,
          isOtpVerified: true,
        ));
      } else {
        emit(state.copyWith(
          apiStatus: ApiStatus.error,
          message: state.message,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        apiStatus: ApiStatus.error,
        message: 'Something went wrong: $e',
      ));
    }
  }



  Future<void> _onSubmitResetPassword(SubmitResetPasswordEvent event, Emitter<ForgotPasswordState> emit) async {
    emit(state.copyWith(apiStatus: ApiStatus.loading));
    try {
      final storedUserId = await secureStorage.read(key: 'otpUserId');

      if (storedUserId == null || storedUserId.isEmpty) {
        emit(state.copyWith(
          apiStatus: ApiStatus.error,
          message: 'User ID not found in secure storage.',
        ));
        return;
      }
      final loginData = {
        'UserId': storedUserId,
        'Password': state.newPassword,
      };

      final session = await encryptWithSession(
        data: loginData,
        rsaPublicKeyPem: rsaPublicKeyPem,
      );

      print('Encrypted payload to send: ${session.payloadForServer}');

      final encryptedResponse = await forgotPasswordRepository.resetPassApi(session.payloadForServer);

      print('Encrypted response received: $encryptedResponse');
      try {
        final String encryptedDataBase64 =
        (encryptedResponse['encryptedData'] ?? encryptedResponse['EncryptedData']) as String;
        final String serverIvBase64 = (encryptedResponse['iv'] ?? encryptedResponse['IV']) as String;

        final String decrypted = utf8.decode(
          aesCbcDecrypt(
            base64ToBytes(encryptedDataBase64),
            session.aesKeyBytes,
            base64ToBytes(serverIvBase64),
          ),
        );

        print('Decrypted response: $decrypted');
      } catch (e) {
        print('Failed to decrypt response: $e');
        try {
          final String encryptedAESKey =
          (encryptedResponse['encryptedAESKey'] ?? encryptedResponse['EncryptedAESKey']) as String;
          final String encryptedData =
          (encryptedResponse['encryptedData'] ?? encryptedResponse['EncryptedData']) as String;
          final String iv = (encryptedResponse['iv'] ?? encryptedResponse['IV']) as String;

          final String decryptedFallback = await decrypt(
            encryptedAESKeyBase64: encryptedAESKey,
            encryptedDataBase64: encryptedData,
            ivBase64: iv,
            rsaPrivateKeyPem: rsaPrivateKeyPem,
          );
          print('Decrypted (fallback) response: $decryptedFallback');
        } catch (e2) {
          print('Fallback decryption also failed: $e2');
        }
      }

      emit(state.copyWith(
        message: 'Password Changed successfully',
        apiStatus: ApiStatus.success,
      ));
    } catch (e) {
      print('Error in updatePassButton: $e');
      emit(state.copyWith(
        message: 'Something went wrong: $e',
        apiStatus: ApiStatus.error,
      ));
    }
  }


}