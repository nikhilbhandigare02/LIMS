import 'package:food_inspector/Network/NetworkServiceApi.dart';
import '../../../../common/APIs/APIEndpoint.dart';
import '../../../../common/APIs/BaseUrl.dart';


class Otpverificationrepository {
  final _api = NetworkServiceApi();

  Future<Map<String, dynamic>> VerifyLoginOTPApi(dynamic data) async {
    // Verify Login OTP endpoint
    final String verifyOtpUrl = ApiBase.baseUrl + ApiEndpoints.VerifyLoginOTP;
    print('Calling Verify Login OTP URL: ' + verifyOtpUrl);
    print('Request payload (encrypted): ' + data.toString());
    final response = await _api.postApi(verifyOtpUrl, data);
    print('Verify Login OTP API response: ' + response.toString());
    return response;
  }
}

