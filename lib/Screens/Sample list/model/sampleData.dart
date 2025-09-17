/// sampleList : [{"serial_no":"S002","sample_sent_date":"2025-08-13T16:36:40+05:30","sample_resent_date":"2025-08-13T17:55:03+05:30","sample_re_requested_date":"2025-08-13T15:50:51+05:30","lab_location":"Mumbai","status_name":null,"userID":2},{"serial_no":"S003","sample_sent_date":"2025-08-13T16:41:29+05:30","sample_resent_date":"0001-01-01T00:00:00","sample_re_requested_date":"0001-01-01T00:00:00","lab_location":null,"status_name":null,"userID":2},{"serial_no":"S004","sample_sent_date":"2025-08-13T17:56:41+05:30","sample_resent_date":"0001-01-01T00:00:00","sample_re_requested_date":"0001-01-01T00:00:00","lab_location":"Pune","status_name":null,"userID":2}]
/// success : true
/// message : "Sample data fetched successfully."
/// statusCode : 200

class SampleData {
  SampleData({
      List<SampleList>? sampleList, 
      bool? success, 
      String? message, 
      num? statusCode,}){
    _sampleList = sampleList;
    _success = success;
    _message = message;
    _statusCode = statusCode;
}

  SampleData.fromJson(dynamic json) {
    if (json['sampleList'] != null) {
      _sampleList = [];
      json['sampleList'].forEach((v) {
        _sampleList?.add(SampleList.fromJson(v));
      });
    }
    _success = json['success'];
    _message = json['message'];
    _statusCode = json['statusCode'];
  }
  List<SampleList>? _sampleList;
  bool? _success;
  String? _message;
  num? _statusCode;
SampleData copyWith({  List<SampleList>? sampleList,
  bool? success,
  String? message,
  num? statusCode,
}) => SampleData(  sampleList: sampleList ?? _sampleList,
  success: success ?? _success,
  message: message ?? _message,
  statusCode: statusCode ?? _statusCode,
);
  List<SampleList>? get sampleList => _sampleList;
  bool? get success => _success;
  String? get message => _message;
  num? get statusCode => _statusCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_sampleList != null) {
      map['sampleList'] = _sampleList?.map((v) => v.toJson()).toList();
    }
    map['success'] = _success;
    map['message'] = _message;
    map['statusCode'] = _statusCode;
    return map;
  }

}

/// serial_no : "S002"
/// sample_sent_date : "2025-08-13T16:36:40+05:30"
/// sample_resent_date : "2025-08-13T17:55:03+05:30"
/// sample_re_requested_date : "2025-08-13T15:50:51+05:30"
/// lab_location : "Mumbai"
/// status_name : null
/// userID : 2

class SampleList {
  SampleList({
      String? serialNo,
      String? sampleSentDate,
      String? sampleResentDate,
      String? sampleReRequestedDate,
      String? labLocation,
      String? statusName,
      num? userID,}){
    _serialNo = serialNo;
    _sampleSentDate = sampleSentDate;
    _sampleResentDate = sampleResentDate;
    _sampleReRequestedDate = sampleReRequestedDate;
    _labLocation = labLocation;
    _statusName = statusName;
    _userID = userID;
}

  SampleList.fromJson(dynamic json) {
    // Handle multiple possible API key casings/aliases
    String? pickString(List<String> candidateKeys) {
      // direct fast path
      for (final key in candidateKeys) {
        final dynamic value = (json as Map<String, dynamic>)[key];
        if (value != null) return value.toString();
      }
      // case-insensitive/underscore-insensitive
      String normalize(String s) => s.replaceAll(RegExp(r'[\s_]'), '').toLowerCase();
      final Map<String, dynamic> normalizedMap = {};
      (json as Map<String, dynamic>).forEach((k, v) {
        normalizedMap[normalize(k.toString())] = v;
      });
      for (final key in candidateKeys) {
        final dynamic value = normalizedMap[normalize(key)];
        if (value != null) return value.toString();
      }
      return null;
    }

    _serialNo = pickString(['serial_no', 'serialNo', 'SerialNo', 'Serial_No']);
    _sampleSentDate = pickString(['sample_sent_date', 'sampleSentDate', 'SampleSentDate']);
    _sampleResentDate = pickString(['sample_resent_date', 'sampleResentDate', 'SampleResentDate']);
    _sampleReRequestedDate = pickString(['sample_re_requested_date', 'sampleReRequestedDate', 'SampleReRequestedDate']);
    _labLocation = pickString(['lab_location', 'labLocation', 'LabLocation']);
    _statusName = pickString([
      'status_name']);
    _userID = json['userID'] ?? json['UserID'] ?? json['userId'] ?? json['UserId'];
    if (_userID is String) {
      final parsed = num.tryParse(_userID as String);
      _userID = parsed ?? _userID;
    }
  }
  String? _serialNo;
  String? _sampleSentDate;
  String? _sampleResentDate;
  String? _sampleReRequestedDate;
  String? _labLocation;
  String? _statusName;
  num? _userID;
SampleList copyWith({  String? serialNo,
  String? sampleSentDate,
  String? sampleResentDate,
  String? sampleReRequestedDate,
  String? labLocation,
  String? statusName,
  num? userID,
}) => SampleList(  serialNo: serialNo ?? _serialNo,
  sampleSentDate: sampleSentDate ?? _sampleSentDate,
  sampleResentDate: sampleResentDate ?? _sampleResentDate,
  sampleReRequestedDate: sampleReRequestedDate ?? _sampleReRequestedDate,
  labLocation: labLocation ?? _labLocation,
  statusName: statusName ?? _statusName,
  userID: userID ?? _userID,
);
  String? get serialNo => _serialNo;
  String? get sampleSentDate => _sampleSentDate;
  String? get sampleResentDate => _sampleResentDate;
  String? get sampleReRequestedDate => _sampleReRequestedDate;
  String? get labLocation => _labLocation;
  String? get statusName => _statusName;
  num? get userID => _userID;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['serial_no'] = _serialNo;
    map['sample_sent_date'] = _sampleSentDate;
    map['sample_resent_date'] = _sampleResentDate;
    map['sample_re_requested_date'] = _sampleReRequestedDate;
    map['lab_location'] = _labLocation;
    map['status_name'] = _statusName;
    map['userID'] = _userID;
    return map;
  }

}