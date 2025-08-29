import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_inspector/Screens/login/OTPVerification/Repository/OTPVerificationRepository.dart';
import '../../../../common/ENcryption_Decryption/AES.dart';
import '../../../../common/ENcryption_Decryption/key.dart';
import '../../../../core/utils/enums.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'OTPEvent.dart';
part 'OTPState.dart';

final secureStorage = FlutterSecureStorage();

class OTPVerificationBloc
    extends Bloc<OTPVerificationEvent, VerifyOTPState> {
  final Otpverificationrepository otpverificationrepository;

  OTPVerificationBloc({required this.otpverificationrepository})
      : super(const VerifyOTPState()) {
    on<LoginOTPEvent>(_onOtpChanged);
    on<verifyLoginOTPEvent>(_onVerifyOtp);
  }

  // Update OTP while typing
  void _onOtpChanged(LoginOTPEvent event, Emitter<VerifyOTPState> emit) {
    print(state.otp);
    emit(state.copyWith(otp: event.otp, apiStatus: ApiStatus.initial, message: ''));
  }

  // Verify OTP
  Future<void> _onVerifyOtp(
      verifyLoginOTPEvent event, Emitter<VerifyOTPState> emit) async {
    if (state.otp.isEmpty || state.otp.length != 6 || !RegExp(r'^\d{6}$').hasMatch(state.otp)) {
      emit(state.copyWith(
        apiStatus: ApiStatus.error,
        message: 'OTP is required and must be 6 digits.',
      ));
      return;
    }

    emit(state.copyWith(apiStatus: ApiStatus.loading, message: ''));

    try {
      final loginDataJson = await secureStorage.read(key: 'loginData');

      if (loginDataJson == null || loginDataJson.isEmpty) {
        emit(state.copyWith(
          apiStatus: ApiStatus.error,
          message: 'Login data not found in secure storage.',
        ));
        return;
      }

// Parse JSON
      final Map<String, dynamic> loginData = jsonDecode(loginDataJson);

// Extract UserId and Username
      final storedUserId = loginData['UserId']?.toString() ?? '';
      final username = loginData['Username']?.toString() ?? '';

      if (storedUserId.isEmpty || username.isEmpty) {
        emit(state.copyWith(
          apiStatus: ApiStatus.error,
          message: 'UserId or Username missing in login data.',
        ));
        return;
      }

      print('🔹 Extracted from loginData -> UserId: $storedUserId, Username: $username');


      final verifyOTPData = {
        'verificationCode': state.otp,
        'Username': username,
        'UserId': storedUserId,
      };

      // Encrypt session
      final session = await encryptWithSession(
        data: verifyOTPData,
        rsaPublicKeyPem: rsaPublicKeyPem,
      );

      print('🔒 Encrypted request payload to server: ${session.payloadForServer}');

      final encryptedResponse =
      await otpverificationrepository.VerifyLoginOTPApi(session.payloadForServer);

      print('🛡️ Encrypted response from server: $encryptedResponse');

      if (encryptedResponse != null) {
        // Decrypt response
        String decrypted = '';
        try {
          final encryptedDataBase64 =
          (encryptedResponse['encryptedData'] ?? encryptedResponse['EncryptedData']) as String;
          final serverIvBase64 =
          (encryptedResponse['iv'] ?? encryptedResponse['IV']) as String;

          decrypted = utf8.decode(
            aesCbcDecrypt(
              base64ToBytes(encryptedDataBase64),
              session.aesKeyBytes,
              base64ToBytes(serverIvBase64),
            ),
          );

          print('✅ Decrypted server response: $decrypted');
          await secureStorage.write(key: 'isVerify', value: '1');
        } catch (e) {
          print('⚠️ Decryption failed: $e');
          decrypted = '{}'; // fallback
        }

        // Save decrypted response to secure storage if needed
        // await secureStorage.write(key: 'loginData', value: decrypted);

        emit(state.copyWith(apiStatus: ApiStatus.success, isOtpVerified: true));
      } else {
        emit(state.copyWith(apiStatus: ApiStatus.error, message: 'OTP verification failed'));
      }
    } catch (e) {
      print('❌ OTP verification exception: $e');
      emit(state.copyWith(
        apiStatus: ApiStatus.error,
        message: 'Something went wrong: $e',
      ));
    }
  }

}
