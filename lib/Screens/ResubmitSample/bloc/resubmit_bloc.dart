import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_inspector/common/ApiResponse.dart';
import '../../../core/utils/enums.dart';
import '../../Sample list/model/sampleData.dart';
import '../repository/resubmit_repository.dart';
import '../../../common/ENcryption_Decryption/AES.dart';
import '../../../common/ENcryption_Decryption/key.dart';

part 'resubmit_event.dart';
part 'resubmit_state.dart';

class ResubmitBloc extends Bloc<ResubmitEvent, ResubmitState> {
  final ResubmitRepository repository;
  static const _storage = FlutterSecureStorage();

  ResubmitBloc({required this.repository}) : super(ResubmitState(fetchList: ApiResponse.loading(), updateStatus: ApiResponse.complete(null))) {
    on<FetchApprovedSamplesByUser>(_onFetchApprovedSamplesByUser);
    on<UpdateStatusResubmitRequested>(_onUpdateStatusResubmit);
  }

  Future<void> _onFetchApprovedSamplesByUser(
    FetchApprovedSamplesByUser event,
    Emitter<ResubmitState> emit,
  ) async {
    emit(state.copyWith(fetchList: ApiResponse.loading()));

    try {
      final loginDataStr = await _storage.read(key: 'loginData');
      if (loginDataStr == null || loginDataStr.isEmpty) {
        emit(state.copyWith(fetchList: ApiResponse.error('User not logged in')));
        return;
      }
      final loginData = jsonDecode(loginDataStr) as Map<String, dynamic>;
      final dynamic uidRaw = loginData['UserId'] ?? loginData['userId'] ?? loginData['user_id'];
      final int? userId = uidRaw is int ? uidRaw : int.tryParse(uidRaw?.toString() ?? '');
      if (userId == null || userId <= 0) {
        emit(state.copyWith(fetchList: ApiResponse.error('Invalid user id in secure storage')));
        return;
      }

      final request = {
        // Backend expects 'UserId' per ApprovedSamplesByUserInputDO
        'UserId': userId,
      };

      // Debug: print unencrypted request JSON
      try {
        print('ApprovedSamplesByUser request (decrypted JSON): ' + jsonEncode(request));
      } catch (_) {}

      final session = await encryptWithSession(data: request, rsaPublicKeyPem: rsaPublicKeyPem);
      final body = {
        'encryptedData': session.payloadForServer['EncryptedData']!,
        'encryptedAESKey': session.payloadForServer['EncryptedAESKey']!,
        'iv': session.payloadForServer['IV']!,
      };

      // Debug: print encrypted payload being sent
      try {
        print('ApprovedSamplesByUser request (encrypted body): ' + jsonEncode(body));
      } catch (_) {}

      final encryptedResponse = await repository.getApprovedSamplesByUser(body);
      if (encryptedResponse == null) {
        emit(state.copyWith(fetchList: ApiResponse.error('No response from server')));
        return;
      }

      String decryptedJson;
      try {
        final String onlyEncryptedData = (encryptedResponse['encryptedData'] ?? encryptedResponse['EncryptedData']) as String;
        decryptedJson = utf8.decode(
          aesCbcDecrypt(
            base64ToBytes(onlyEncryptedData),
            session.aesKeyBytes,
            session.ivBytes,
          ),
        );
      } catch (_) {
        final String encryptedAESKey = (encryptedResponse['encryptedAESKey'] ?? encryptedResponse['EncryptedAESKey']) as String;
        final String encryptedDataResp = (encryptedResponse['encryptedData'] ?? encryptedResponse['EncryptedData']) as String;
        final String iv = (encryptedResponse['iv'] ?? encryptedResponse['IV']) as String;
        decryptedJson = await decrypt(
          encryptedAESKeyBase64: encryptedAESKey,
          encryptedDataBase64: encryptedDataResp,
          ivBase64: iv,
          rsaPrivateKeyPem: rsaPrivateKeyPem,
        );
      }

      // Debug: print decrypted response JSON
      try {
        print('ApprovedSamplesByUser response (decrypted JSON): ' + decryptedJson);
      } catch (_) {}

      final decoded = jsonDecode(decryptedJson);
      List<dynamic> listJson;
      if (decoded is Map<String, dynamic>) {
        // Response shape per backend:
        // { Success: bool, Message: string, StatusCode: int, ApprovedSamples: [ {...} ] }
        // Also be resilient to envelopes like data/result/response
        final envelopeKeys = ['data', 'Data', 'result', 'Result', 'response', 'Response'];
        Map<String, dynamic> map = decoded;
        for (final k in envelopeKeys) {
          final inner = map[k];
          if (inner is Map<String, dynamic>) {
            map = inner;
            break;
          }
        }
        final dynamic arr = map['ApprovedSamples'] ?? map['approvedSamples'] ?? map['SampleList'] ?? map['sampleList'] ?? map['list'] ?? map['List'] ?? map['items'];
        if (arr is List) {
          listJson = arr;
        } else if (arr is Map<String, dynamic>) {
          listJson = [arr];
        } else {
          // No explicit list key; try to detect if whole map is one item
          listJson = [map];
        }
      } else if (decoded is List) {
        listJson = decoded;
      } else {
        emit(state.copyWith(fetchList: ApiResponse.error('Unexpected response shape')));
        return;
      }

      final items = listJson.map((e) => SampleList.fromJson(e as Map<String, dynamic>)).toList();
      emit(state.copyWith(fetchList: ApiResponse.complete(items)));
    } catch (e) {
      emit(state.copyWith(fetchList: ApiResponse.error('Something went wrong: $e')));
    }
  }
}

extension on ResubmitBloc {
  Future<void> _onUpdateStatusResubmit(
    UpdateStatusResubmitRequested event,
    Emitter<ResubmitState> emit,
  ) async {
    emit(state.copyWith(updateStatus: ApiResponse.loading()));

    try {
      final request = {
        // Backend expects these exact casings
        'SerialNo': event.serialNo,
        'InsertedBy': event.insertedBy,
      };

      // Debug: print unencrypted request
      try {
        print('UpdateStatusResubmit request (decrypted JSON): ' + jsonEncode(request));
      } catch (_) {}

      final session = await encryptWithSession(data: request, rsaPublicKeyPem: rsaPublicKeyPem);
      final body = {
        'encryptedData': session.payloadForServer['EncryptedData']!,
        'encryptedAESKey': session.payloadForServer['EncryptedAESKey']!,
        'iv': session.payloadForServer['IV']!,
      };

      // Debug: print encrypted payload
      try {
        print('UpdateStatusResubmit request (encrypted body): ' + jsonEncode(body));
      } catch (_) {}

      final encryptedResponse = await repository.updateStatusResubmit(body);
      if (encryptedResponse == null) {
        emit(state.copyWith(updateStatus: ApiResponse.error('No response from server')));
        return;
      }

      String decryptedJson;
      try {
        final String onlyEncryptedData = (encryptedResponse['encryptedData'] ?? encryptedResponse['EncryptedData']) as String;
        decryptedJson = utf8.decode(
          aesCbcDecrypt(
            base64ToBytes(onlyEncryptedData),
            session.aesKeyBytes,
            session.ivBytes,
          ),
        );
      } catch (_) {
        final String encryptedAESKey = (encryptedResponse['encryptedAESKey'] ?? encryptedResponse['EncryptedAESKey']) as String;
        final String encryptedDataResp = (encryptedResponse['encryptedData'] ?? encryptedResponse['EncryptedData']) as String;
        final String iv = (encryptedResponse['iv'] ?? encryptedResponse['IV']) as String;
        decryptedJson = await decrypt(
          encryptedAESKeyBase64: encryptedAESKey,
          encryptedDataBase64: encryptedDataResp,
          ivBase64: iv,
          rsaPrivateKeyPem: rsaPrivateKeyPem,
        );
      }

      // Debug: response plaintext
      try {
        print('UpdateStatusResubmit response (decrypted JSON): ' + decryptedJson);
      } catch (_) {}

      // Expecting { Success: bool, Message: string, StatusCode: int }
      final Map<String, dynamic> map = jsonDecode(decryptedJson) as Map<String, dynamic>;
      final bool success = (map['Success'] ?? map['success'] ?? false) == true;
      final String message = (map['Message'] ?? map['message'] ?? 'Operation completed').toString();

      if (success) {
        emit(state.copyWith(updateStatus: ApiResponse.complete(message)));
        // Optionally refresh list
        add(const FetchApprovedSamplesByUser());
      } else {
        emit(state.copyWith(updateStatus: ApiResponse.error(message)));
      }
    } catch (e) {
      emit(state.copyWith(updateStatus: ApiResponse.error('Something went wrong: $e')));
    }
  }
}
