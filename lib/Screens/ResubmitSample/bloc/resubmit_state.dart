part of 'resubmit_bloc.dart';

class ResubmitState extends Equatable {
  final ApiResponse fetchList;
  final ApiResponse updateStatus;

  const ResubmitState({required this.fetchList, required this.updateStatus});

  ResubmitState copyWith({ApiResponse? fetchList, ApiResponse? updateStatus}) => ResubmitState(
        fetchList: fetchList ?? this.fetchList,
        updateStatus: updateStatus ?? this.updateStatus,
      );

  @override
  List<Object?> get props => [fetchList, updateStatus];
}
