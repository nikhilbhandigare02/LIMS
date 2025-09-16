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
    _success = json['success'] ?? json['Success'];
    _statusCode = json['statusCode'] ?? json['StatusCode'];
    _message = json['message'] ?? json['Message'];
    final dynamic dataNode = json['data'] ?? json['Data'];
    if (dataNode != null) {
      _data = [];
      dataNode.forEach((v) {
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
      String? slipNumber,
      num? requestId,
      num? count,
      num? status_ID,
      String? status,
      String? slipRequestDate,
      dynamic slipSendDate,}){
    _slipNumber = slipNumber;
    _requestId = requestId;
    _count = count;
    _status_ID = status_ID;
    _status = status;
    _slipRequestDate = slipRequestDate;
    _slipSendDate = slipSendDate;
}

  Data.fromJson(dynamic json) {
    _slipNumber = json['Slip_Number'] ?? json['slip_Number'];
    _requestId = json['request_id'] ?? json['Request_id'] ?? json['requestId'] ?? json['RequestId'];
    _count = json['count'] ?? json['Count'];
    _status_ID = json['status_ID'] ?? json['Status_ID'];
    _status = json['status'] ?? json['Status'];
    _slipRequestDate = json['slip_request_date'] ?? json['Slip_request_date'] ?? json['slipRequestDate'];
    _slipSendDate = json['slip_send_date'] ?? json['Slip_send_date'] ?? json['slipSendDate'];
  }
  String? _slipNumber;
  num? _requestId;
  num? _count;
  num? _status_ID;
  String? _status;
  String? _slipRequestDate;
  dynamic _slipSendDate;
Data copyWith({  String? slipNumber,
  num? requestId,
  num? count,
  num? status_ID,
  String? status,
  String? sealRequestDate,
  dynamic sealSendDate,
}) => Data(  slipNumber: slipNumber ?? _slipNumber,
  requestId: requestId ?? _requestId,
  count: count ?? _count,
  status_ID: status_ID ?? _status_ID,
  status: status ?? _status,
  slipRequestDate: sealRequestDate ?? _slipRequestDate,
  slipSendDate: sealSendDate ?? _slipSendDate,
);
  String? get slipNumber => _slipNumber;
  num? get requestId => _requestId;
  num? get count => _count;
  num? get status_ID => _status_ID;
  String? get status => _status;
  String? get slipRequestDate => _slipRequestDate;
  dynamic get slipSendDate => _slipSendDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['slip_Number'] = _slipNumber;
    map['request_id'] = _requestId;
    map['count'] = _count;
    map['status_ID'] = _status_ID;
    map['status'] = _status;
    map['slip_request_date'] = _slipRequestDate;
    map['slip_send_date'] = _slipSendDate;
    return map;
  }

}