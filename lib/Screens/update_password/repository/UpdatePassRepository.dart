import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../Network/NetworkServiceApi.dart';
import '../../../common/APIs/APIEndpoint.dart';
import '../../../common/APIs/BaseUrl.dart';

class UpdatePassRepository {
  final _api = NetworkServiceApi();
  final _secureStorage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> UpdatePassApi(dynamic data) async {
    final String updatePassUrl = ApiBase.baseUrl + ApiEndpoints.ChangePassword;


    final token = await _secureStorage.read(key: 'authToken');
    if (token == null) {
      throw Exception('No auth token found. Please log in.');
    }

    print('Sending update password request to $updatePassUrl');
    print('Token: $token');
    print('Payload: $data');

    final response = await _api.postApi(
      updatePassUrl,
      data,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return response;
  }
}
