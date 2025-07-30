import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/utils/enums.dart';
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
    emit(state.copyWith(username: event.username));
  }

  void password(PasswordEvent event, Emitter<LoginState> emit) {
    emit(state.copyWith(password: event.password));
  }

  Future<void> submitButton(
      LoginButtonEvent event,
      Emitter<LoginState> emit,
      ) async {
    emit(state.copyWith(apiStatus: ApiStatus.loading));
    try {
      Map<String, dynamic> data = {
        'username': state.username,
        'password': state.password,
      };
      final response = await loginRepository.loginApi(data);

      if (response.result == "success") {
        emit(state.copyWith(
          message: response.remark ?? 'Login Successful',
          apiStatus: ApiStatus.success,
        ));
      } else {
        emit(state.copyWith(
          message: response.remark ?? 'Invalid credentials',
          apiStatus: ApiStatus.error,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        message: 'Something went wrong',
        apiStatus: ApiStatus.error,
      ));
    }
  }

}
