/// success : true
/// message : "Update available."
/// statusCode : 200
/// updateAvailable : 1
/// appUpdates : [{"appId":1,"versionName":"1.2.0","versionCode":12,"updateTitle":"New Features Update","updateDescription":"Bug fixes and performance improvements","isMandatory":true,"platform":"android","downloadUrl":"https://example.com/app.apk","success":true,"statusCode":200,"message":"Update available.","updateAvailable":1}]

class UpdateAppModel {
  UpdateAppModel({
      bool? success, 
      String? message, 
      num? statusCode, 
      num? updateAvailable, 
      List<AppUpdates>? appUpdates,}){
    _success = success;
    _message = message;
    _statusCode = statusCode;
    _updateAvailable = updateAvailable;
    _appUpdates = appUpdates;
}

  UpdateAppModel.fromJson(dynamic json) {
    final Map<String, dynamic> j = json as Map<String, dynamic>;
    _success = (j['success'] ?? j['Success']) as bool?;
    _message = (j['message'] ?? j['Message']) as String?;
    _statusCode = _asNum(j['statusCode'] ?? j['StatusCode']);
    _updateAvailable = _asNum(j['updateAvailable'] ?? j['UpdateAvailable'] ?? j['update_flag']);

    final dynamic listDyn = j['appUpdates'] ?? j['AppUpdates'] ?? j['updates'];
    if (listDyn != null && listDyn is List) {
      _appUpdates = [];
      for (final v in listDyn) {
        _appUpdates!.add(AppUpdates.fromJson(v));
      }
    }
  }
  bool? _success;
  String? _message;
  num? _statusCode;
  num? _updateAvailable;
  List<AppUpdates>? _appUpdates;
UpdateAppModel copyWith({  bool? success,
  String? message,
  num? statusCode,
  num? updateAvailable,
  List<AppUpdates>? appUpdates,
}) => UpdateAppModel(  success: success ?? _success,
  message: message ?? _message,
  statusCode: statusCode ?? _statusCode,
  updateAvailable: updateAvailable ?? _updateAvailable,
  appUpdates: appUpdates ?? _appUpdates,
);
  bool? get success => _success;
  String? get message => _message;
  num? get statusCode => _statusCode;
  num? get updateAvailable => _updateAvailable;
  List<AppUpdates>? get appUpdates => _appUpdates;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    map['statusCode'] = _statusCode;
    map['updateAvailable'] = _updateAvailable;
    if (_appUpdates != null) {
      map['appUpdates'] = _appUpdates?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  static num? _asNum(dynamic v) {
    if (v == null) return null;
    if (v is num) return v;
    if (v is String) {
      final n = num.tryParse(v);
      return n;
    }
    return null;
  }

}

/// appId : 1
/// versionName : "1.2.0"
/// versionCode : 12
/// updateTitle : "New Features Update"
/// updateDescription : "Bug fixes and performance improvements"
/// isMandatory : true
/// platform : "android"
/// downloadUrl : "https://example.com/app.apk"
/// success : true
/// statusCode : 200
/// message : "Update available."
/// updateAvailable : 1

class AppUpdates {
  AppUpdates({
      num? appId, 
      String? versionName, 
      num? versionCode, 
      String? updateTitle, 
      String? updateDescription, 
      bool? isMandatory, 
      String? platform, 
      String? downloadUrl, 
      bool? success, 
      num? statusCode, 
      String? message, 
      num? updateAvailable,}){
    _appId = appId;
    _versionName = versionName;
    _versionCode = versionCode;
    _updateTitle = updateTitle;
    _updateDescription = updateDescription;
    _isMandatory = isMandatory;
    _platform = platform;
    _downloadUrl = downloadUrl;
    _success = success;
    _statusCode = statusCode;
    _message = message;
    _updateAvailable = updateAvailable;
}

  AppUpdates.fromJson(dynamic json) {
    final Map<String, dynamic> j = json as Map<String, dynamic>;
    _appId = UpdateAppModel._asNum(j['appId'] ?? j['AppId']);
    _versionName = (j['versionName'] ?? j['VersionName']) as String?;
    _versionCode = UpdateAppModel._asNum(j['versionCode'] ?? j['VersionCode']);
    _updateTitle = (j['updateTitle'] ?? j['UpdateTitle']) as String?;
    _updateDescription = (j['updateDescription'] ?? j['UpdateDescription']) as String?;
    _isMandatory = (j['isMandatory'] ?? j['IsMandatory']) as bool?;
    _platform = (j['platform'] ?? j['Platform']) as String?;
    _downloadUrl = (j['downloadUrl'] ?? j['DownloadUrl']) as String?;
    _success = (j['success'] ?? j['Success']) as bool?;
    _statusCode = UpdateAppModel._asNum(j['statusCode'] ?? j['StatusCode']);
    _message = (j['message'] ?? j['Message']) as String?;
    _updateAvailable = UpdateAppModel._asNum(j['updateAvailable'] ?? j['UpdateAvailable']);
  }
  num? _appId;
  String? _versionName;
  num? _versionCode;
  String? _updateTitle;
  String? _updateDescription;
  bool? _isMandatory;
  String? _platform;
  String? _downloadUrl;
  bool? _success;
  num? _statusCode;
  String? _message;
  num? _updateAvailable;
AppUpdates copyWith({  num? appId,
  String? versionName,
  num? versionCode,
  String? updateTitle,
  String? updateDescription,
  bool? isMandatory,
  String? platform,
  String? downloadUrl,
  bool? success,
  num? statusCode,
  String? message,
  num? updateAvailable,
}) => AppUpdates(  appId: appId ?? _appId,
  versionName: versionName ?? _versionName,
  versionCode: versionCode ?? _versionCode,
  updateTitle: updateTitle ?? _updateTitle,
  updateDescription: updateDescription ?? _updateDescription,
  isMandatory: isMandatory ?? _isMandatory,
  platform: platform ?? _platform,
  downloadUrl: downloadUrl ?? _downloadUrl,
  success: success ?? _success,
  statusCode: statusCode ?? _statusCode,
  message: message ?? _message,
  updateAvailable: updateAvailable ?? _updateAvailable,
);
  num? get appId => _appId;
  String? get versionName => _versionName;
  num? get versionCode => _versionCode;
  String? get updateTitle => _updateTitle;
  String? get updateDescription => _updateDescription;
  bool? get isMandatory => _isMandatory;
  String? get platform => _platform;
  String? get downloadUrl => _downloadUrl;
  bool? get success => _success;
  num? get statusCode => _statusCode;
  String? get message => _message;
  num? get updateAvailable => _updateAvailable;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['appId'] = _appId;
    map['versionName'] = _versionName;
    map['versionCode'] = _versionCode;
    map['updateTitle'] = _updateTitle;
    map['updateDescription'] = _updateDescription;
    map['isMandatory'] = _isMandatory;
    map['platform'] = _platform;
    map['downloadUrl'] = _downloadUrl;
    map['success'] = _success;
    map['statusCode'] = _statusCode;
    map['message'] = _message;
    map['updateAvailable'] = _updateAvailable;
    return map;
  }

}