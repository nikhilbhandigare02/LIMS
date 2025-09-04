
part of 'SealRequestBloc.dart';
abstract class SealRequestEvent extends Equatable{
  const SealRequestEvent();

  List<Object> get props => [];
}

class getRequestDAtaEvent extends SealRequestEvent{}

class getRequestDataEvent extends SealRequestEvent{
  final int userId;
  const getRequestDataEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}