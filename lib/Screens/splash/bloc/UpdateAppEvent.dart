import 'package:equatable/equatable.dart';

abstract class UpdateAppEvent extends Equatable {
  const UpdateAppEvent();
  @override
  List<Object?> get props => [];
}

class CheckForUpdate extends UpdateAppEvent {
  const CheckForUpdate();
}
