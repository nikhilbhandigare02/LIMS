import 'dart:convert';
import 'dart:io';

import 'package:food_inspector/Network/NetworkServiceApi.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../common/APIs/APIEndpoint.dart';
import '../../../common/APIs/BaseUrl.dart';
import '../model/UpdateAppModel.dart';
import '../../../common/ENcryption_Decryption/AES.dart' as crypto;
import '../../../common/ENcryption_Decryption/key.dart';

class UpdateAppRepository {
  final _api = NetworkServiceApi();

  Future<UpdateAppModel> fetchUpdateInfo() async {
    final platform = Platform.isAndroid ? 'android' : 'ios';
    final String url = '${ApiBase.baseUrl}${ApiEndpoints.appUpdate}';

    final packageInfo = await PackageInfo.fromPlatform();
    final String versionName = packageInfo.version;
    final int versionCode = int.tryParse(packageInfo.buildNumber) ?? 0;

    final Map<String, dynamic> requestData = {
      'Platform': platform,
      'CurrentVersionName': versionName,
      'CurrentVersionCode': versionCode,
    };

    // Encrypt like sample-list flow (single-session AES; lowercase body keys)
    final session = await crypto.encryptWithSession(
      data: requestData,
      rsaPublicKeyPem: rsaPublicKeyPem,
    );

    final Map<String, String> body = {
      'encryptedData': session.payloadForServer['EncryptedData']!,
      'encryptedAESKey': session.payloadForServer['EncryptedAESKey']!,
      'iv': session.payloadForServer['IV']!,
    };

    print('[Update] POST URL: $url');
    print('[Update] Request (decrypted JSON): ${jsonEncode(requestData)}');
    print('[Update] Request (encrypted body): ${jsonEncode(body)}');

    final dynamic resp = await _api.postApi(url, body);
    print('[Update] Raw response (decoded): $resp');

    // If backend returns plain JSON
    if (resp is Map<String, dynamic> &&
        (resp.containsKey('versionCode') || resp.containsKey('success'))) {
      print('[Update] Using plain JSON response path');
      return UpdateAppModel.fromJson(resp);
    }

    // Try decrypting like sample-list
    if (resp is Map<String, dynamic>) {
      try {
        final String onlyEncryptedData = (resp['encryptedData'] ?? resp['EncryptedData']) as String;
        final String ivB64 = (resp['iv'] ?? resp['IV']) as String? ?? crypto.bytesToBase64(session.ivBytes);

        final String decryptedJson = utf8.decode(
          crypto.aesCbcDecrypt(
            crypto.base64ToBytes(onlyEncryptedData),
            session.aesKeyBytes,
            crypto.base64ToBytes(ivB64),
          ),
        );
        print('[Update] Decrypted JSON (session AES path): $decryptedJson');
        final decoded = json.decode(decryptedJson);
        final Map<String, dynamic> map = decoded is Map<String, dynamic>
            ? (decoded['data'] as Map<String, dynamic>? ?? decoded['Data'] as Map<String, dynamic>? ?? decoded)
            : <String, dynamic>{};
        final model = UpdateAppModel.fromJson(map);
        // Note: version info is inside appUpdates list, backend drives updateAvailable
        return model;
      } catch (_) {
        // Fallback: RSA-encrypted AES key present in response
        final String? encKey = (resp['encryptedAESKey'] ?? resp['EncryptedAESKey']) as String?;
        final String? encData = (resp['encryptedData'] ?? resp['EncryptedData']) as String?;
        final String? iv = (resp['iv'] ?? resp['IV']) as String?;

        if (encKey != null && encData != null && iv != null) {
          final String decryptedJson = await crypto.decrypt(
            encryptedAESKeyBase64: encKey,
            encryptedDataBase64: encData,
            ivBase64: iv,
            rsaPrivateKeyPem: rsaPrivateKeyPem,
          );
          print('[Update] Decrypted JSON (RSA path): $decryptedJson');
          final decoded = json.decode(decryptedJson);
          final Map<String, dynamic> map = decoded is Map<String, dynamic>
              ? (decoded['data'] as Map<String, dynamic>? ?? decoded['Data'] as Map<String, dynamic>? ?? decoded)
              : <String, dynamic>{};
          final model = UpdateAppModel.fromJson(map);
          // Note: version info is inside appUpdates list, backend drives updateAvailable
          return model;
        }
      }
    }

    // Unknown format
    throw const FormatException('Unexpected update response format');
  }
}


