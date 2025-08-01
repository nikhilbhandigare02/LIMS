import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_inspector/Screens/Sample%20list/repository/sampleRepository.dart';

import '../../../core/utils/enums.dart';
part 'UpdatePassEvent.dart';
part 'updatePassState.dart';

class UpdatePasswordBloc extends Bloc<UpdatePasswordEvent, UpdatePasswordState> {
  // final LoginRepository loginRepository;

  UpdatePasswordBloc() : super(const UpdatePasswordState()) {
    // on<CurrentPasswordEvent>(currentPass);
    on<CurrentPasswordEvent>(currentPass);
    on<NewPasswordEvent>(newPass);
    on<ConformPasswordEvent>(confirmPass);
    on<UpdatePassButtonEvent>(updatePassButton);
  }

  void currentPass(CurrentPasswordEvent event, Emitter<UpdatePasswordState> emit) {
    print(state.currentPassword);
    emit(state.copyWith(currentPassword: event.currentPassword));
  }
  void newPass(NewPasswordEvent event, Emitter<UpdatePasswordState> emit) {

    emit(state.copyWith(currentPassword: event.newPassword));
  }
  void confirmPass(ConformPasswordEvent event, Emitter<UpdatePasswordState> emit) {

    emit(state.copyWith(currentPassword: event.confirmPassword));
  }
void updatePassButton(UpdatePassButtonEvent event, Emitter<UpdatePasswordState> emit) {

  }



  // Future<void> submitButton(
  //     CurrentPasswordEvent event,
  //     Emitter<UpdatePasswordState> emit,
  //     ) async {
  //   emit(state.copyWith(apiStatus: ApiStatus.loading));
  //   try {
  //     Map<String, dynamic> data = {
  //       'username': state.username,
  //       'password': state.password,
  //     };
  //     final response = await SampleRepository.(data);
  //
  //     if (response.result == "success") {
  //       emit(state.copyWith(
  //         message: response.remark ?? 'Login Successful',
  //         apiStatus: ApiStatus.success,
  //       ));
  //     } else {
  //       emit(state.copyWith(
  //         message: response.remark ?? 'Invalid credentials',
  //         apiStatus: ApiStatus.error,
  //       ));
  //     }
  //   } catch (e) {
  //     emit(state.copyWith(
  //       message: 'Something went wrong',
  //       apiStatus: ApiStatus.error,
  //     ));
  //   }
  // }

}
