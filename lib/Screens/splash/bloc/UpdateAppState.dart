import 'package:equatable/equatable.dart';
import '../model/UpdateAppModel.dart';

abstract class UpdateAppState extends Equatable {
  const UpdateAppState();
  @override
  List<Object?> get props => [];
}

class UpdateAppInitial extends UpdateAppState {}

class UpdateAppLoading extends UpdateAppState {}

class UpdateAppUpToDate extends UpdateAppState {}

class UpdateAppUpdateAvailable extends UpdateAppState {
  final AppUpdates update;
  const UpdateAppUpdateAvailable(this.update);
  @override
  List<Object?> get props => [update];
}

class UpdateAppFailure extends UpdateAppState {
  final String message;
  const UpdateAppFailure(this.message);
  @override
  List<Object?> get props => [message];
}
