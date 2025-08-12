import 'package:food_inspector/Network/NetworkServiceApi.dart';
import '../../../common/APIs/APIEndpoint.dart';
import '../../../common/APIs/BaseUrl.dart';
import '../model/UserModel.dart';

class LoginRepository {
  final _api = NetworkServiceApi();

  Future<Map<String, dynamic>> loginApi(dynamic data) async {
    final String loginUrl = ApiBase.baseUrl + ApiEndpoints.login;
    final response = await _api.postApi(loginUrl, data);
    return response;
  }
}

