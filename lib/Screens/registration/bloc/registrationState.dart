part of 'registrationBloc.dart';

class RegistrationState extends Equatable {
  final String name;
  final String username;
  final String email;
  final String password;
  final String? selectedCountry;
  final String? selectedState;
  final String? selectedDistrict;
  final List<String> countries;
  final List<String> states;
  final List<String> districts;

  const RegistrationState({
    this.name = '',
    this.username = '',
    this.email = '',
    this.password = '',
    this.selectedCountry,
    this.selectedState,
    this.selectedDistrict,
    this.countries = const ['India', 'USA'],
    this.states = const [],
    this.districts = const [],
  });

  RegistrationState copyWith({
    String? name,
    String? username,
    String? email,
     String? password,

    String? selectedCountry,
    String? selectedState,
    String? selectedDistrict,
    List<String>? countries,
    List<String>? states,
    List<String>? districts,
  }) {
    return RegistrationState(
      name: name ?? this.name,
      username: username ?? this.username,
      password: password ?? this.password,
      email: email ?? this.email,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedState: selectedState ?? this.selectedState,
      selectedDistrict: selectedDistrict ?? this.selectedDistrict,
      countries: countries ?? this.countries,
      states: states ?? this.states,
      districts: districts ?? this.districts,
    );
  }

  @override
  List<Object?> get props => [
    name,
    username,
    password,
    email,
    selectedCountry,
    selectedState,
    selectedDistrict,
    countries,
    states,
    districts,
  ];
}
