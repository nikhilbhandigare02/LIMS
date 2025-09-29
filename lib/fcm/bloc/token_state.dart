part of 'token_bloc.dart';

class TokenState extends Equatable {
  const TokenState({
    this.fcmToken = '',
    this.platform = '',
    this.message = '',
    this.apiStatus = ApiStatus.initial,
  });

  final String fcmToken;
  final String platform;
  final String message;
  final ApiStatus apiStatus;

  TokenState copyWith({
    String? fcmToken,
    String? platform,
    String? message,
    ApiStatus? apiStatus,
  }) {
    return TokenState(
      fcmToken: fcmToken ?? this.fcmToken,
      platform: platform ?? this.platform,
      message: message ?? this.message,
      apiStatus: apiStatus ?? this.apiStatus,
    );
  }

  @override
  List<Object?> get props => [fcmToken, platform, message, apiStatus];
}
