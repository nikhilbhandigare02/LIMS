import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:food_inspector/Screens/login/bloc/loginBloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../common/ENcryption_Decryption/AES.dart';
import '../../../common/ENcryption_Decryption/key.dart';
import '../../../core/utils/enums.dart';
import '../repository/form6Repository.dart';

part 'Form6Event.dart';
part 'Form6State.dart';

class SampleFormBloc extends Bloc<SampleFormEvent, SampleFormState> {
  final Form6Repository form6repository;
  SampleFormBloc({required this.form6repository}) : super(const SampleFormState()) {
    on<SampleCodeDataChanged>((event, emit) {
      print(state.sampleCodeData);
      emit(state.copyWith(sampleCodeData: event.value));
    });
    on<LoadSavedFormData>((event, emit) {
      emit(event.savedState); // Replace current state with saved state
    });
    on<senderNameChanged>((event, emit) {
      print(state.senderName);
      emit(state.copyWith(senderName: event.value));
    });
    on<DistrictChanged>((event, emit) {
      print(state.district);
      emit(state.copyWith(district: event.value));
    });
    on<CollectionDateChanged>((event, emit) {
        print(state.collectionDate);

      emit(state.copyWith(collectionDate: event.value));
    });
    on<UpdateValidationErrors>((event, emit) {
      emit(state.copyWith(fieldErrors: event.errors));
    });

    on<PlaceChanged>((event, emit) {
      print(state.placeOfCollection);
      emit(state.copyWith(placeOfCollection: event.value));
    });
    on<PreservativeAddedChanged>((event, emit) {
      print(state.preservativeAdded);
      emit(state.copyWith(preservativeAdded: event.value));
    });
    on<preservativeNameChanged>((event, emit) {
      print(state.preservativeName);
      emit(state.copyWith(preservativeName: event.value));
    });
    on<preservativeQuantityChanged>((event, emit) {
      print(state.preservativeQuantity);
      emit(state.copyWith(preservativeQuantity: event.value));
    });
    on<personSignatureChanged>((event, emit) {
      print(state.personSignature);
      emit(state.copyWith(personSignature: event.value));
    });
    on<slipNumberChanged>((event, emit) {
      print(state.slipNumber);
      emit(state.copyWith(slipNumber: event.value));
    });
    on<DOSignatureChanged>((event, emit) {
      print(state.DOSignature);

      emit(state.copyWith(DOSignature: event.value));
    });
    on<sampleCodeNumberChanged>((event, emit) {
      print(state.sampleCodeNumber);

      emit(state.copyWith(sampleCodeNumber: event.value));
    });
    on<sealImpressionChanged>((event, emit) {
      print(state.sealImpression);

      emit(state.copyWith(sealImpression: event.value));
    });
    on<numberofSealChanged>((event, emit) {
      print(state.numberofSeal);

      emit(state.copyWith(numberofSeal: event.value));
    });
    on<formVIChanged>((event, emit) {
      print(state.formVI);

      emit(state.copyWith(formVI: event.value));
    });
    on<FoemVIWrapperChanged>((event, emit) {
      print(state.FoemVIWrapper);

      emit(state.copyWith(FoemVIWrapper: event.value));
    });
    on<SampleNameChanged>((event, emit) {
      print(state.SampleName);

      emit(state.copyWith(SampleName: event.value));
    });
    on<QuantitySampleChanged>((event, emit) {
      print(state.QuantitySample);

      emit(state.copyWith(QuantitySample: event.value));
    });
    on<articleChanged>((event, emit) {
      print(state.article);

      emit(state.copyWith(article: event.value));
    });
    on<RegionChanged>((event, emit) {
      print(state.region);
      emit(state.copyWith(region: event.value));
    });
    on<senderDesignationChanged>((event, emit) {
      print(state.senderDesignation);
      emit(state.copyWith(senderDesignation: event.value));
    });
    on<DONumberChanged>((event, emit) {
      print(state.DONumber);
      emit(state.copyWith(DONumber: event.value));
    });
    on<DivisionChanged>((event, emit) {
      print(state.division);

      emit(state.copyWith(division: event.value));
    });
    on<AreaChanged>((event, emit) {
      print(state.area);

      emit(state.copyWith(area: event.value));
    });
    on<FormSubmit>(_onFormSubmit);

    on<FormResetEvent>((event, emit) {
      emit(const SampleFormState());
    });
    on<Lattitude>((event, emit) => emit(state.copyWith(Lattitude: event.value)));
    on<Longitude>((event, emit) => emit(state.copyWith(Longitude: event.value)));
    on<FetchLocationRequested>(_onFetchLocationRequested);
  }


  Future<void> _onFetchLocationRequested(FetchLocationRequested event, Emitter<SampleFormState> emit) async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        return;
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      emit(state.copyWith(
        Lattitude: position.latitude.toString(),
        Longitude: position.longitude.toString(),
      ));
    } catch (e) {
      // Handle error (optional)
    }
  }

  // Future<void> _onFormSubmit(
  //     FormSubmit event,
  //     Emitter<SampleFormState> emit,
  //     ) async {
  //   emit(state.copyWith(apiStatus: ApiStatus.loading));
  //
  //   try {
  //     final formData = {
  //       'senderName': state.senderName,
  //       'sampleCodeData': state.sampleCodeData,
  //       'DONumber': state.DONumber,
  //       'district': state.district,
  //       'region': state.region,
  //       'division': state.division,
  //       'area': state.area,
  //       'collectionDate': state.collectionDate?.toIso8601String(),
  //       'placeOfCollection': state.placeOfCollection,
  //       'SampleName': state.SampleName,
  //       'QuantitySample': state.QuantitySample,
  //       'article': state.article,
  //       'preservativeAdded': state.preservativeAdded,
  //       'preservativeName': state.preservativeName,
  //       'preservativeQuantity': state.preservativeQuantity,
  //       'personSignature': state.personSignature,
  //       'slipNumber': state.slipNumber,
  //       'DOSignature': state.DOSignature,
  //       'sampleCodeNumber': state.sampleCodeNumber,
  //       'sealImpression': state.sealImpression,
  //       'numberofSeal': state.numberofSeal,
  //       'formVI': state.formVI,
  //       'FoemVIWrapper': state.FoemVIWrapper,
  //     };
  //
  //     final response = await form6repository.FormSixApi(formData);
  //
  //     if (response.result == "success") {
  //       emit(state.copyWith(
  //         apiStatus: ApiStatus.success,
  //         message: response.remark ?? "Form submitted successfully",
  //       ));
  //     } else {
  //       emit(state.copyWith(
  //         apiStatus: ApiStatus.error,
  //         message: response.remark ?? "Form submission failed",
  //       ));
  //     }
  //   } catch (e) {
  //     emit(state.copyWith(
  //       apiStatus: ApiStatus.error,
  //       message: "Something went wrong: ${e.toString()}",
  //     ));
  //   }
  // }



  Future<void> _onFormSubmit(
      FormSubmit event,
      Emitter<SampleFormState> emit,
      ) async {
    emit(state.copyWith(apiStatus: ApiStatus.loading));
    try {
      final formData =  {
        'senderName': state.senderName,
        'sampleCodeData': state.sampleCodeData,
        'DONumber': state.DONumber,
        'district': state.district,
        'region': state.region,
        'division': state.division,
        'lattitude':state.Lattitude,
        'longitude':state.Longitude,
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


      final session = await encryptWithSession(
        data: formData,
        rsaPublicKeyPem: rsaPublicKeyPem,
      );

      final encryptedResponse = await form6repository.FormSixApi(session.payloadForServer);

      if (encryptedResponse != null) {
        print('Encrypted response received: $encryptedResponse');
        try {
          final String encryptedDataBase64 =
          (encryptedResponse['encryptedData'] ?? encryptedResponse['EncryptedData']) as String;
          final String serverIvBase64 = (encryptedResponse['iv'] ?? encryptedResponse['IV']) as String;

          final String decrypted = utf8.decode(
            aesCbcDecrypt(
              base64ToBytes(encryptedDataBase64),
              session.aesKeyBytes,
              base64ToBytes(serverIvBase64),
            ),
          );

          print('Decrypted Form response: $decrypted');

        } catch (e) {
          print('Failed to decrypt form response: $e');
          try {
            final String encryptedAESKey =
            (encryptedResponse['encryptedAESKey'] ?? encryptedResponse['EncryptedAESKey']) as String;
            final String encryptedData =
            (encryptedResponse['encryptedData'] ?? encryptedResponse['EncryptedData']) as String;
            final String iv = (encryptedResponse['iv'] ?? encryptedResponse['IV']) as String;

            final String decryptedFallback = await decrypt(
              encryptedAESKeyBase64: encryptedAESKey,
              encryptedDataBase64: encryptedData,
              ivBase64: iv,
              rsaPrivateKeyPem: rsaPrivateKeyPem,
            );
            print('Decrypted (fallback) Form response: $decryptedFallback');
          } catch (e2) {
            print('Fallback decryption also failed: $e2');
          }
        }

        emit(state.copyWith(
          message: 'Form VI data submitted succesfully',
          apiStatus: ApiStatus.success,
        ));
      } else {
        emit(state.copyWith(
          message: 'No response from server',
          apiStatus: ApiStatus.error,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        message: 'Something went wrong: $e',
        apiStatus: ApiStatus.error,
      ));
    }
  }

}
