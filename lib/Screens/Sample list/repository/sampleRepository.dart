import 'package:food_inspector/Network/NetworkServiceApi.dart';
import '../../../common/APIs/APIEndpoint.dart';
import '../../../common/APIs/BaseUrl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SampleRepository {
  final _api = NetworkServiceApi();

  Future<dynamic> getSampleData(Map<String, String> encryptedBody) async {
    const storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'authToken');
    final String url = '${ApiBase.baseUrl}${ApiEndpoints.getSamples}';

    final headers = <String, String>{
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    final response = await _api.postApi(url, encryptedBody, headers: headers);
    return response;
  }
}
