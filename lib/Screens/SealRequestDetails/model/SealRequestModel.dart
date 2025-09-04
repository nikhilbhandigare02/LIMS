/// success : true
/// statusCode : 200
/// message : "Seal request data fetched successfully."
/// data : [{"seal_Number":"SN-001","count":5,"status":"Request for a seal number","seal_request_date":"9/3/2025 12:00:00 AM","seal_send_date":null},{"seal_Number":"SN-001","count":2,"status":"Request for a seal number","seal_request_date":"9/3/2025 12:00:00 AM","seal_send_date":null},{"seal_Number":"SN-002","count":5,"status":"Request for a seal number","seal_request_date":"9/3/2025 12:00:00 AM","seal_send_date":null},{"seal_Number":"SN-002","count":2,"status":"Request for a seal number","seal_request_date":"9/3/2025 12:00:00 AM","seal_send_date":null}]

class SealRequestModel {
  SealRequestModel({
      bool? success, 
      num? statusCode, 
      String? message, 
      List<Data>? data,}){
    _success = success;
    _statusCode = statusCode;
    _message = message;
    _data = data;
}

  SealRequestModel.fromJson(dynamic json) {
    _success = json['success'];
    _statusCode = json['statusCode'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  bool? _success;
  num? _statusCode;
  String? _message;
  List<Data>? _data;
SealRequestModel copyWith({  bool? success,
  num? statusCode,
  String? message,
  List<Data>? data,
}) => SealRequestModel(  success: success ?? _success,
  statusCode: statusCode ?? _statusCode,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get success => _success;
  num? get statusCode => _statusCode;
  String? get message => _message;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['statusCode'] = _statusCode;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// seal_Number : "SN-001"
/// count : 5
/// status : "Request for a seal number"
/// seal_request_date : "9/3/2025 12:00:00 AM"
/// seal_send_date : null

class Data {
  Data({
      String? sealNumber, 
      num? count, 
      String? status, 
      String? sealRequestDate, 
      dynamic sealSendDate,}){
    _sealNumber = sealNumber;
    _count = count;
    _status = status;
    _sealRequestDate = sealRequestDate;
    _sealSendDate = sealSendDate;
}

  Data.fromJson(dynamic json) {
    _sealNumber = json['seal_Number'];
    _count = json['count'];
    _status = json['status'];
    _sealRequestDate = json['seal_request_date'];
    _sealSendDate = json['seal_send_date'];
  }
  String? _sealNumber;
  num? _count;
  String? _status;
  String? _sealRequestDate;
  dynamic _sealSendDate;
Data copyWith({  String? sealNumber,
  num? count,
  String? status,
  String? sealRequestDate,
  dynamic sealSendDate,
}) => Data(  sealNumber: sealNumber ?? _sealNumber,
  count: count ?? _count,
  status: status ?? _status,
  sealRequestDate: sealRequestDate ?? _sealRequestDate,
  sealSendDate: sealSendDate ?? _sealSendDate,
);
  String? get sealNumber => _sealNumber;
  num? get count => _count;
  String? get status => _status;
  String? get sealRequestDate => _sealRequestDate;
  dynamic get sealSendDate => _sealSendDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['seal_Number'] = _sealNumber;
    map['count'] = _count;
    map['status'] = _status;
    map['seal_request_date'] = _sealRequestDate;
    map['seal_send_date'] = _sealSendDate;
    return map;
  }

}