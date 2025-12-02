part of 'generated_reports_bloc.dart';

class GeneratedReportsState extends Equatable {
  final ApiResponse<GeneratedReportsEnvelope> reports;

  const GeneratedReportsState({required this.reports});

  GeneratedReportsState copyWith({ApiResponse<GeneratedReportsEnvelope>? reports}) {
    return GeneratedReportsState(
      reports: reports ?? this.reports,
    );
  }

  @override
  List<Object?> get props => [reports];
}
