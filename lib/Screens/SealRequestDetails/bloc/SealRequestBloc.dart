import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_inspector/Screens/RequestSealNumber/repository/requestRepository.dart';
import 'package:food_inspector/Screens/SealRequestDetails/model/SealRequestModel.dart';

import '../../../common/ApiResponse.dart';
import '../../../common/ENcryption_Decryption/AES.dart';
import '../../../common/ENcryption_Decryption/key.dart';
import '../../../core/utils/enums.dart';
import '../../Sample list/bloc/sampleBloc.dart';
import '../repository/SealRequestRepository.dart';

part 'SealRequestEvent.dart';
part 'SealRequestState.dart';


class SealRequestBloc extends Bloc<SealRequestEvent, SealRequestState>{
  final RequestedSealRepository requestedSealRepository;
  SealRequestBloc({required this.requestedSealRepository}): super(SealRequestState(fetchRequestData: ApiResponse.loading())){
    on<getRequestDataEvent>(_requestData);
  }

  final SealRequestRepository _repository = SealRequestRepository();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> _requestData(
      getRequestDataEvent event,
      Emitter<SealRequestState> emit,
      ) async {
    emit(state.copyWith(fetchRequestData: ApiResponse.loading()));

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

      final Map<String, dynamic> requestData = {
        "UserID": userId,
      };

      final encryptedRequest = await encryptWithSession(
        data: requestData,
        rsaPublicKeyPem: rsaPublicKeyPem,
      );

      final Map<String, String> body = {
        'encryptedData': encryptedRequest.payloadForServer['EncryptedData']!,
        'encryptedAESKey': encryptedRequest.payloadForServer['EncryptedAESKey']!,
        'iv': encryptedRequest.payloadForServer['IV']!,
      };

      final encryptedResponse = await requestedSealRepository.requestSealApi(body);

      if (encryptedResponse == null) {
        emit(state.copyWith(
            fetchRequestData: ApiResponse.error('No response from server')));
        return;
      }

      // 6️⃣ Decrypt response
      String decryptedJson;
      try {
        final String onlyEncryptedData = (encryptedResponse['encryptedData'] ?? encryptedResponse['EncryptedData']) as String;
        decryptedJson = utf8.decode(
          aesCbcDecrypt(
            base64ToBytes(onlyEncryptedData),
            encryptedRequest.aesKeyBytes,
            encryptedRequest.ivBytes,
          ),
        );
      } catch (_) {
        final String encryptedAESKey =
        (encryptedResponse['encryptedAESKey'] ?? encryptedResponse['EncryptedAESKey']) as String;
        final String encryptedDataResp =
        (encryptedResponse['encryptedData'] ?? encryptedResponse['EncryptedData']) as String;
        final String iv = (encryptedResponse['iv'] ?? encryptedResponse['IV']) as String;

        decryptedJson = await decrypt(
          encryptedAESKeyBase64: encryptedAESKey,
          encryptedDataBase64: encryptedDataResp,
          ivBase64: iv,
          rsaPrivateKeyPem: rsaPrivateKeyPem,
        );
      }

      final decodedObj = jsonDecode(decryptedJson);
      final SealRequestModel model = decodedObj is Map<String, dynamic>
          ? SealRequestModel.fromJson(decodedObj)
          : SealRequestModel.fromJson({'success': true, 'statusCode': 200, 'message': 'OK', 'data': decodedObj});

      emit(state.copyWith(fetchRequestData: ApiResponse.complete(model)));
      return;
    } catch (e) {
      if (state.fetchRequestData.status != Status.complete) {
        emit(state.copyWith(
            fetchRequestData: ApiResponse.error('Something went wrong: $e')));
      }
    }
  }

}