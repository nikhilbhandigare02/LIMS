part of 'UpdatePassBloc.dart';

abstract class UpdatePasswordEvent extends Equatable {
const UpdatePasswordEvent();
  @override
  List<Object> get props => [];
}



class CurrentPasswordEvent extends UpdatePasswordEvent {
  final String currentPassword;
  CurrentPasswordEvent({required this.currentPassword});
  @override
  List<Object> get props => [currentPassword];
}
class NewPasswordEvent extends UpdatePasswordEvent {
  final String newPassword;
  NewPasswordEvent({required this.newPassword});
  @override
  List<Object> get props => [newPassword];
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

