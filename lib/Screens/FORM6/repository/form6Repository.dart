import 'package:food_inspector/Network/NetworkServiceApi.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../common/APIs/APIEndpoint.dart';
import '../../../common/APIs/BaseUrl.dart';
import '../../login/model/UserModel.dart';

class Form6Repository {
  final _api = NetworkServiceApi();

  Future<dynamic> FormSixApi(dynamic data) async {
    const storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'authToken');
    final formSixUrl = ApiBase.baseUrl + ApiEndpoints.insertSample;
    final headers = token != null && token.isNotEmpty ? {'Authorization': 'Bearer $token'} : null;
    final response = await _api.postApi(formSixUrl, data, headers: headers);
    return response;
  }

  Future<dynamic> getDistrictsByStateId(dynamic data) async {
    const storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'authToken');
    final url = ApiBase.baseUrl + ApiEndpoints.getDistrictsByStateId;
    final headers = token != null && token.isNotEmpty ? {'Authorization': 'Bearer $token'} : null;
    final response = await _api.postApi(url, data, headers: headers);
    return response;
  }

  Future<dynamic> getRegionsByDistrictId(dynamic data) async {
    const storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'authToken');
    final url = ApiBase.baseUrl + ApiEndpoints.getRegionsByDistrictId;
    final headers = token != null && token.isNotEmpty ? {'Authorization': 'Bearer $token'} : null;
    final response = await _api.postApi(url, data, headers: headers);
    return response;
  }

  Future<dynamic> getDivisionsByRegionId(dynamic data) async {
    const storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'authToken');
    final url = ApiBase.baseUrl + ApiEndpoints.getDivisionsByRegionId;
    final headers = token != null && token.isNotEmpty ? {'Authorization': 'Bearer $token'} : null;
    final response = await _api.postApi(url, data, headers: headers);
    return response;
  }

  Future<dynamic> getNatureOfSample(dynamic data) async {
    const storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'authToken');
    final url = ApiBase.baseUrl + ApiEndpoints.getNatureOfSample;
    final headers = token != null && token.isNotEmpty ? {'Authorization': 'Bearer $token'} : null;
    final response = await _api.postApi(url, data, headers: headers);
    return response;
  }

  Future<dynamic> getLabMaster(dynamic data) async {
    const storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'authToken');
    final url = ApiBase.baseUrl + ApiEndpoints.getLabMaster;
    final headers = token != null && token.isNotEmpty ? {'Authorization': 'Bearer $token'} : null;
    final response = await _api.postApi(url, data, headers: headers);
    return response;
  }

  Future<dynamic> getSealNumber(dynamic data) async {
    const storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'authToken');
    final url = ApiBase.baseUrl + ApiEndpoints.sealNumber;
    final headers = token != null && token.isNotEmpty ? {'Authorization': 'Bearer $token'} : null;
    final response = await _api.postApi(url, data, headers: headers);
    return response;
  }
}
