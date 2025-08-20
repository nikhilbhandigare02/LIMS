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
  Future<dynamic> VerifyOTPApi(dynamic data) async {
    final verifyOTP = ApiBase.baseUrl + ApiEndpoints.verifyOTP;
    final response = await _api.postApi(verifyOTP, data);
    return response;
  }

  Future<dynamic> resetPassApi(dynamic data) async {
    final resetPass = ApiBase.baseUrl + ApiEndpoints.resetPassword;
    final response = await _api.postApi(resetPass, data);
    return response;
  }
}