import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_inspector/common/ApiResponse.dart';
import 'package:food_inspector/core/utils/enums.dart';
import 'package:food_inspector/common/ENcryption_Decryption/AES.dart';
import 'package:food_inspector/common/ENcryption_Decryption/key.dart';
import 'package:food_inspector/Screens/ReportGeneratedSamples/model/generated_report.dart';
import 'package:food_inspector/Screens/ReportGeneratedSamples/repository/generated_reports_repository.dart';

part 'generated_reports_event.dart';
part 'generated_reports_state.dart';

final _secureStorage = const FlutterSecureStorage();

class GeneratedReportsBloc extends Bloc<GeneratedReportsEvent, GeneratedReportsState> {
  final GeneratedReportsRepository repository;
  GeneratedReportsBloc({required this.repository}) : super(GeneratedReportsState(reports: ApiResponse.loading())) {
    on<FetchGeneratedReportsRequested>(_onFetch);
  }

  Future<void> _onFetch(
    FetchGeneratedReportsRequested event,
    Emitter<GeneratedReportsState> emit,
  ) async {
    emit(state.copyWith(reports: ApiResponse.loading()));
    try {
      final loginDataStr = await _secureStorage.read(key: 'loginData');
      if (loginDataStr == null) {
        emit(state.copyWith(reports: ApiResponse.error('User not logged in')));
        return;
      }
      final loginDataMap = jsonDecode(loginDataStr) as Map<String, dynamic>;
      final dynamic uidRaw = loginDataMap['UserId'] ?? loginDataMap['userId'] ?? loginDataMap['user_id'];
      final int? userId = uidRaw is int ? uidRaw : int.tryParse(uidRaw?.toString() ?? '');
      if (userId == null || userId <= 0) {
        emit(state.copyWith(reports: ApiResponse.error('Invalid user id in secure storage')));
        return;
      }

      final Map<String, dynamic> requestData = {
        "UserID": userId,
      };

      final enc = await encryptWithSession(data: requestData, rsaPublicKeyPem: rsaPublicKeyPem);
      final body = {
        'encryptedData': enc.payloadForServer['EncryptedData']!,
        'encryptedAESKey': enc.payloadForServer['EncryptedAESKey']!,
        'iv': enc.payloadForServer['IV']!,
      };

      final encryptedResponse = await repository.getGeneratedReports(body);
      if (encryptedResponse == null) {
        emit(state.copyWith(reports: ApiResponse.error('No response from server')));
        return;
      }

      String decryptedJson;
      try {
        final String onlyEncryptedData = (encryptedResponse['encryptedData'] ?? encryptedResponse['EncryptedData']) as String;
        decryptedJson = utf8.decode(
          aesCbcDecrypt(
            base64ToBytes(onlyEncryptedData),
            enc.aesKeyBytes,
            enc.ivBytes,
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

      await _secureStorage.write(key: 'generatedReports', value: decryptedJson);
      final decoded = jsonDecode(decryptedJson);
      final envelope = GeneratedReportsEnvelope.fromJson(decoded);

      emit(state.copyWith(reports: ApiResponse.complete(envelope)));
    } catch (e) {
      emit(state.copyWith(reports: ApiResponse.error('Something went wrong: $e')));
    }
  }
}
