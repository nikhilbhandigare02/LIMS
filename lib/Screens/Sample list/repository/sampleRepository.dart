import 'package:food_inspector/Network/NetworkServiceApi.dart';
import '../../../common/APIs/APIEndpoint.dart';
import '../../../common/APIs/BaseUrl.dart';

class SampleRepository {
  final _api = NetworkServiceApi();

  Future<dynamic> getSampleData(String encryptedData, String token) async {
    final String url =
        '${ApiBase.baseUrl}${ApiEndpoints.getSamples}?encryptedData=$encryptedData';

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await _api.getApi(url, headers: headers);
    return response;
  }
}
