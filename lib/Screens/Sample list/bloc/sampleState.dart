part of 'sampleBloc.dart';

class getSampleListState extends Equatable{
  const getSampleListState({
required this.fetchSampleList
});
final ApiResponse<UserModel> fetchSampleList;

getSampleListState copyWith({
  final ApiResponse<UserModel>? fetchSampleList,
}){
return getSampleListState(fetchSampleList: fetchSampleList ?? this.fetchSampleList);
}
  @override
  // TODO: implement props
  List<Object?> get props => [fetchSampleList];

}