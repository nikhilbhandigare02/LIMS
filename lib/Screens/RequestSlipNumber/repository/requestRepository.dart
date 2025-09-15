import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_inspector/common/APIs/APIEndpoint.dart';
import 'package:food_inspector/common/APIs/BaseUrl.dart';

import '../../../Network/NetworkServiceApi.dart';

class RequestedSealRepository{
  final _api = NetworkServiceApi();

  Future<dynamic>  requestSlipApi(dynamic data) async{
    const storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'authToken');
    final requestUrl = ApiBase.baseUrl + ApiEndpoints.requestforseal;
    final headers = token != null && token.isNotEmpty ? {'Authorization': 'Bearer $token'} : null;
    final response = await _api.postApi(requestUrl, data,headers: headers);
    return response;
  }
}