part of "request_bloc.dart";

class RequestSealState extends Equatable{

  const RequestSealState({
    this.selectedDate,
    this.apiStatus = ApiStatus.initial,
    this.message = '',
}) ;
  final DateTime? selectedDate;
  final ApiStatus apiStatus;
  final String message;


  RequestSealState copyWith(
  {
  final DateTime? selectedDate,
  final ApiStatus? apiStatus,
  final String?message,
  }) {
    return RequestSealState(
      selectedDate: selectedDate ?? this.selectedDate,
      apiStatus: apiStatus ?? this.apiStatus,
      message: message ?? this.message,
    );
  }
  @override
  List<Object?> get props => [selectedDate, apiStatus, message];

}