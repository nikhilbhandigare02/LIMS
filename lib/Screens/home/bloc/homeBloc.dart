import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:food_inspector/Screens/login/bloc/loginBloc.dart';

import '../../../core/utils/enums.dart';
import '../repository/homeRepository.dart';

part 'homeEvent.dart';
part 'homeState.dart';

class SampleFormBloc extends Bloc<SampleFormEvent, SampleFormState> {
  final Form6Repository form6repository;
  SampleFormBloc({required this.form6repository}) : super(const SampleFormState()) {
    on<SampleCodeChanged>((event, emit) {
      print(state.sampleCode);
      emit(state.copyWith(sampleCode: event.value));
    });
    on<senderNameChanged>((event, emit) {
      emit(state.copyWith(senderName: event.value));
    });
    on<DistrictChanged>((event, emit) {
      emit(state.copyWith(district: event.value));
    });
    on<CollectionDateChanged>((event, emit) {
      emit(state.copyWith(collectionDate: event.value));
    });
    on<PlaceChanged>((event, emit) {
      emit(state.copyWith(placeOfCollection: event.value));
    });
    on<PreservativeAddedChanged>((event, emit) {
      emit(state.copyWith(preservativeAdded: event.value));
    });
    on<preservativeNameChanged>((event, emit) {
      emit(state.copyWith(preservativeName: event.value));
    });
    on<preservativeQuantityChanged>((event, emit) {
      emit(state.copyWith(preservativeQuantity: event.value));
    });
    on<personSignatureChanged>((event, emit) {
      emit(state.copyWith(personSignature: event.value));
    });
    on<slipNumberChanged>((event, emit) {
      emit(state.copyWith(slipNumber: event.value));
    });
    on<DOSignatureChanged>((event, emit) {
      emit(state.copyWith(DOSignature: event.value));
    });
    on<sampleCodeNumberChanged>((event, emit) {
      emit(state.copyWith(sampleCodeNumber: event.value));
    });
    on<sealImpressionChanged>((event, emit) {
      emit(state.copyWith(sealImpression: event.value));
    });
    on<numberofSealChanged>((event, emit) {
      emit(state.copyWith(numberofSeal: event.value));
    });
    on<formVIChanged>((event, emit) {
      emit(state.copyWith(formVI: event.value));
    });
    on<FoemVIWrapperChanged>((event, emit) {
      emit(state.copyWith(FoemVIWrapper: event.value));
    });
    on<SampleNameChanged>((event, emit) {
      emit(state.copyWith(SampleName: event.value));
    });
    on<QuantitySampleChanged>((event, emit) {
      emit(state.copyWith(QuantitySample: event.value));
    });
    on<articleChanged>((event, emit) {
      emit(state.copyWith(article: event.value));
    });
    on<RegionChanged>((event, emit) {
      emit(state.copyWith(region: event.value));
    });
    on<DivisionChanged>((event, emit) {
      emit(state.copyWith(division: event.value));
    });
    on<AreaChanged>((event, emit) {
      emit(state.copyWith(area: event.value));
    });
    on<FormSubmit>(_onFormSubmit);

  }

  Future<void> _onFormSubmit(
      FormSubmit event,
      Emitter<SampleFormState> emit,
      ) async {
    emit(state.copyWith(apiStatus: ApiStatus.loading));

    try {
      final formData = {
        'senderName': state.senderName,
        'sampleCode': state.sampleCode,
        'DONumber': state.DONumber,
        'district': state.district,
        'region': state.region,
        'division': state.division,
        'area': state.area,
        'collectionDate': state.collectionDate?.toIso8601String(),
        'placeOfCollection': state.placeOfCollection,
        'SampleName': state.SampleName,
        'QuantitySample': state.QuantitySample,
        'article': state.article,
        'preservativeAdded': state.preservativeAdded,
        'preservativeName': state.preservativeName,
        'preservativeQuantity': state.preservativeQuantity,
        'personSignature': state.personSignature,
        'slipNumber': state.slipNumber,
        'DOSignature': state.DOSignature,
        'sampleCodeNumber': state.sampleCodeNumber,
        'sealImpression': state.sealImpression,
        'numberofSeal': state.numberofSeal,
        'formVI': state.formVI,
        'FoemVIWrapper': state.FoemVIWrapper,
      };

      final response = await form6repository.FormSixApi(formData);

      if (response.result == "success") {
        emit(state.copyWith(
          apiStatus: ApiStatus.success,
          message: response.remark ?? "Form submitted successfully",
        ));
      } else {
        emit(state.copyWith(
          apiStatus: ApiStatus.error,
          message: response.remark ?? "Form submission failed",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        apiStatus: ApiStatus.error,
        message: "Something went wrong: ${e.toString()}",
      ));
    }
  }

}
