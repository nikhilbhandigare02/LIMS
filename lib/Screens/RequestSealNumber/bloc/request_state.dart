part of "request_bloc.dart";

class RequestSealState extends Equatable{

  const RequestSealState({
    this.selectedDate,
    this.sealNumber = '',
    this.sealNumberCount = '',
    this.apiStatus = ApiStatus.initial,
    this.message = '',
}) ;
  final DateTime? selectedDate;
  final String sealNumber;
  final String sealNumberCount;
  final ApiStatus apiStatus;
  final String message;


  RequestSealState copyWith(
  {
  final DateTime? selectedDate,
  final ApiStatus? apiStatus,
  final String?message,
  final String? sealNumber,
  final String? sealNumberCount,
  }) {
    return RequestSealState(
      selectedDate: selectedDate ?? this.selectedDate,
      apiStatus: apiStatus ?? this.apiStatus,
      message: message ?? this.message,
      sealNumber: sealNumber ?? this.sealNumber,
      sealNumberCount: sealNumberCount ?? this.sealNumberCount,
    );
  }
  @override
  List<Object?> get props => [selectedDate, apiStatus, message, sealNumber, sealNumberCount];

}