import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AppException implements Exception {
  final String message;
  final String? prefix;

  AppException(this.message, [this.prefix]);

  @override
  String toString() {
    return "$prefix$message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String message = "Error During Communication"])
      : super(message, "Fetch Data Error: ");
}

class BadRequestException extends AppException {
  BadRequestException([String message = "Invalid Request"])
      : super(message, "Bad Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([String message = "Unauthorised"])
      : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String message = "Invalid Input"])
      : super(message, "Invalid Input: ");
}

class TimeoutError extends AppException {
  TimeoutError([String message = "Request Timed Out"])
      : super(message, "Timeout Error: ");
}

class NoInternetException extends AppException {
  NoInternetException([String message = "No Internet Connection"])
      : super(message, "Connection Error: ");
}

dynamic handleResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      return jsonDecode(response.body);
    case 400:
      throw BadRequestException(response.body);
    case 401:
    case 403:
      throw UnauthorisedException(response.body);
    case 422:
      throw InvalidInputException(response.body);
    case 500:
    default:
      throw FetchDataException("Server Error with status code: ${response.statusCode}");
  }
}
