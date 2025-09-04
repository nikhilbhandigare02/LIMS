part of 'loginBloc.dart';
abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => [];
}

class UsernameEvent extends LoginEvent {
  final String username;
  UsernameEvent({required this.username});
  @override
  List<Object> get props => [];
}

class PasswordEvent extends LoginEvent {
  final String password;
  PasswordEvent({required this.password});
  @override
  List<Object> get props => [];
}


class LoginButtonEvent extends LoginEvent{}

class EmailFocusEvent extends LoginEvent{}
class PasswordFocusEvent extends LoginEvent{}

