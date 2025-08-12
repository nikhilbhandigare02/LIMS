import 'package:food_inspector/Network/NetworkServiceApi.dart';
import 'package:food_inspector/Screens/login/model/UserModel.dart';

import '../../../common/APIs/APIEndpoint.dart';
import '../../../common/APIs/BaseUrl.dart';

class SampleRepository {
  final _api = NetworkServiceApi();

  Future<dynamic> getSampleData() async {
    final String sampleData = ApiBase.baseUrl + ApiEndpoints.login;
    final response = _api.getApi(sampleData);
    return response;
  }
}
