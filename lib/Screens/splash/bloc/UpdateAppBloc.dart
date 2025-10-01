import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../model/UpdateAppModel.dart';
import '../repository/UpdateAppRepository.dart';
import 'UpdateAppEvent.dart';
import 'UpdateAppState.dart';

class UpdateAppBloc extends Bloc<UpdateAppEvent, UpdateAppState> {
  final UpdateAppRepository repository;

  UpdateAppBloc(this.repository) : super(UpdateAppInitial()) {
    on<CheckForUpdate>(_onCheckForUpdate);
  }

  Future<void> _onCheckForUpdate(
    CheckForUpdate event,
    Emitter<UpdateAppState> emit,
  ) async {
    emit(UpdateAppLoading());
    try {
      final UpdateAppModel resp = await repository.fetchUpdateInfo();
      final bool hasUpdates = resp.appUpdates?.isNotEmpty ?? false;
      final num? topFlag = resp.updateAvailable;
      final num? itemFlag = hasUpdates ? resp.appUpdates!.first.updateAvailable : null;

      // Debug logs to diagnose flag mismatches
      // ignore: avoid_print
      print('[Update][Bloc] topFlag=${topFlag?.toString()} itemFlag=${itemFlag?.toString()} hasUpdates=$hasUpdates itemsCount=${resp.appUpdates?.length ?? 0}');

      final bool shouldUpdate =
          (topFlag != null && topFlag.toInt() == 1) ||
          (itemFlag != null && itemFlag.toInt() == 1);

      if (shouldUpdate && hasUpdates) {
        emit(UpdateAppUpdateAvailable(resp.appUpdates!.first));
      } else {
        emit(UpdateAppUpToDate());
      }
    } catch (e) {
      emit(UpdateAppFailure(e.toString()));
    }
  }
}

