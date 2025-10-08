import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../common/ENcryption_Decryption/AES.dart';
import '../../../common/ENcryption_Decryption/key.dart';
import '../../../core/utils/enums.dart';
import '../repository/loginRepository.dart';
part 'loginEvent.dart';
part 'loginState.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

//login block
  LoginBloc({required this.loginRepository}) : super(const LoginState()) {
    on<UsernameEvent>(username);
    on<PasswordEvent>(password);
    on<LoginButtonEvent>(submitButton);
  }

  void username(UsernameEvent event, Emitter<LoginState> emit) {
    print(state.username);
    emit(state.copyWith(username: event.username));
  }

  void password(PasswordEvent event, Emitter<LoginState> emit) {
    print(state.password);
    emit(state.copyWith(password: event.password));
  }

  Future<void> submitButton(
      LoginButtonEvent event,
      Emitter<LoginState> emit,
      ) async {
    emit(state.copyWith(apiStatus: ApiStatus.loading));
    try {
      final loginData = {
        'Username': state.username,
        'Password': state.password,
      };

      final session = await encryptWithSession(
        data: loginData,
        rsaPublicKeyPem: rsaPublicKeyPem,
      );

      final encryptedResponse = await loginRepository.loginApi(session.payloadForServer);

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

          print('Decrypted login response: $decrypted');

          await secureStorage.write(key: 'loginData', value: decrypted);
          print('Login data stored securely.');

          final Map<String, dynamic> loginResponseMap = jsonDecode(decrypted);
          final String? token = loginResponseMap['Token'];
          final String? senderFullName = loginResponseMap['FullName'];
          // Try to read user id with multiple possible keys and persist
          final dynamic userIdRaw = loginResponseMap['UserId'] ?? loginResponseMap['userId'] ?? loginResponseMap['UserID'];
          if (userIdRaw != null) {
            await secureStorage.write(key: 'user_id', value: userIdRaw.toString());
          }

          if (token != null && token.isNotEmpty) {
            await secureStorage.write(key: 'authToken', value: token);
            await secureStorage.write(key: 'sender name', value: senderFullName);

          if (state.username.isNotEmpty) {
            await secureStorage.write(key: 'lastUsername', value: state.username);
          }

            print('Auth token and sender Name stored securely.');
          } else {
            print('Token & sender Name not found in login response.');
          }
        } catch (e) {
          print('Failed to decrypt login response: $e');
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
            print('Decrypted (fallback) login response: $decryptedFallback');

              await secureStorage.write(key: 'loginData', value: decryptedFallback);

            final Map<String, dynamic> fallbackMap = jsonDecode(decryptedFallback);
            final String? fallbackToken = fallbackMap['Token'];
            // Persist user id from fallback as well
            final dynamic userIdRaw = fallbackMap['UserId'] ?? fallbackMap['userId'] ?? fallbackMap['UserID'];
            if (userIdRaw != null) {
              await secureStorage.write(key: 'user_id', value: userIdRaw.toString());
            }
            if (fallbackToken != null && fallbackToken.isNotEmpty) {
              await secureStorage.write(key: 'authToken', value: fallbackToken);
              // Persist last logged-in username for quick login (fallback)
              if (state.username.isNotEmpty) {
                await secureStorage.write(key: 'lastUsername', value: state.username);
              }
              print('Fallback auth token stored securely.');
            } else {
              print('Token not found in fallback login response.');
            }
          } catch (e2) {
            print('Fallback decryption also failed: $e2');
          }
        }
        emit(state.copyWith(
          message: 'loginSuccess',
          apiStatus: ApiStatus.success,
        ));
      } else {
        emit(state.copyWith(
          message: 'serverNoResponse',
          apiStatus: ApiStatus.error,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        message: 'somethingWentWrong:$e',
        apiStatus: ApiStatus.error,
      ));
    }
  }


}
