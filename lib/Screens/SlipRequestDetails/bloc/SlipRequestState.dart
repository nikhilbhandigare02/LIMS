part of 'SlipRequestBloc.dart';

class SlipRequestState extends Equatable{
  const SlipRequestState({
    required this.fetchRequestData,
    required this.count,
    this.apiStatus = ApiStatus.initial,
    this.message = '',
});
  final ApiResponse<dynamic> fetchRequestData;
  final int count;
  final ApiStatus apiStatus;
  final String message;
  SlipRequestState copyWith({
    final ApiResponse<dynamic>? fetchRequestData,
    final int? count,
    final ApiStatus? apiStatus,
    final String?message,

  }){
    return SlipRequestState(fetchRequestData: fetchRequestData ?? this.fetchRequestData, count:count?? this.count,  apiStatus: apiStatus ?? this.apiStatus,
      message: message ?? this.message,);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [fetchRequestData, count, apiStatus, message];

}


