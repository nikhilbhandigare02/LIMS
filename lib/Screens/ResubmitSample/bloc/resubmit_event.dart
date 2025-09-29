part of 'resubmit_bloc.dart';

abstract class ResubmitEvent extends Equatable {
  const ResubmitEvent();
  @override
  List<Object?> get props => [];
}

class FetchApprovedSamplesByUser extends ResubmitEvent {
  const FetchApprovedSamplesByUser();
}

class UpdateStatusResubmitRequested extends ResubmitEvent {
  final String serialNo;
  final int insertedBy;

  const UpdateStatusResubmitRequested({required this.serialNo, required this.insertedBy});

  @override
  List<Object?> get props => [serialNo, insertedBy];
}
