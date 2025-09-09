part of 'SealRequestBloc.dart';

abstract class SealRequestEvent extends Equatable {
  const SealRequestEvent();

  @override
  List<Object> get props => [];
}

class getRequestDataEvent extends SealRequestEvent {
  final int userId;
  const getRequestDataEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class getCountEvent extends SealRequestEvent {
  final int count;
  const getCountEvent({required this.count});

  @override
  List<Object> get props => [count];
}

// 👇 new event for updating slip count
class updateSlipCountEvent extends SealRequestEvent {
  final int requestId;
  final int newCount;

  const updateSlipCountEvent({
    required this.requestId,
    required this.newCount,
  });

  @override
  List<Object> get props => [requestId, newCount];
}
