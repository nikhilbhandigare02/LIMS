part of 'loginBloc.dart';

class LoginState extends Equatable{
  const LoginState({
    this.username = '', this.password = '',this.message = '', this.apiStatus = ApiStatus.initial
});
  final String username;
  final String password;
  final String message;
  final ApiStatus apiStatus;

  LoginState copyWith({
    final String? username,
    final String? password,
    final String? message,
    final ApiStatus? apiStatus
}) {
    return LoginState(
username: username ??this.username,
      password: password ?? this.password,
      message: message ?? this.message,
      apiStatus: apiStatus ?? this.apiStatus
    );
  }
  @override
  List<Object?> get props => [password, username, message, apiStatus];

}