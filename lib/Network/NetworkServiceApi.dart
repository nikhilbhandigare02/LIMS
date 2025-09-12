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
          .timeout(const Duration(seconds: 25));

      print('HTTP GET: $url');
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

  @override
  Future<dynamic> postApi(String url, dynamic data, {Map<String, String>? headers}) async {
    try {
      final requestHeaders = {
        'Content-Type': 'application/json',
        if (headers != null) ...headers,
      };

      print('HTTP POST: $url');
      print('Request Headers: $requestHeaders');
      print('Request Body (unencrypted): ${jsonEncode(data)}');

      final response = await http
          .post(
        Uri.parse(url),
        headers: requestHeaders,
        body: jsonEncode(data),
      )
          .timeout(const Duration(seconds: 25));

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

  // Multipart/form-data POST for file uploads
  Future<dynamic> postMultipart(
    String url, {
    Map<String, String>? fields,
    required List<http.MultipartFile> files,
    Map<String, String>? headers,
  }) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      if (headers != null && headers.isNotEmpty) {
        request.headers.addAll(headers);
      }
      if (fields != null && fields.isNotEmpty) {
        request.fields.addAll(fields);
      }
      for (final f in files) {
        request.files.add(f);
      }

      print('HTTP MULTIPART POST: $url');
      print('Multipart fields: ${request.fields}');
      print('Multipart files: ${request.files.map((f) => '${f.field} -> ${f.filename} (${f.length})').toList()}');

      final streamed = await request.send().timeout(const Duration(seconds: 60));
      final response = await http.Response.fromStream(streamed);
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
