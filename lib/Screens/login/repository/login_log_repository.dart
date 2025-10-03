import 'dart:convert';
import 'package:food_inspector/Network/NetworkServiceApi.dart';
import 'package:food_inspector/common/APIs/APIEndpoint.dart';
import 'package:food_inspector/common/APIs/BaseUrl.dart';
import 'package:food_inspector/common/ENcryption_Decryption/AES.dart';
import 'package:food_inspector/common/ENcryption_Decryption/key.dart';

class LoginLogRepository {
  final _api = NetworkServiceApi();

  Future<Map<String, dynamic>?> logUserLogin({
    required Map<String, dynamic> body,
  }) async {
    try {
      final session = await encryptWithSession(
        data: body,
        rsaPublicKeyPem: rsaPublicKeyPem,
      );

      final String url = ApiBase.baseUrl + ApiEndpoints.userLoginLog;
      final resp = await _api.postApi(url, session.payloadForServer);
      if (resp == null) return null;

      try {
        final String encryptedDataBase64 =
        (resp['encryptedData'] ?? resp['EncryptedData']) as String;
        final String serverIvBase64 =
        (resp['iv'] ?? resp['IV']) as String;

        final String decrypted = utf8.decode(
          aesCbcDecrypt(
            base64ToBytes(encryptedDataBase64),
            session.aesKeyBytes,
            base64ToBytes(serverIvBase64),
          ),
        );

        print("🔓 Decrypted Response (Session AES): $decrypted");
        return (jsonDecode(decrypted) as Map<String, dynamic>);
      } catch (sessionErr) {
        print("⚠️ Session AES decryption failed: $sessionErr");
      }

      try {
        final String encryptedAESKey =
        (resp['encryptedAESKey'] ?? resp['EncryptedAESKey']) as String;
        final String encryptedData =
        (resp['encryptedData'] ?? resp['EncryptedData']) as String;
        final String iv = (resp['iv'] ?? resp['IV']) as String;

        final String decryptedFallback = await decrypt(
          encryptedAESKeyBase64: encryptedAESKey,
          encryptedDataBase64: encryptedData,
          ivBase64: iv,
          rsaPrivateKeyPem: rsaPrivateKeyPem,
        );

        print("🔓 Decrypted Response (RSA Fallback): $decryptedFallback");
        return (jsonDecode(decryptedFallback) as Map<String, dynamic>);
      } catch (fallbackErr) {
        print("⚠️ RSA fallback failed: $fallbackErr");
      }
      try {
        print("⚠️ Returning raw response as JSON");
        return resp as Map<String, dynamic>;
      } catch (_) {
        print("❌ Final decryption failure: Could not parse response");
        return null;
      }
    } catch (e) {
      print("❌ logUserLogin failed: $e");
      return null;
    }
  }
}
