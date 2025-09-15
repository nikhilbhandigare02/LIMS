part of 'SlipRequestBloc.dart';

abstract class SlipRequestEvent extends Equatable {
  const SlipRequestEvent();

  @override
  List<Object> get props => [];
}

class getRequestDataEvent extends SlipRequestEvent {
  final int userId;
  const getRequestDataEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class getCountEvent extends SlipRequestEvent {
  final int count;
  const getCountEvent({required this.count});

  @override
  List<Object> get props => [count];
}

// 👇 new event for updating slip count
class updateSlipCountEvent extends SlipRequestEvent {
  final int requestId;
  final int newCount;

  const updateSlipCountEvent({
    required this.requestId,
    required this.newCount,
  });

  @override
  List<Object> get props => [requestId, newCount];
}
