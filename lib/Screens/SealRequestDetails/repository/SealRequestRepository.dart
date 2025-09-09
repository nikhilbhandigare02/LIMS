
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_inspector/Network/NetworkServiceApi.dart';

import '../../../common/APIs/APIEndpoint.dart';
import '../../../common/APIs/BaseUrl.dart';

class SealRequestRepository{
  final _api = NetworkServiceApi();
  Future<dynamic> getRequestData(Map<String, String> encryptedBody) async {
    const storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'authToken');
    final String url = '${ApiBase.baseUrl}${ApiEndpoints.getRequestData}';

    final headers = <String, String>{
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    final response = await _api.postApi(url, encryptedBody, headers: headers);
    return response;
  }

  Future<dynamic> UpdateCount(Map<String, String> encryptedBody) async {
    const storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'authToken');
    final String url = '${ApiBase.baseUrl}${ApiEndpoints.updateSlipCount}';

    final headers = <String, String>{
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    final response = await _api.postApi(url, encryptedBody, headers: headers);
    return response;
  }

}