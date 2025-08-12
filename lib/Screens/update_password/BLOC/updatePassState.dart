part of 'UpdatePassBloc.dart';

class UpdatePasswordState extends Equatable{
  const UpdatePasswordState({
     this.NewPassword = '',this.Username = '',this.confirmPassword = '',
    this.message = '', this.apiStatus = ApiStatus.initial
  });
  final String NewPassword;
  final String Username;
  final String confirmPassword;
  final String message;
  final ApiStatus apiStatus;

  UpdatePasswordState copyWith({
    final String? NewPassword,
    final String? Username,
    final String? confirmPassword,
    final String? message,
    final ApiStatus? apiStatus
  }) {
    return UpdatePasswordState(
        NewPassword: NewPassword ?? this.NewPassword,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        Username: Username ?? this.Username,
        message: message ?? this.message,
        apiStatus: apiStatus ?? this.apiStatus
    );
  }
  @override
  List<Object?> get props => [NewPassword, message, apiStatus, Username, confirmPassword];

}