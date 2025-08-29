import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_inspector/Screens/RequestSealNumber/repository/requestRepository.dart';

import '../../../common/ENcryption_Decryption/AES.dart';
import '../../../common/ENcryption_Decryption/key.dart';
import '../../../core/utils/enums.dart';
import '../../Sample list/bloc/sampleBloc.dart';

part 'request_Event.dart';
part 'request_state.dart';


class RequestStateBloc extends Bloc<RequestSealEvent, RequestSealState>{
  final RequestedSealRepository requestedSealRepository;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  RequestStateBloc({required this.requestedSealRepository}):super(const RequestSealState()){
    on<RequestDateEvent>(requestDate);
    on<SubmitRequestEvent>(submitRequest);
  }

  void requestDate(RequestDateEvent event, Emitter<RequestSealState> emit){
    print(state.selectedDate);
    emit(state.copyWith(selectedDate: event.selectedDate));
  }

  Future<void> submitRequest(
      SubmitRequestEvent event,
      Emitter<RequestSealState> emit,
      ) async {
    emit(state.copyWith(apiStatus: ApiStatus.loading));
    try {

      final String? loginData = await secureStorage.read(key: 'loginData');

      if (loginData == null) {
        print('Login data not found in secure storage');
        return;
      }

      final Map<String, dynamic> loginMap = jsonDecode(loginData);
      final String? userId = loginMap['UserId']?.toString();

      if (userId == null) {
        print('UserID not found in login data');
        return;
      }

      print('UserID: $userId');


      final verifyOTPData = {
        'RequestedDate': state.selectedDate,
        'UserId': userId,
      };

      final session = await encryptWithSession(
        data: verifyOTPData,
        rsaPublicKeyPem: rsaPublicKeyPem,
      );

      // Call API
      final encryptedResponse = await requestedSealRepository.requestSealApi(session.payloadForServer);

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
          message: 'Request for seal number sent to the authorized DO successfully',
        ));
      } else {
        emit(state.copyWith(
          apiStatus: ApiStatus.error,
          message: 'Failed to receive a response from the server.',
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