part of 'sampleBloc.dart';

class getSampleListState extends Equatable{
  const getSampleListState({
required this.fetchSampleList
});
final ApiResponse<dynamic> fetchSampleList;

getSampleListState copyWith({
  final ApiResponse<dynamic>? fetchSampleList,
}){
return getSampleListState(fetchSampleList: fetchSampleList ?? this.fetchSampleList);
}
  @override
  // TODO: implement props
  List<Object?> get props => [fetchSampleList];

}