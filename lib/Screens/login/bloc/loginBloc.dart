import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../common/ENcryption_Decryption/AES.dart';
import '../../../common/ENcryption_Decryption/key.dart';
import '../../../core/utils/enums.dart';
import '../model/UserModel.dart';
import '../repository/loginRepository.dart';
part 'loginEvent.dart';
part 'loginState.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;
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

      // Use a session encryption that exposes AES key and IV so we can decrypt
      // the server's response if it reuses the same AES key
      final session = await encryptWithSession(
        data: loginData,
        rsaPublicKeyPem: rsaPublicKeyPem,
      );

      final encryptedResponse = await loginRepository.loginApi(session.payloadForServer);

      if (encryptedResponse != null) {
        print('Encrypted response received: $encryptedResponse');
        try {
          // Primary attempt: server used the SAME AES key but its OWN IV for the response
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

          print('Decrypted login response: $decrypted');

          // Optionally parse to a model if needed in future
          // final Map<String, dynamic> decryptedMap = jsonDecode(decrypted);
          // final user = UserModel.fromJson(decryptedMap);
        } catch (e) {
          print('Failed to decrypt login response: $e');
          // Fallback: try decrypting using RSA to recover AES key from server payload
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
          } catch (e2) {
            print('Fallback decryption also failed: $e2');
          }
        }

        emit(state.copyWith(
          message: 'Login request sent successfully (response is encrypted)',
          apiStatus: ApiStatus.success,
        ));
      } else {
        emit(state.copyWith(
          message: 'No response from server',
          apiStatus: ApiStatus.error,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        message: 'Something went wrong: $e',
        apiStatus: ApiStatus.error,
      ));
    }
  }

}
