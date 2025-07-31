import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_inspector/Screens/Sample%20list/bloc/sampleBloc.dart';
import 'package:food_inspector/Screens/registration/Repository/resisterRepository.dart';
import 'package:food_inspector/core/utils/enums.dart';

part 'registrationEvent.dart';
part 'registrationState.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final registerRepository regRepository; // Assumed login API usage

  final Map<String, List<String>> countryStateMap = {
    'India': ['Maharashtra', 'Karnataka', 'Gujarat'],
    'USA': ['California', 'Texas', 'New York'],
  };

  final Map<String, List<String>> stateDistrictMap = {
    'Maharashtra': ['Pune', 'Mumbai', 'Nagpur'],
    'Karnataka': ['Bangalore', 'Mysore', 'Hubli'],
    'Gujarat': ['Ahmedabad', 'Surat'],
    'California': ['Los Angeles', 'San Francisco'],
    'Texas': ['Houston', 'Dallas'],
    'New York': ['Buffalo', 'Albany'],
  };

  RegistrationBloc({required this.regRepository}) : super(const RegistrationState()) {
    on<NameChanged>((event, emit) {
      emit(state.copyWith(name: event.name));
    });

    on<UsernameChanged>((event, emit) {
      emit(state.copyWith(username: event.username));
    });

    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<EmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });

    on<CountryChanged>((event, emit) {
      final states = countryStateMap[event.country] ?? [];
      emit(state.copyWith(
        selectedCountry: event.country,
        states: states,
        selectedState: null,
        districts: [],
        selectedDistrict: null,
      ));
    });

    on<StateChanged>((event, emit) {
      final districts = stateDistrictMap[event.state] ?? [];
      emit(state.copyWith(
        selectedState: event.state,
        districts: districts,
        selectedDistrict: null,
      ));
    });

    on<DistrictNameChanged>((event, emit) {
      emit(state.copyWith(selectedDistrict: event.district));
    });

    on<FormSubmitted>(_submitRegister);
  }

  Future<void> _submitRegister(
      FormSubmitted event,
      Emitter<RegistrationState> emit,
      ) async {
    emit(state.copyWith(apiStatus: ApiStatus.loading));
    try {
      Map<String, dynamic> data = {
        'username': state.username,
        'password': state.password,
      };
      final response = await regRepository.registerApi(data);

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
