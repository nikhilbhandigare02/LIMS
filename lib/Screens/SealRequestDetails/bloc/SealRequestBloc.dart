import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_inspector/Screens/RequestSealNumber/repository/requestRepository.dart';
import 'package:food_inspector/Screens/SealRequestDetails/model/SealRequestModel.dart';
import 'package:intl/intl.dart';

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
  SealRequestBloc({required this.requestedSealRepository}): super(SealRequestState(fetchRequestData: ApiResponse.loading(), count: 0)){
    on<getRequestDataEvent>(_requestData);
    on<getCountEvent>(count);
    on<updateSlipCountEvent>(_updateSlipCount);

  }
  void count(getCountEvent event, Emitter<SealRequestState> emit){
    print(state.count);
    emit(state.copyWith(count: event.count));
  }
  final SealRequestRepository _repository = SealRequestRepository();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> _requestData(
      getRequestDataEvent event,
      Emitter<SealRequestState> emit,
      ) async {
    emit(state.copyWith(fetchRequestData: ApiResponse.loading()));

    try {
      final String? loginData = await _secureStorage.read(key: 'loginData');

      if (loginData == null || loginData.isEmpty) {
        emit(state.copyWith(fetchRequestData: ApiResponse.error('Login not found')));
        return;
      }

      final Map<String, dynamic> loginMap = jsonDecode(loginData);
      String? userId = loginMap['UserId']?.toString();
      userId ??= loginMap['userId']?.toString();
      userId ??= loginMap['user_id']?.toString();
      if (userId == null || userId.isEmpty) {
        emit(state.copyWith(fetchRequestData: ApiResponse.error('UserId missing in login')));
        return;
      }

      print('UserID: $userId');

      final Map<String, dynamic> requestData = {
        "UserId": userId,
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

      final encryptedResponse = await _repository.getRequestData(body);

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

      // Debug: inspect decrypted payload shape
      // ignore: avoid_print
      print('SealRequest decrypted: ' + decryptedJson);
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

  Future<void> _updateSlipCount(
      updateSlipCountEvent event,
      Emitter<SealRequestState> emit,
      ) async {
    emit(state.copyWith(apiStatus: ApiStatus.loading, message: 'Updating count...'));

    try {
      final String? loginData = await _secureStorage.read(key: 'loginData');
      if (loginData == null || loginData.isEmpty) {
        emit(state.copyWith(apiStatus: ApiStatus.error, message: 'Login not found'));
        return;
      }

      final Map<String, dynamic> loginMap = jsonDecode(loginData);
      final String? userId = loginMap['UserId']?.toString() ??
          loginMap['userId']?.toString() ??
          loginMap['user_id']?.toString();

      if (userId == null || userId.isEmpty) {
        emit(state.copyWith(apiStatus: ApiStatus.error, message: 'UserId missing in login'));
        return;
      }

      final String currentDate = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
      final Map<String, dynamic> requestData = {
        "UserId": userId,
        "p_request_id": event.requestId,
        "SealNumbers": event.newCount,
        "RequestedDate": currentDate,
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

      final encryptedResponse = await _repository.UpdateCount(body);

      if (encryptedResponse == null) {
        emit(state.copyWith(apiStatus: ApiStatus.error, message: 'No response from server'));
        return;
      }

      String decryptedJson;
      try {
        final String encryptedDataBase64 =
        (encryptedResponse['encryptedData'] ?? encryptedResponse['EncryptedData']) as String;
        final String serverIvBase64 =
        (encryptedResponse['iv'] ?? encryptedResponse['IV']) as String;

        decryptedJson = utf8.decode(
          aesCbcDecrypt(
            base64ToBytes(encryptedDataBase64),
            encryptedRequest.aesKeyBytes,
            base64ToBytes(serverIvBase64),
          ),
        );
      } catch (_) {
        final String encryptedAESKey =
        (encryptedResponse['encryptedAESKey'] ?? encryptedResponse['EncryptedAESKey']) as String;
        final String encryptedData =
        (encryptedResponse['encryptedData'] ?? encryptedResponse['EncryptedData']) as String;
        final String iv = (encryptedResponse['iv'] ?? encryptedResponse['IV']) as String;

        decryptedJson = await decrypt(
          encryptedAESKeyBase64: encryptedAESKey,
          encryptedDataBase64: encryptedData,
          ivBase64: iv,
          rsaPrivateKeyPem: rsaPrivateKeyPem,
        );
      }

      print('Decrypted response: $decryptedJson');

      // Safely check if data exists
      final SealRequestModel? currentModel = state.fetchRequestData.data as SealRequestModel?;
      if (currentModel != null && currentModel.data != null) {
        final updatedData = currentModel.data!.map((item) {
          if (item.requestId == event.requestId) {
            return item.copyWith(count: event.newCount);
          }
          return item;
        }).toList();

        final updatedModel = currentModel.copyWith(data: updatedData);

        emit(state.copyWith(
          fetchRequestData: ApiResponse.complete(updatedModel),
          apiStatus: ApiStatus.success,
          message: 'Count updated successfully',
        ));
      } else {
        emit(state.copyWith(apiStatus: ApiStatus.error, message: 'No request data to update'));
      }
    } catch (e) {
      emit(state.copyWith(apiStatus: ApiStatus.error, message: 'Something went wrong: $e'));
    }
  }

}

