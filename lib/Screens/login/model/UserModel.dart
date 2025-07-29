class UserModel {
  final String? token;
  final String? error;
  final String? errorDescription;

  UserModel({
    this.token,
    this.error,
    this.errorDescription,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'],
      error: json['error'],
      errorDescription: json['error_description'] ?? json['errorDescription'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'error': error,
      'error_description': errorDescription,
    };
  }
}
