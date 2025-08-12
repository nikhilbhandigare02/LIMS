import 'package:food_inspector/Network/NetworkServiceApi.dart';
import '../../../common/APIs/APIEndpoint.dart';
import '../../../common/APIs/BaseUrl.dart';
import '../model/UserModel.dart';

class LoginRepository {
  final _api = NetworkServiceApi();

  Future<Map<String, dynamic>> loginApi(dynamic data) async {
    final String loginUrl = ApiBase.baseUrl + ApiEndpoints.login;
    final response = await _api.postApi(loginUrl, data);
    // Log the raw login API response to console
    // This helps to verify what server returns after pressing the login button
    // It will print a JSON Map or whatever the backend returns
    // Remove or adjust logging for production as needed
    // ignore: avoid_print
    print('Login API response: $response');
    return response;
  }
}

