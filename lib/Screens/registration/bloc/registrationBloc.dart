import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'registrationEvent.dart';
part 'registrationState.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
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

  RegistrationBloc() : super(const RegistrationState()) {
    on<NameChanged>((event, emit) {
      print(state.name);
      emit(state.copyWith(name: event.name));
    });
    on<UsernameChanged>((event, emit) {
      print(state.username);
      emit(state.copyWith(username: event.username));
    });
    on<EmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });

    on<CountryChanged>((event, emit) {
      print(event.country);
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
        selectedDistrict: null, // 🔥 reset to avoid mismatch
      ));
    });


    on<DistrictNameChanged>((event, emit) {
      emit(state.copyWith(selectedDistrict: event.district));
    });

    on<FormSubmitted>((event, emit) {
      // Submit logic here
    });
  }
}