// ==== registration_event.dart ====
part of 'registrationBloc.dart';
abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object?> get props => [];
}

class NameChanged extends RegistrationEvent {
  final String name;
  const NameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

class EmailChanged extends RegistrationEvent {
  final String email;
  const EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}
class UsernameChanged extends RegistrationEvent {
  final String username;
  const UsernameChanged(this.username);

  @override
  List<Object?> get props => [username];
}
class PasswordChanged extends RegistrationEvent {
  final String password;
  const PasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class TogglePasswordVisibility extends RegistrationEvent {}

class CountryChanged extends RegistrationEvent {
  final String country;
  const CountryChanged(this.country);

  @override
  List<Object?> get props => [country];
}

class StateChanged extends RegistrationEvent {
  final String state;
  const StateChanged(this.state);

  @override
  List<Object?> get props => [state];
}

class DistrictNameChanged extends RegistrationEvent {
  final String district;
  const DistrictNameChanged(this.district);

  @override
  List<Object?> get props => [district];
}


class FormSubmitted extends RegistrationEvent {}
