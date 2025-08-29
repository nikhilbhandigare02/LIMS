part of "request_bloc.dart";
abstract class RequestSealEvent extends Equatable{
  const RequestSealEvent();
  @override
  List<Object> get props => [];
}

class RequestDateEvent extends RequestSealEvent{
  final DateTime selectedDate;
  RequestDateEvent(this.selectedDate);
  @override
  List<Object> get props => [selectedDate];
}

class SubmitRequestEvent extends RequestSealEvent{}