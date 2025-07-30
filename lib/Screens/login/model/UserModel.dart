/// userId : 2090
/// username : "shubhada"
/// roleId : 13
/// userType : ""
/// roleDescription : ""
/// isPassReset : false
/// result : "success"
/// remark : "User logged in successfully."

class UserModel {
  UserModel({
      num? userId, 
      String? username, 
      num? roleId, 
      String? userType, 
      String? roleDescription, 
      bool? isPassReset, 
      String? result, 
      String? remark,}){
    _userId = userId;
    _username = username;
    _roleId = roleId;
    _userType = userType;
    _roleDescription = roleDescription;
    _isPassReset = isPassReset;
    _result = result;
    _remark = remark;
}

  UserModel.fromJson(dynamic json) {
    _userId = json['userId'];
    _username = json['username'];
    _roleId = json['roleId'];
    _userType = json['userType'];
    _roleDescription = json['roleDescription'];
    _isPassReset = json['isPassReset'];
    _result = json['result'];
    _remark = json['remark'];
  }
  num? _userId;
  String? _username;
  num? _roleId;
  String? _userType;
  String? _roleDescription;
  bool? _isPassReset;
  String? _result;
  String? _remark;
UserModel copyWith({  num? userId,
  String? username,
  num? roleId,
  String? userType,
  String? roleDescription,
  bool? isPassReset,
  String? result,
  String? remark,
}) => UserModel(  userId: userId ?? _userId,
  username: username ?? _username,
  roleId: roleId ?? _roleId,
  userType: userType ?? _userType,
  roleDescription: roleDescription ?? _roleDescription,
  isPassReset: isPassReset ?? _isPassReset,
  result: result ?? _result,
  remark: remark ?? _remark,
);
  num? get userId => _userId;
  String? get username => _username;
  num? get roleId => _roleId;
  String? get userType => _userType;
  String? get roleDescription => _roleDescription;
  bool? get isPassReset => _isPassReset;
  String? get result => _result;
  String? get remark => _remark;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = _userId;
    map['username'] = _username;
    map['roleId'] = _roleId;
    map['userType'] = _userType;
    map['roleDescription'] = _roleDescription;
    map['isPassReset'] = _isPassReset;
    map['result'] = _result;
    map['remark'] = _remark;
    return map;
  }

}