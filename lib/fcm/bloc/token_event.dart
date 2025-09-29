part of 'token_bloc.dart';
abstract class TokenEvent extends Equatable {
  const TokenEvent();

  @override
  List<Object?> get props => [];
}

class SaveFcmTokenRequested extends TokenEvent {
  final String token;
  final String? platform;

  const SaveFcmTokenRequested({required this.token, this.platform});

  @override
  List<Object?> get props => [token, platform];
}
