part of 'generated_reports_bloc.dart';

abstract class GeneratedReportsEvent extends Equatable {
  const GeneratedReportsEvent();
  @override
  List<Object?> get props => [];
}

class FetchGeneratedReportsRequested extends GeneratedReportsEvent {
  const FetchGeneratedReportsRequested();
}
