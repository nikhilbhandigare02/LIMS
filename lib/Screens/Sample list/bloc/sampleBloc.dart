import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_inspector/Screens/Sample%20list/repository/sampleRepository.dart';
import 'package:food_inspector/Screens/login/model/UserModel.dart';
import 'package:food_inspector/common/ApiResponse.dart';
part 'sampleEvent.dart';
part 'sampleState.dart';


class SampleBloc extends Bloc<getSampleListEvent, getSampleListState>{
  final SampleRepository sampleRepository;
  SampleBloc({required this.sampleRepository}):super(getSampleListState(fetchSampleList: ApiResponse.loading())){
on<getSampleListEvent> (_getSampleListEvent);
  }



  Future<void> _getSampleListEvent(
      getSampleListEvent event,
      Emitter<getSampleListState> emit,
      ) async {
    emit(state.copyWith(fetchSampleList: ApiResponse.loading()));

    await sampleRepository.getSampleData().then((value) {
      emit(state.copyWith(fetchSampleList: ApiResponse.complete(value)));
    }).onError((error, stackTrace) {
      emit(state.copyWith(fetchSampleList: ApiResponse.error(error.toString())));
    });
  }
}