part of 'sampleBloc.dart';
abstract class SampleEvent extends Equatable{
  const SampleEvent();

  List<Object> get props => [];

}

class getSampleListEvent extends SampleEvent{}

class getFormEvent extends SampleEvent{
  final String serialNo;
  const getFormEvent({required this.serialNo});

  @override
  List<Object> get props => [serialNo];
}