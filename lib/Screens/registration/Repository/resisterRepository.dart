import 'package:food_inspector/Network/NetworkServiceApi.dart';

import '../../../common/APIs/APIEndpoint.dart';
import '../../../common/APIs/BaseUrl.dart';
import '../../login/model/UserModel.dart';

class registerRepository{
  final  _api =  NetworkServiceApi();
  Future<dynamic> registerApi(dynamic data)async{
    final String registerUrl = ApiBase.baseUrl + ApiEndpoints.login;
    final response = _api.postApi(registerUrl, data);
    return UserModel.fromJson(response);
  }
}