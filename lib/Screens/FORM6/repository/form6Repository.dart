import 'package:food_inspector/Network/NetworkServiceApi.dart';

import '../../../common/APIs/APIEndpoint.dart';
import '../../../common/APIs/BaseUrl.dart';
import '../../login/model/UserModel.dart';

class Form6Repository{
  final _api = NetworkServiceApi();
  Future<dynamic> FormSixApi(dynamic data) async{
    final formSixUrl = ApiBase.baseUrl + ApiEndpoints.login;
    final response = await _api.postApi(formSixUrl, data);
    return UserModel.fromJson(response);
  }
}