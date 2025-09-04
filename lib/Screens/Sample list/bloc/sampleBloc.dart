import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_inspector/Screens/Sample%20list/model/sampleData.dart';
import 'package:food_inspector/Screens/Sample%20list/model/view_form6_model.dart';
import 'package:food_inspector/Screens/Sample%20list/repository/sampleRepository.dart';
import 'package:food_inspector/common/ApiResponse.dart';
import '../../../common/ENcryption_Decryption/AES.dart';
import '../../../common/ENcryption_Decryption/key.dart';
import '../../../core/utils/enums.dart';

part 'sampleEvent.dart';
part 'sampleState.dart';

final secureStorage = FlutterSecureStorage();

class SampleBloc extends Bloc<SampleEvent, getSampleListState> {
  final SampleRepository sampleRepository;

  SampleBloc({required this.sampleRepository})
      : super(getSampleListState(fetchSampleList: ApiResponse.loading(), getFormData: ApiResponse.loading())) {
    on<getSampleListEvent>(_getSampleListEvent);
    on<getFormEvent>(_getFormData);
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

      final loginDataMap = jsonDecode(loginDataStr) as Map<String, dynamic>;
      final dynamic uidRaw = loginDataMap['UserId'] ?? loginDataMap['userId'] ?? loginDataMap['user_id'];
      final int? userId = uidRaw is int ? uidRaw : int.tryParse(uidRaw?.toString() ?? '');
      if (userId == null || userId <= 0) {
        emit(state.copyWith(
            fetchSampleList: ApiResponse.error('Invalid user id in secure storage')));
        return;
      }

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

      print('GetSamples request (decrypted JSON): ${jsonEncode(requestData)}');
      print('GetSamples request (encrypted body): ${jsonEncode(body)}');

      final encryptedResponse = await sampleRepository.getSampleData(body);


      if (encryptedResponse == null) {
        emit(state.copyWith(
            fetchSampleList: ApiResponse.error('No response from server')));
        return;
      }

      // 6️⃣ Decrypt response
      String decryptedJson;
      try {
        // Primary: some mobile APIs return only encryptedData and reuse request AES key/IV
        final String onlyEncryptedData = (encryptedResponse['encryptedData'] ?? encryptedResponse['EncryptedData']) as String;
        decryptedJson = utf8.decode(
          aesCbcDecrypt(
            base64ToBytes(onlyEncryptedData),
            encryptedRequest.aesKeyBytes,
            encryptedRequest.ivBytes,
          ),
        );
      } catch (_) {
        // Fallback: response contains RSA-encrypted AES key and IV
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

      print('GetSamples response (decrypted JSON): $decryptedJson');
      await secureStorage.write(key: 'sampleListData', value: decryptedJson);
      final storedSampleList = await secureStorage.read(key: 'sampleListData');
      print('Stored SampleList in secureStorage: $storedSampleList');
      final decodedObj = jsonDecode(decryptedJson);
      List<dynamic> listJson;
      if (decodedObj is Map<String, dynamic>) {
        listJson = (decodedObj['SampleList'] ?? decodedObj['sampleList'] ?? []) as List<dynamic>;
      } else {
        listJson = decodedObj as List<dynamic>;
      }
      final List<SampleList> items = listJson
          .map((e) => SampleList.fromJson(e as Map<String, dynamic>))
          .toList();

      // Wrap into the existing UI model shape: List<SampleData> with one entry
      final List<SampleData> uiData = [
        SampleData(sampleList: items, success: true, message: 'OK', statusCode: 200),
      ];

      emit(state.copyWith(fetchSampleList: ApiResponse.complete(uiData)));
      return;
    } catch (e) {
      // Log and do not overwrite success state if already emitted
      print('GetSamples error: $e');
      if (state.fetchSampleList.status != Status.complete) {
        emit(state.copyWith(
            fetchSampleList: ApiResponse.error('Something went wrong: $e')));
      }
    }
  }

  Future<void> _getFormData(
      getFormEvent event,
      Emitter<getSampleListState> emit,
      ) async {
    emit(state.copyWith(getFormData: ApiResponse.loading()));

    try {
      final String serialNo = event.serialNo;
      final dynamic serialValue = int.tryParse(serialNo) ?? serialNo;

      final Map<String, dynamic> requestData = {
        "SerialNo": serialValue,
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

      print('GetFormVI request (decrypted JSON): ${jsonEncode(requestData)}');
      print('GetFormVI request (encrypted body): ${jsonEncode(body)}');

      final encryptedResponse = await sampleRepository.getFormData(body);

      if (encryptedResponse == null) {
        emit(state.copyWith(
            getFormData: ApiResponse.error('No response from server')));
        return;
      }

      // Decrypt response
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

      print('GetFormVI response (decrypted JSON): $decryptedJson');

      // Parse into ViewForm6Model robustly
      final dynamic decodedObj = jsonDecode(decryptedJson);
      ViewForm6Model viewModel;
      if (decodedObj is Map<String, dynamic>) {
        Map<String, dynamic> map = decodedObj;
        // unwrap common envelopes like { data: {...} } or { result: {...} }
        final envelopeKeys = ['data', 'Data', 'result', 'Result', 'response', 'Response'];
        for (final k in envelopeKeys) {
          final inner = map[k];
          if (inner is Map<String, dynamic>) {
            map = inner;
            break;
          }
        }
        final dynamic detailsDyn = map['form6Details'] ?? map['Form6Details'];
        if (detailsDyn is List) {
          final List<Form6Details> details = detailsDyn
              .map((e) => Form6Details.fromJson(e as Map<String, dynamic>))
              .toList();
          viewModel = ViewForm6Model(
            success: (map['success'] ?? true) == true,
            message: map['message']?.toString(),
            statusCode: (map['statusCode'] ?? 200) as num,
            form6Details: details,
          );
        } else {
          viewModel = ViewForm6Model.fromJson(map);
        }
      } else if (decodedObj is List) {
        final List<Form6Details> details = decodedObj
            .map((e) => Form6Details.fromJson(e as Map<String, dynamic>))
            .toList();
        viewModel = ViewForm6Model(
          success: true,
          message: 'OK',
          statusCode: 200,
          form6Details: details,
        );
      } else {
        viewModel = ViewForm6Model(
          success: false,
          message: 'Unexpected response shape',
          statusCode: 0,
          form6Details: const [],
        );
      }

      print('FormVI parsed details count: \'${viewModel.form6Details?.length}\'');
      if ((viewModel.form6Details ?? []).isNotEmpty) {
        final first = viewModel.form6Details!.first;
        print('First detail serial: \'${first.serialNo}\', sampleName: \'${first.sampleName}\'');
      }

      emit(state.copyWith(getFormData: ApiResponse.complete(viewModel)));
      return;
    } catch (e) {
      print('GetFormVI error: $e');
      if (state.getFormData.status != Status.complete) {
        emit(state.copyWith(
            getFormData: ApiResponse.error('Something went wrong: $e')));
      }
    }
  }
}
