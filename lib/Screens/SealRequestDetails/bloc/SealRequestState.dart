part of 'SealRequestBloc.dart';

class SealRequestState extends Equatable{
  const SealRequestState({
    required this.fetchRequestData,
    required this.count,
    this.apiStatus = ApiStatus.initial,
    this.message = '',
});
  final ApiResponse<dynamic> fetchRequestData;
  final int count;
  final ApiStatus apiStatus;
  final String message;
  SealRequestState copyWith({
    final ApiResponse<dynamic>? fetchRequestData,
    final int? count,
    final ApiStatus? apiStatus,
    final String?message,

  }){
    return SealRequestState(fetchRequestData: fetchRequestData ?? this.fetchRequestData, count:count?? this.count,  apiStatus: apiStatus ?? this.apiStatus,
      message: message ?? this.message,);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [fetchRequestData, count, apiStatus, message];

}


