import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../common/ENcryption_Decryption/AES.dart';
import '../../../common/ENcryption_Decryption/key.dart';
import '../../../core/utils/enums.dart';
import '../model/UserModel.dart';
import '../repository/loginRepository.dart';
part 'loginEvent.dart';
part 'loginState.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;

  LoginBloc({required this.loginRepository}) : super(const LoginState()) {
    on<UsernameEvent>(username);
    on<PasswordEvent>(password);
    on<LoginButtonEvent>(submitButton);
  }

  void username(UsernameEvent event, Emitter<LoginState> emit) {
    print(state.username);
    emit(state.copyWith(username: event.username));
  }

  void password(PasswordEvent event, Emitter<LoginState> emit) {
    print(state.password);
    emit(state.copyWith(password: event.password));
  }

  Future<void> submitButton(
      LoginButtonEvent event,
      Emitter<LoginState> emit,
      ) async {
    emit(state.copyWith(apiStatus: ApiStatus.loading));
    try {
      final loginData = {
        'Username': state.username,
        'Password': state.password,
      };

      final encryptedPayload = await encrypt(
        data: loginData,
        rsaPublicKeyPem: rsaPublicKeyPem,
      );

      final encryptedResponse = await loginRepository.loginApi(encryptedPayload);

      if (encryptedResponse != null) {
        print('Encrypted response received: $encryptedResponse');



        emit(state.copyWith(
          message: 'Login request sent successfully (response is encrypted)',
          apiStatus: ApiStatus.success,
        ));
      } else {
        emit(state.copyWith(
          message: 'No response from server',
          apiStatus: ApiStatus.error,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        message: 'Something went wrong: $e',
        apiStatus: ApiStatus.error,
      ));
    }
  }
}
