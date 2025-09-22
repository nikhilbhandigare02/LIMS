class SampleData {
  SampleData({
    List<SampleList>? sampleList,
    bool? success,
    String? message,
    num? statusCode,
  }) {
    _sampleList = sampleList;
    _success = success;
    _message = message;
    _statusCode = statusCode;
  }

  SampleData.fromJson(dynamic json) {
    // Note: API returns "SampleList" (capital S) not "sampleList"
    if (json['SampleList'] != null) {
      _sampleList = [];
      json['SampleList'].forEach((v) {
        _sampleList?.add(SampleList.fromJson(v));
      });
    }
    // Note: API returns "Success" (capital S) not "success"
    _success = json['Success'] ?? false;
    // Note: API returns "Message" (capital M) not "message"
    _message = json['Message'] ?? '';
    // Note: API returns "StatusCode" (capital S) not "statusCode"
    _statusCode = json['StatusCode'] ?? 0;
  }

  List<SampleList>? _sampleList;
  bool? _success;
  String? _message;
  num? _statusCode;

  SampleData copyWith({
    List<SampleList>? sampleList,
    bool? success,
    String? message,
    num? statusCode,
  }) =>
      SampleData(
        sampleList: sampleList ?? _sampleList,
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
      map['SampleList'] = _sampleList?.map((v) => v.toJson()).toList();
    }
    map['Success'] = _success;
    map['Message'] = _message;
    map['StatusCode'] = _statusCode;
    return map;
  }
}

class SampleList {
  SampleList({
    String? serialNo,
    String? sampleSentDate,
    String? sampleResentDate,
    String? sampleReRequestedDate,
    String? labLocation,
    String? statusName,
    num? userID,
  }) {
    _serialNo = serialNo;
    _sampleSentDate = sampleSentDate;
    _sampleResentDate = sampleResentDate;
    _sampleReRequestedDate = sampleReRequestedDate;
    _labLocation = labLocation;
    _statusName = statusName;
    _userID = userID;
  }

  SampleList.fromJson(dynamic json) {
    String? pickString(List<String> candidateKeys) {
      for (final key in candidateKeys) {
        final dynamic value = (json as Map<String, dynamic>)[key];
        if (value != null && value.toString().isNotEmpty) {
          return value.toString();
        }
      }
      return null;
    }

    String? parseDate(String? date) {
      if (date == null ||
          date.isEmpty ||
          date == 'null' ||
          date.toLowerCase() == 'null' ||
          date.startsWith('0001-01-01')) {
        return null;
      }
      return date;
    }

    _serialNo = pickString(['serial_no', 'serialNo', 'SerialNo', 'Serial_No']);

    // Direct mapping since API returns exact keys
    _sampleSentDate = parseDate(json['sample_sent_date']?.toString());
    _sampleResentDate = parseDate(json['sample_resent_date']?.toString());
    _sampleReRequestedDate = parseDate(json['sample_re_requested_date']?.toString());

    _labLocation = pickString(['lab_location', 'labLocation', 'LabLocation']);
    _statusName = pickString(['status_name', 'statusName']);

    final dynamic userValue = json['UserID'] ?? json['userID'] ?? json['userId'] ?? json['UserId'];
    if (userValue is num) {
      _userID = userValue;
    } else if (userValue is String) {
      _userID = num.tryParse(userValue) ?? 0;
    } else {
      _userID = 0;
    }
  }

  String? _serialNo;
  String? _sampleSentDate;
  String? _sampleResentDate;
  String? _sampleReRequestedDate;
  String? _labLocation;
  String? _statusName;
  num? _userID;

  SampleList copyWith({
    String? serialNo,
    String? sampleSentDate,
    String? sampleResentDate,
    String? sampleReRequestedDate,
    String? labLocation,
    String? statusName,
    num? userID,
  }) =>
      SampleList(
        serialNo: serialNo ?? _serialNo,
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

  Map<String, dynamic> toJson() => {
    'serial_no': _serialNo,
    'sample_sent_date': _sampleSentDate,
    'sample_resent_date': _sampleResentDate,
    'sample_re_requested_date': _sampleReRequestedDate,
    'lab_location': _labLocation,
    'status_name': _statusName,
    'UserID': _userID,
  };
}