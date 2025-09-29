import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_inspector/fcm/repository/token_repository.dart';

import '../../common/ENcryption_Decryption/AES.dart';
import '../../common/ENcryption_Decryption/key.dart';
import '../../core/utils/enums.dart';
part 'token_event.dart';
part 'token_state.dart';

class TokenBloc extends Bloc<TokenEvent, TokenState> {
  final TokenRepository repository;
  TokenBloc(this.repository) : super(const TokenState()) {
    on<SaveFcmTokenRequested>(_onSaveFcmTokenRequested);
  }

  Future<void> _onSaveFcmTokenRequested(SaveFcmTokenRequested event, Emitter<TokenState> emit) async {
    // First, put incoming values into state using copyWith
    emit(state.copyWith(
      fcmToken: event.token,
      platform: event.platform ?? 'flutter',
      apiStatus: ApiStatus.loading,
      message: '',
    ));
    try {
      // Read user info from secure storage
      const storage = FlutterSecureStorage();
      final String? loginDataJson = await storage.read(key: 'loginData');
      dynamic userId;
      if (loginDataJson != null && loginDataJson.isNotEmpty) {
        try {
          final map = jsonDecode(loginDataJson) as Map<String, dynamic>;
          final dynamic uid = map['userId'] ?? map['UserId'] ?? map['user_id'];
          if (uid is int) {
            userId = uid;
          } else if (uid != null) {
            userId = int.tryParse(uid.toString()) ?? uid.toString();
          }
        } catch (_) {}
      }

      if (userId == null) {
        emit(state.copyWith(
          apiStatus: ApiStatus.error,
          message: 'Unable to read User_Id from secure storage',
        ));
        return;
      }

      final payload = {
        'UserId': userId,
        'FcmToken': state.fcmToken,
        'Platform': state.platform,
      };

      final session = await encryptWithSession(
        data: payload,
        rsaPublicKeyPem: rsaPublicKeyPem,
      );

      print('Encrypted payload to send: ${session.payloadForServer}');

      final encryptedResponse = await repository.SaveFcmAPI(session.payloadForServer);

      if (encryptedResponse != null) {
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
          message: 'FCM token saved successfully',
          apiStatus: ApiStatus.success,
        ));
      } else {
        emit(state.copyWith(
          message: 'No response from server',
          apiStatus: ApiStatus.error,
        ));
      }
    } catch (e) {
      print('Error in SaveFcmToken: $e');
      emit(state.copyWith(
        message: 'Something went wrong: $e',
        apiStatus: ApiStatus.error,
      ));
    }
  }

}

