part of 'SealRequestBloc.dart';

class SealRequestState extends Equatable{
  const SealRequestState({
    required this.fetchRequestData
});
  final ApiResponse<dynamic> fetchRequestData;

  SealRequestState copyWith({
    final ApiResponse<dynamic>? fetchRequestData,

  }){
    return SealRequestState(fetchRequestData: fetchRequestData ?? this.fetchRequestData);
  }
  @override
  // TODO: implement props
  List<Object?> get props => [fetchRequestData];

}