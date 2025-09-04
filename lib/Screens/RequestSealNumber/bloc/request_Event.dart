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
class sealNumberEvent extends RequestSealEvent{
  final String sealNumber;
  sealNumberEvent(this.sealNumber);
  @override
  List<Object> get props => [sealNumber];
}
class RequestCountEvent extends RequestSealEvent{
  final String sealNumberCount;
  RequestCountEvent(this.sealNumberCount);
  @override
  List<Object> get props => [sealNumberCount];
}


class SubmitRequestEvent extends RequestSealEvent{}