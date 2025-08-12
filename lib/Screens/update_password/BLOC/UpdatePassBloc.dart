import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_inspector/Screens/Sample%20list/repository/sampleRepository.dart';

import '../../../common/ENcryption_Decryption/AES.dart';
import '../../../common/ENcryption_Decryption/key.dart';
import '../../../core/utils/enums.dart';
import '../repository/UpdatePassRepository.dart';
part 'UpdatePassEvent.dart';
part 'updatePassState.dart';

class UpdatePasswordBloc extends Bloc<UpdatePasswordEvent, UpdatePasswordState> {
  final UpdatePassRepository updatePassRepository;

  UpdatePasswordBloc({required this.updatePassRepository}) : super(const UpdatePasswordState()) {
    // on<CurrentPasswordEvent>(currentPass);
    on<updateUsernameEvent>(currentPass);
    on<NewPasswordEvent>(newPass);
    on<ConformPasswordEvent>(confirmPass);
    on<UpdatePassButtonEvent>(updatePassButton);
  }

  void currentPass(updateUsernameEvent event, Emitter<UpdatePasswordState> emit) {
    print(state.Username);
    emit(state.copyWith(Username: event.username));
  }
  void newPass(NewPasswordEvent event, Emitter<UpdatePasswordState> emit) {
      print(state.NewPassword);
    emit(state.copyWith(NewPassword: event.NewPassword));
  }
  void confirmPass(ConformPasswordEvent event, Emitter<UpdatePasswordState> emit) {
    print(state.confirmPassword);

    emit(state.copyWith(confirmPassword: event.confirmPassword));
  }
// void updatePassButton(UpdatePassButtonEvent event, Emitter<UpdatePasswordState> emit) {
//
//   }



  Future<void> updatePassButton(UpdatePassButtonEvent event, Emitter<UpdatePasswordState> emit) async {
    emit(state.copyWith(apiStatus: ApiStatus.loading));
    try {
      final loginData = {
        'Username': state.Username,
        'Password': state.confirmPassword,  // current password
        'NewPassword': state.NewPassword,
      };

      final session = await encryptWithSession(
        data: loginData,
        rsaPublicKeyPem: rsaPublicKeyPem,
      );

      print('Encrypted payload to send: ${session.payloadForServer}');

      final encryptedResponse = await updatePassRepository.UpdatePassApi(session.payloadForServer);

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
          message: 'Password Changed successfully',
          apiStatus: ApiStatus.success,
        ));
      } else {
        emit(state.copyWith(
          message: 'No response from server',
          apiStatus: ApiStatus.error,
        ));
      }
    } catch (e) {
      print('Error in updatePassButton: $e');
      emit(state.copyWith(
        message: 'Something went wrong: $e',
        apiStatus: ApiStatus.error,
      ));
    }
  }

}
