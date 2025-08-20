part of 'sampleBloc.dart';

class getSampleListState extends Equatable{
  const getSampleListState({
required this.fetchSampleList, required this.getFormData,
});
final ApiResponse<dynamic> fetchSampleList;
final ApiResponse<dynamic> getFormData;

getSampleListState copyWith({
  final ApiResponse<dynamic>? fetchSampleList,
  final ApiResponse<dynamic>? getFormData,
}){
return getSampleListState(fetchSampleList: fetchSampleList ?? this.fetchSampleList, getFormData: getFormData ?? this.getFormData);
}
  @override
  // TODO: implement props
  List<Object?> get props => [fetchSampleList, getFormData];

}