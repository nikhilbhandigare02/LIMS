import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_inspector/Network/NetworkServiceApi.dart';
import 'package:food_inspector/common/APIs/APIEndpoint.dart';
import 'package:food_inspector/common/APIs/BaseUrl.dart';

class GeneratedReportsRepository {
  final _api = NetworkServiceApi();

  Future<dynamic> getGeneratedReports(Map<String, String> encryptedBody) async {
    const storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'authToken');
    final String url = '${ApiBase.baseUrl}${ApiEndpoints.getGeneratedReports}';

    final headers = <String, String>{
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    final response = await _api.postApi(url, encryptedBody, headers: headers);
    return response;
  }
}
