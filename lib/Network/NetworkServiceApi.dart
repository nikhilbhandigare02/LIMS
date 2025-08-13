import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:food_inspector/Network/ApiServices.dart';
import 'package:food_inspector/Network/ApiExceptionHandler.dart';

class NetworkServiceApi extends ApiServices {
  @override
  Future<dynamic> getApi(String url, {Map<String, String>? headers}) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 10));
      return handleResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on TimeoutException {
      throw TimeoutError();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> postApi(String url, dynamic data, {Map<String, String>? headers}) async {
    try {
      final requestHeaders = {
        'Content-Type': 'application/json',
        if (headers != null) ...headers,
      };

      final response = await http
          .post(
        Uri.parse(url),
        headers: requestHeaders,
        body: jsonEncode(data),
      )
          .timeout(const Duration(seconds: 10));

      print('HTTP Status: ${response.statusCode}');
      print('Response body: ${response.body}');

      return handleResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on TimeoutException {
      throw TimeoutError();
    } catch (e) {
      rethrow;
    }
  }
}
