import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_inspector/Screens/ForgotScreen/repository/ForgotPasswordRepository.dart';
import 'package:food_inspector/Screens/update_password/BLOC/UpdatePassBloc.dart';

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
    on<sendOTPEvent>(sentOTP);
    on<verifyOTPEvent>(VerifyOTP);
  }
  void email(EmailEvent event, Emitter<ForgotPasswordState> emit) {
    print(state.email);
    emit(state.copyWith(email: event.email));
  }

  Future<void> sentOTP(
      sendOTPEvent event,
      Emitter<ForgotPasswordState> emit,
      ) async {
    // Start loading
    emit(state.copyWith(apiStatus: ApiStatus.loading, message: ''));

    try {
      final loginData = {
        'UserMailId': state.email,
      };

      final session = await encryptWithSession(
        data: loginData,
        rsaPublicKeyPem: rsaPublicKeyPem,
      );

      // Call API
      final encryptedResponse = await forgotPasswordRepository.ForgotPassApi(session.payloadForServer);

      if (encryptedResponse != null) {
        print('Encrypted response received: $encryptedResponse');

        try {
          // Extract and decrypt encrypted data from response
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

          // Save login data securely
          await secureStorage.write(key: 'loginData', value: decrypted);

          final Map<String, dynamic> loginResponseMap = jsonDecode(decrypted);
          final String? token = loginResponseMap['Token'];

          if (token != null && token.isNotEmpty) {
            await secureStorage.write(key: 'authToken', value: token);
            print('Auth token stored securely.');
          } else {
            print('Token not found in login response.');
          }
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

        // If everything successful, emit success with isOtpSent = true
        emit(state.copyWith(
          apiStatus: ApiStatus.success,
          message: 'OTP sent successfully',
          isOtpSent: true,
        ));
      } else {
        emit(state.copyWith(
          apiStatus: ApiStatus.error,
          message: 'No response from server',
        ));
      }
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
    // Start loading
    emit(state.copyWith(apiStatus: ApiStatus.loading, message: ''));

    try {
      final loginData = {
        'UserMailId': state.email,
      };

      final session = await encryptWithSession(
        data: loginData,
        rsaPublicKeyPem: rsaPublicKeyPem,
      );

      // Call API
      final encryptedResponse = await forgotPasswordRepository.ForgotPassApi(session.payloadForServer);

      if (encryptedResponse != null) {
        print('Encrypted response received: $encryptedResponse');

        try {
          // Extract and decrypt encrypted data from response
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

          // Save login data securely
          await secureStorage.write(key: 'loginData', value: decrypted);

          final Map<String, dynamic> loginResponseMap = jsonDecode(decrypted);
          final String? token = loginResponseMap['Token'];

          if (token != null && token.isNotEmpty) {
            await secureStorage.write(key: 'authToken', value: token);
            print('Auth token stored securely.');
          } else {
            print('Token not found in login response.');
          }
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

        // If everything successful, emit success with isOtpSent = true
        emit(state.copyWith(
          apiStatus: ApiStatus.success,
          message: 'OTP sent successfully',
          isOtpSent: true,
        ));
      } else {
        emit(state.copyWith(
          apiStatus: ApiStatus.error,
          message: 'No response from server',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        apiStatus: ApiStatus.error,
        message: 'Something went wrong: $e',
      ));
    }
  }


}