import '../../../Network/NetworkServiceApi.dart';
import '../../../common/APIs/APIEndpoint.dart';
import '../../../common/APIs/BaseUrl.dart';

class ForgotPasswordRepository {
  final _api = NetworkServiceApi();

  Future<dynamic> ForgotPassApi(dynamic data) async {
    final ForgotPass = ApiBase.baseUrl + ApiEndpoints.ForgotPass;
    final response = await _api.postApi(ForgotPass, data);
    return response;
  }
  // Future<dynamic> ForgotPassApi(dynamic data) async {
  //   final ForgotPass = ApiBase.baseUrl + ApiEndpoints.login;
  //   final response = await _api.postApi(ForgotPass, data);
  //   return response;
  // }
} 