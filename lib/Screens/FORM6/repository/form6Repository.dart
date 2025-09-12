import 'package:food_inspector/Network/NetworkServiceApi.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

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
    
    // Debug: Print what we're sending to the API
    print('FormSixApi - URL: $formSixUrl');
    print('FormSixApi - Data type: ${data.runtimeType}');
    print('FormSixApi - Data keys: ${data is Map ? data.keys : 'Not a Map'}');
    print('FormSixApi - Data: $data');
    print('FormSixApi - Headers: $headers');
    
    // Additional debugging for the payload structure
    if (data is Map) {
      final mapData = data as Map;
      print('FormSixApi - Map size: ${mapData.length}');
      for (final key in mapData.keys) {
        print('FormSixApi - Key: $key, Value type: ${mapData[key].runtimeType}, Value length: ${mapData[key] is String ? (mapData[key] as String).length : 'N/A'}');
      }
    }
    
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
    final url = ApiBase.baseUrl + ApiEndpoints.sealNumberdropdown;
    final headers = token != null && token.isNotEmpty ? {'Authorization': 'Bearer $token'} : null;
    final response = await _api.postApi(url, data, headers: headers);
    return response;
  }

  Future<dynamic> uploadFormVIDocument({
    required String serialNo,
    required String fileName,
    required List<int> fileBytes,
  }) async {
    final url = ApiBase.baseUrl + ApiEndpoints.uploadFormVIDocument;
    print('UploadFormVIDocument (multipart) - URL: $url');
    print('UploadFormVIDocument (multipart) - serialNo: $serialNo, fileName: $fileName, bytes: ${fileBytes.length}');

    final fields = {
      'serialNo': serialNo,
    };

    final file = http.MultipartFile.fromBytes(
      'file',
      fileBytes,
      filename: fileName,
    );

    // No auth, no encryption headers
    final response = await _api.postMultipart(
      url,
      fields: fields,
      files: [file],
      headers: null,
    );
    return response;
  }
}
