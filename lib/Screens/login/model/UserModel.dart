/// userId : 11
/// username : "fsolims"
/// fullName : "Aditya FSO"
/// email : "dalviaditya711@gmail.com"
/// roleId : 24
/// token : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJmc29saW1zIiwidXNlcl9pZCI6IjExIiwianRpIjoiZmVjNWY0MjUtY2JlYy00ZGQ0LTg4ZDYtY2Q2YzZlMGNmZDg4IiwiZXhwIjoxNzU0OTM1MzYyfQ.z96-39iEq0ssJiQ7jwJbXk_8gyykR-_DjH1dZ8nrBho"
/// passResetFlag : "0"
/// success : true
/// statusCode : 200
/// message : "Login Successful"

class UserModel {
  UserModel({
      num? userId, 
      String? username, 
      String? fullName, 
      String? email, 
      num? roleId, 
      String? token, 
      String? passResetFlag, 
      bool? success, 
      num? statusCode, 
      String? message,}){
    _userId = userId;
    _username = username;
    _fullName = fullName;
    _email = email;
    _roleId = roleId;
    _token = token;
    _passResetFlag = passResetFlag;
    _success = success;
    _statusCode = statusCode;
    _message = message;
}

  UserModel.fromJson(dynamic json) {
    _userId = json['userId'];
    _username = json['username'];
    _fullName = json['fullName'];
    _email = json['email'];
    _roleId = json['roleId'];
    _token = json['token'];
    _passResetFlag = json['passResetFlag'];
    _success = json['success'];
    _statusCode = json['statusCode'];
    _message = json['message'];
  }
  num? _userId;
  String? _username;
  String? _fullName;
  String? _email;
  num? _roleId;
  String? _token;
  String? _passResetFlag;
  bool? _success;
  num? _statusCode;
  String? _message;
UserModel copyWith({  num? userId,
  String? username,
  String? fullName,
  String? email,
  num? roleId,
  String? token,
  String? passResetFlag,
  bool? success,
  num? statusCode,
  String? message,
}) => UserModel(  userId: userId ?? _userId,
  username: username ?? _username,
  fullName: fullName ?? _fullName,
  email: email ?? _email,
  roleId: roleId ?? _roleId,
  token: token ?? _token,
  passResetFlag: passResetFlag ?? _passResetFlag,
  success: success ?? _success,
  statusCode: statusCode ?? _statusCode,
  message: message ?? _message,
);
  num? get userId => _userId;
  String? get username => _username;
  String? get fullName => _fullName;
  String? get email => _email;
  num? get roleId => _roleId;
  String? get token => _token;
  String? get passResetFlag => _passResetFlag;
  bool? get success => _success;
  num? get statusCode => _statusCode;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = _userId;
    map['username'] = _username;
    map['fullName'] = _fullName;
    map['email'] = _email;
    map['roleId'] = _roleId;
    map['token'] = _token;
    map['passResetFlag'] = _passResetFlag;
    map['success'] = _success;
    map['statusCode'] = _statusCode;
    map['message'] = _message;
    return map;
  }

}