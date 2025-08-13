import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_inspector/Screens/Sample%20list/model/sampleData.dart';
import 'package:food_inspector/Screens/Sample%20list/repository/sampleRepository.dart';
import 'package:food_inspector/common/ApiResponse.dart';
import '../../../common/ENcryption_Decryption/AES.dart';
import '../../../common/ENcryption_Decryption/key.dart';

part 'sampleEvent.dart';
part 'sampleState.dart';

final secureStorage = FlutterSecureStorage();

class SampleBloc extends Bloc<getSampleListEvent, getSampleListState> {
  final SampleRepository sampleRepository;

  SampleBloc({required this.sampleRepository})
      : super(getSampleListState(fetchSampleList: ApiResponse.loading())) {
    on<getSampleListEvent>(_getSampleListEvent);
  }

  Future<void> _getSampleListEvent(
      getSampleListEvent event,
      Emitter<getSampleListState> emit,
      ) async {
    emit(state.copyWith(fetchSampleList: ApiResponse.loading()));

    try {
      // 1️⃣ Read loginData
      final loginDataStr = await secureStorage.read(key: 'loginData');
      if (loginDataStr == null) {
        emit(state.copyWith(
            fetchSampleList: ApiResponse.error('User not logged in')));
        return;
      }

      final loginDataMap = jsonDecode(loginDataStr);
      final int userId = loginDataMap['UserId'] ?? loginDataMap['userId'];

      // 2️⃣ Read token
      final token = await secureStorage.read(key: 'authToken');
      if (token == null || token.isEmpty) {
        emit(state.copyWith(
            fetchSampleList: ApiResponse.error('User token not found')));
        return;
      }

      // 3️⃣ Build request payload
      final Map<String, dynamic> requestData = {
        "UserID": userId,
      };

      // 4️⃣ Encrypt request payload
      final encryptedRequest = await encryptWithSession(
        data: requestData,
        rsaPublicKeyPem: rsaPublicKeyPem,
      );

      final String encryptedData = encryptedRequest.payloadForServer;

      // 5️⃣ Call repository with encryptedData and token
      final encryptedResponse =
      await sampleRepository.getSampleData(encryptedData, token);

      if (encryptedResponse == null) {
        emit(state.copyWith(
            fetchSampleList: ApiResponse.error('No response from server')));
        return;
      }

      // 6️⃣ Decrypt response
      final String encryptedAESKey =
      (encryptedResponse['encryptedAESKey'] ??
          encryptedResponse['EncryptedAESKey']) as String;
      final String encryptedDataResp =
      (encryptedResponse['encryptedData'] ??
          encryptedResponse['EncryptedData']) as String;
      final String iv =
      (encryptedResponse['iv'] ?? encryptedResponse['IV']) as String;

      final String decryptedJson = await decrypt(
        encryptedAESKeyBase64: encryptedAESKey,
        encryptedDataBase64: encryptedDataResp,
        ivBase64: iv,
        rsaPrivateKeyPem: rsaPrivateKeyPem,
      );

      final List<dynamic> decodedList = jsonDecode(decryptedJson);
      final List<SampleData> sampleList = decodedList
          .map((e) => SampleData.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(state.copyWith(fetchSampleList: ApiResponse.complete(sampleList)));
    } catch (e) {
      emit(state.copyWith(
          fetchSampleList: ApiResponse.error('Something went wrong: $e')));
    }
  }
}
