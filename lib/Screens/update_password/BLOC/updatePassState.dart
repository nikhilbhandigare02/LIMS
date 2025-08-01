part of 'UpdatePassBloc.dart';

class UpdatePasswordState extends Equatable{
  const UpdatePasswordState({
     this.currentPassword = '',this.newPassword = '',this.confirmPassword = '',
    this.message = '', this.apiStatus = ApiStatus.initial
  });
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  final String message;
  final ApiStatus apiStatus;

  UpdatePasswordState copyWith({
    final String? currentPassword,
    final String? newPassword,
    final String? confirmPassword,
    final String? message,
    final ApiStatus? apiStatus
  }) {
    return UpdatePasswordState(
        currentPassword: currentPassword ?? this.currentPassword,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        newPassword: newPassword ?? this.newPassword,
        message: message ?? this.message,
        apiStatus: apiStatus ?? this.apiStatus
    );
  }
  @override
  List<Object?> get props => [currentPassword, message, apiStatus, newPassword, confirmPassword];

}