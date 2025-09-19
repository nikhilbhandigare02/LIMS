part of 'sampleBloc.dart';
abstract class SampleEvent extends Equatable{
  const SampleEvent();

  List<Object?> get props => [];

}

class getSampleListEvent extends SampleEvent{
  final DateTime? fromDate;
  final DateTime? toDate;
  const getSampleListEvent({this.fromDate, this.toDate});

  @override
  List<Object?> get props => [fromDate?.toIso8601String(), toDate?.toIso8601String()];
}

class getFormEvent extends SampleEvent{
  final String serialNo;
  const getFormEvent({required this.serialNo});

  @override
  List<Object> get props => [serialNo];
}