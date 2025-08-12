part of 'UpdatePassBloc.dart';

abstract class UpdatePasswordEvent extends Equatable {
const UpdatePasswordEvent();
  @override
  List<Object> get props => [];
}



class updateUsernameEvent extends UpdatePasswordEvent {
  final String username;
  updateUsernameEvent({required this.username});
  @override
  List<Object> get props => [username];
}
class NewPasswordEvent extends UpdatePasswordEvent {
  final String NewPassword;
  NewPasswordEvent({required this.NewPassword});
  @override
  List<Object> get props => [NewPassword];
}
class ConformPasswordEvent extends UpdatePasswordEvent {
  final String confirmPassword;
  ConformPasswordEvent({required this.confirmPassword});
  @override
  List<Object> get props => [confirmPassword];
}

class UpdatePassButtonEvent extends UpdatePasswordEvent{}

class currentPasswordFocusEvent extends UpdatePasswordEvent{}
class newPasswordFocusEvent extends UpdatePasswordEvent{}
class confirmPasswordFocusEvent extends UpdatePasswordEvent{}

