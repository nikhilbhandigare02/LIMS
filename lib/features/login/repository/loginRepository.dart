import 'package:food_inspector/Network/NetworkServiceApi.dart';
import 'package:food_inspector/common/ApiUrl.dart';
import 'package:food_inspector/features/login/model/UserModel.dart';

class LoginRepository {
  final _api = NetworkServiceApi();
  Future<UserModel> loginApi(dynamic data) async {
    final response = await _api.postApi(Apiurl.loginUrl, data);
    return UserModel.fromJson(response);
  }
}
