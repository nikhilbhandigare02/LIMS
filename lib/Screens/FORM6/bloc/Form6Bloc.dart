import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  SampleFormBloc({required this.form6repository}) : super(const SampleFormState()) {
    on<SampleCodeDataChanged>((event, emit) {
      print(state.sampleCodeData);
      emit(state.copyWith(sampleCodeData: event.value));
    });
    on<LoadSavedFormData>((event, emit) {
      emit(event.savedState);
      
      if (event.savedState.districtOptions.isEmpty) {
        add(const FetchDistrictsRequested(1));
      }
      if (event.savedState.natureOptions.isEmpty) {
        add(const FetchNatureOfSampleRequested());
      }
      
      if (event.savedState.district.isNotEmpty && event.savedState.regionOptions.isEmpty) {
        Future.delayed(const Duration(milliseconds: 500), () {
          final currentState = state;
          final districtId = currentState.districtIdByName[event.savedState.district];
          if (districtId != null) {
            add(FetchRegionsRequested(districtId));
          }
        });
      }
      
      if (event.savedState.region.isNotEmpty && event.savedState.divisionOptions.isEmpty) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          final currentState = state;
          final regionId = currentState.regionIdByName[event.savedState.region];
          if (regionId != null) {
            add(FetchDivisionsRequested(regionId));
          }
        });
      }
    });
    on<senderNameChanged>((event, emit) {
      print(state.senderName);
      emit(state.copyWith(senderName: event.value));
    });
    on<DistrictChanged>((event, emit) {
      print(state.district);
      emit(state.copyWith(district: event.value));

      final districtId = _extractIdFromSelectedDistrict(event.value);
      if (districtId != null) {
        add(FetchRegionsRequested(districtId));
      }
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
    on<FetchNatureOfSampleRequested>(_onFetchNatureOfSampleRequested);
    on<RegionChanged>((event, emit) {
      print(state.region);
      emit(state.copyWith(region: event.value));
      final regionId = state.regionIdByName[event.value ?? ''];
      if (regionId != null) {
        add(FetchDivisionsRequested(regionId));
      }
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
    on<FetchDistrictsRequested>(_onFetchDistrictsRequested);
    on<FetchRegionsRequested>(_onFetchRegionsRequested);
    on<FetchDivisionsRequested>(_onFetchDivisionsRequested);
    on<FormSubmit>(_onFormSubmit);

    on<FormResetEvent>((event, emit) {
      emit(const SampleFormState());
    });
    on<Lattitude>((event, emit) => emit(state.copyWith(Lattitude: event.value)));
    on<Longitude>((event, emit) => emit(state.copyWith(Longitude: event.value)));
    on<FetchLocationRequested>(_onFetchLocationRequested);
  }
    

  Future<void> _onFetchDistrictsRequested(
      FetchDistrictsRequested event,
      Emitter<SampleFormState> emit,
      ) async {
    try {
      final request = {
        'StateId': event.stateId,
      };

      final session = await encryptWithSession(
        data: request,
        rsaPublicKeyPem: rsaPublicKeyPem,
      );

      final encryptedResponse = await form6repository.getDistrictsByStateId(session.payloadForServer);

      if (encryptedResponse == null) {
        return;
      }

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

        final parsed = _parseIdNameList(decrypted, idKeys: ['districtId', 'DistrictId', 'Id', 'id'], nameKeys: ['districtName', 'DistrictName', 'name', 'Name', 'text', 'Text', 'label', 'Label']);
        emit(state.copyWith(
          districtOptions: parsed.names,
          districtIdByName: parsed.nameToId,
          district: state.district.isEmpty && parsed.names.isNotEmpty ? parsed.names.first : state.district,
        ));
      } catch (e) {
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
          final parsed = _parseIdNameList(decryptedFallback, idKeys: ['districtId', 'DistrictId', 'Id', 'id'], nameKeys: ['districtName', 'DistrictName', 'name', 'Name', 'text', 'Text', 'label', 'Label']);
          emit(state.copyWith(
            districtOptions: parsed.names,
            districtIdByName: parsed.nameToId,
            district: state.district.isEmpty && parsed.names.isNotEmpty ? parsed.names.first : state.district,
          ));
        } catch (_) {
          // swallow; keep current options
        }
      }
    } catch (_) {
      // swallow; keep current options
    }
  }

  Future<void> _onFetchRegionsRequested(
      FetchRegionsRequested event,
      Emitter<SampleFormState> emit,
      ) async {
    try {
      final request = {
        'DistrictId': event.districtId,
      };

      final session = await encryptWithSession(
        data: request,
        rsaPublicKeyPem: rsaPublicKeyPem,
      );

      final encryptedResponse = await form6repository.getRegionsByDistrictId(session.payloadForServer);
      if (encryptedResponse == null) return;

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

        final parsed = _parseIdNameList(decrypted, idKeys: ['regionId', 'RegionId', 'Id', 'id'], nameKeys: ['regionName', 'RegionName', 'name', 'Name', 'text', 'Text', 'label', 'Label']);
        emit(state.copyWith(
          regionOptions: parsed.names,
          regionIdByName: parsed.nameToId,
          region: state.region.isEmpty && parsed.names.isNotEmpty ? parsed.names.first : state.region,
        ));
      } catch (e) {
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
          final parsed = _parseIdNameList(decryptedFallback, idKeys: ['regionId', 'RegionId', 'Id', 'id'], nameKeys: ['regionName', 'RegionName', 'name', 'Name', 'text', 'Text', 'label', 'Label']);
          emit(state.copyWith(
            regionOptions: parsed.names,
            regionIdByName: parsed.nameToId,
            region: state.region.isEmpty && parsed.names.isNotEmpty ? parsed.names.first : state.region,
          ));
        } catch (_) {}
      }
    } catch (_) {}
  }

  Future<void> _onFetchDivisionsRequested(
      FetchDivisionsRequested event,
      Emitter<SampleFormState> emit,
      ) async {
    try {
      final request = {
        'RegionId': event.regionId,
      };

      final session = await encryptWithSession(
        data: request,
        rsaPublicKeyPem: rsaPublicKeyPem,
      );

      final encryptedResponse = await form6repository.getDivisionsByRegionId(session.payloadForServer);
      if (encryptedResponse == null) return;

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

        final parsed = _parseIdNameList(decrypted, idKeys: ['divisionId', 'DivisionId', 'Id', 'id'], nameKeys: ['divisionName', 'DivisionName', 'name', 'Name', 'text', 'Text', 'label', 'Label']);
        emit(state.copyWith(
          divisionOptions: parsed.names,
          divisionIdByName: parsed.nameToId,
          division: state.division.isNotEmpty && parsed.names.contains(state.division) ? state.division : (parsed.names.isNotEmpty ? parsed.names.first : ''),
        ));
      } catch (e) {
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
          final parsed = _parseIdNameList(decryptedFallback, idKeys: ['divisionId', 'DivisionId', 'Id', 'id'], nameKeys: ['divisionName', 'DivisionName', 'name', 'Name', 'text', 'Text', 'label', 'Label']);
          emit(state.copyWith(
            divisionOptions: parsed.names,
            divisionIdByName: parsed.nameToId,
            division: state.division.isNotEmpty && parsed.names.contains(state.division) ? state.division : (parsed.names.isNotEmpty ? parsed.names.first : ''),
          ));
        } catch (_) {}
      }
    } catch (_) {}
  }

  Future<void> _onFetchNatureOfSampleRequested(
      FetchNatureOfSampleRequested event,
      Emitter<SampleFormState> emit,
      ) async {
    try {
      final request = <String, dynamic>{};
      if (event.categoryId != null) request['CategoryId'] = event.categoryId;

      final session = await encryptWithSession(
        data: request,
        rsaPublicKeyPem: rsaPublicKeyPem,
      );

      final encryptedResponse = await form6repository.getNatureOfSample(session.payloadForServer);
      if (encryptedResponse == null) return;

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

        final parsed = _parseIdNameList(
          decrypted,
          idKeys: ['natureId', 'NatureId', 'Id', 'id'],
          nameKeys: ['natureName', 'NatureName', 'name', 'Name', 'text', 'Text', 'label', 'Label'],
        );
        emit(state.copyWith(
          natureOptions: parsed.names,
          natureIdByName: parsed.nameToId,
          article: state.article.isNotEmpty && parsed.names.contains(state.article) ? state.article : (parsed.names.isNotEmpty ? parsed.names.first : ''),
        ));
      } catch (e) {
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
          final parsed = _parseIdNameList(
            decryptedFallback,
            idKeys: ['natureId', 'NatureId', 'Id', 'id'],
            nameKeys: ['natureName', 'NatureName', 'name', 'Name', 'text', 'Text', 'label', 'Label'],
          );
          emit(state.copyWith(
            natureOptions: parsed.names,
            natureIdByName: parsed.nameToId,
            article: state.article.isNotEmpty && parsed.names.contains(state.article) ? state.article : (parsed.names.isNotEmpty ? parsed.names.first : ''),
          ));
        } catch (_) {}
      }
    } catch (_) {}
  }

  List<String> _parseRegionNames(String decryptedJson) {
    try {
      final dynamic parsed = jsonDecode(decryptedJson);
      List<dynamic> items;
      if (parsed is Map<String, dynamic>) {
        items = (parsed['Data'] ?? parsed['data'] ?? parsed['Result'] ?? parsed['result'] ?? []) as List<dynamic>;
      } else if (parsed is List) {
        items = parsed;
      } else {
        items = const [];
      }

      final List<String> names = [];
      for (final dynamic item in items) {
        if (item is Map<String, dynamic>) {
          final candidates = [
            item['regionName'], item['RegionName'], item['name'], item['Name'],
            item['text'], item['Text'], item['label'], item['Label'],
          ];
          final String? found = candidates
              .whereType<String>()
              .map((s) => s.trim())
              .firstWhere((s) => s.isNotEmpty, orElse: () => '');
          if (found != null && found.isNotEmpty) names.add(found);
        } else if (item is String) {
          final s = item.trim();
          if (s.isNotEmpty) names.add(s);
        }
      }
      return names;
    } catch (_) {
      return const [];
    }
  }
  List<String> _parseDistrictNames(String decryptedJson) {
    try {
      final dynamic parsed = jsonDecode(decryptedJson);
      List<dynamic> items;
      if (parsed is Map<String, dynamic>) {
        items = (parsed['Data'] ?? parsed['data'] ?? parsed['Result'] ?? parsed['result'] ?? []) as List<dynamic>;
      } else if (parsed is List) {
        items = parsed;
      } else {
        items = const [];
      }

      final List<String> names = [];
      for (final dynamic item in items) {
        if (item is Map<String, dynamic>) {
          final candidates = [
            item['districtName'], item['DistrictName'], item['name'], item['Name'],
            item['text'], item['Text'], item['label'], item['Label'],
          ];
          final String? found = candidates
              .whereType<String>()
              .map((s) => s.trim())
              .firstWhere((s) => s.isNotEmpty, orElse: () => '');
          if (found != null && found.isNotEmpty) {
            names.add(found);
          }
        } else if (item is String) {
          final s = item.trim();
          if (s.isNotEmpty) names.add(s);
        }
      }
      return names;
    } catch (_) {
      return const [];
    }
  }

  int? _extractIdFromSelectedDistrict(String? selected) {
    if (selected == null) return null;
    final id = state.districtIdByName[selected];
    return id;
  }

  _ParsedList _parseIdNameList(String decryptedJson, {required List<String> idKeys, required List<String> nameKeys}) {
    try {
      final dynamic parsed = jsonDecode(decryptedJson);
      List<dynamic> items;
      if (parsed is Map<String, dynamic>) {
        items = (parsed['Data'] ?? parsed['data'] ?? parsed['Result'] ?? parsed['result'] ?? []) as List<dynamic>;
      } else if (parsed is List) {
        items = parsed;
      } else {
        items = const [];
      }

      final List<String> names = [];
      final Map<String, int> nameToId = {};
      for (final dynamic item in items) {
        if (item is Map<String, dynamic>) {
          int? id;
          String? name;
          for (final k in idKeys) {
            final v = item[k];
            if (v == null) continue;
            id = v is int ? v : int.tryParse(v.toString());
            if (id != null) break;
          }
          for (final k in nameKeys) {
            final v = item[k];
            if (v == null) continue;
            final s = v.toString().trim();
            if (s.isNotEmpty) {
              name = s;
              break;
            }
          }
          if (name != null) {
            names.add(name);
            if (id != null) nameToId[name] = id;
          }
        }
      }
      return _ParsedList(names: names, nameToId: nameToId);
    } catch (_) {
      return _ParsedList(names: const [], nameToId: const {});
    }
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
      final String? loginDataJson = await _secureStorage.read(key: 'loginData');
      int? userId;
      if (loginDataJson != null && loginDataJson.isNotEmpty) {
        try {
          final map = jsonDecode(loginDataJson) as Map<String, dynamic>;
          final dynamic uid = map['userId'] ?? map['UserId'] ?? map['user_id'];
          if (uid is int) userId = uid; else if (uid != null) userId = int.tryParse(uid.toString());
        } catch (_) {}
      }

      // Load dropdown options if they're not already loaded
      if (state.districtOptions.isEmpty) {
        print("🔄 Loading districts...");
        await _onFetchDistrictsRequested(const FetchDistrictsRequested(1), emit);
      }
      
      if (state.regionOptions.isEmpty && state.district.isNotEmpty) {
        final districtId = state.districtIdByName[state.district];
        if (districtId != null) {
          print("🔄 Loading regions for district $districtId...");
          await _onFetchRegionsRequested(FetchRegionsRequested(districtId), emit);
        }
      }
      
      if (state.divisionOptions.isEmpty && state.region.isNotEmpty) {
        final regionId = state.regionIdByName[state.region];
        if (regionId != null) {
          print("🔄 Loading divisions for region $regionId...");
          await _onFetchDivisionsRequested(FetchDivisionsRequested(regionId), emit);
        }
      }
      
      if (state.natureOptions.isEmpty) {
        print("🔄 Loading nature of sample options...");
        await _onFetchNatureOfSampleRequested(const FetchNatureOfSampleRequested(), emit);
      }

      final int? districtId = state.districtIdByName[state.district];
      final int? regionId = state.regionIdByName[state.region];
      final int? divisionId = state.divisionIdByName[state.division];
      final int? sampleId = state.natureIdByName[state.article];

      // Debug logging
      print("🔍 Submit validation - District: '${state.district}' -> ID: $districtId");
      print("🔍 Submit validation - Region: '${state.region}' -> ID: $regionId");
      print("🔍 Submit validation - Division: '${state.division}' -> ID: $divisionId");
      print("🔍 Submit validation - Article: '${state.article}' -> ID: $sampleId");
      print("🔍 Available district IDs: ${state.districtIdByName}");
      print("🔍 Available region IDs: ${state.regionIdByName}");
      print("🔍 Available division IDs: ${state.divisionIdByName}");
      print("🔍 Available nature IDs: ${state.natureIdByName}");

      // If any ID is still null after loading, try one more time with a delay
      if (districtId == null || regionId == null || divisionId == null || sampleId == null) {
        print("⚠️ Some IDs are still null, waiting a bit more for options to load...");
        await Future.delayed(const Duration(milliseconds: 1000));
        
        // Re-check the IDs after the delay
        final retryDistrictId = state.districtIdByName[state.district];
        final retryRegionId = state.regionIdByName[state.region];
        final retryDivisionId = state.divisionIdByName[state.division];
        final retrySampleId = state.natureIdByName[state.article];
        
        print("🔍 Retry validation - District: '${state.district}' -> ID: $retryDistrictId");
        print("🔍 Retry validation - Region: '${state.region}' -> ID: $retryRegionId");
        print("🔍 Retry validation - Division: '${state.division}' -> ID: $retryDivisionId");
        print("🔍 Retry validation - Article: '${state.article}' -> ID: $retrySampleId");
      }

      // Validate required IDs before submitting
      if (districtId == null) {
        final errorMsg = 'District not found. Please re-select District. Available: ${state.districtOptions.join(", ")}';
        print("❌ $errorMsg");
        emit(state.copyWith(message: errorMsg, apiStatus: ApiStatus.error));
        return;
      }
      if (regionId == null) {
        final errorMsg = 'Region not found. Please re-select Region. Available: ${state.regionOptions.join(", ")}';
        print("❌ $errorMsg");
        emit(state.copyWith(message: errorMsg, apiStatus: ApiStatus.error));
        return;
      }
      if (divisionId == null) {
        final errorMsg = 'Division not found. Please re-select Division. Available: ${state.divisionOptions.join(", ")}';
        print("❌ $errorMsg");
        emit(state.copyWith(message: errorMsg, apiStatus: ApiStatus.error));
        return;
      }
      if (sampleId == null) {
        final errorMsg = 'Nature of Sample not found. Please re-select Nature of Sample. Available: ${state.natureOptions.join(", ")}';
        print("❌ $errorMsg");
        emit(state.copyWith(message: errorMsg, apiStatus: ApiStatus.error));
        return;
      }

      final formData = <String, dynamic>{
        // sample_location_master inputs
        'SenderName': state.senderName,
        'SenderDesignation': state.senderDesignation,
        'DoNumber': state.DONumber,
        'CountryId': 1, // defaulting to India; adjust when you wire Country dropdown
        'StateId': 1,   // defaulting to the active state; replace with selected StateId when available
        'DistrictId': districtId,
        'RegionId': regionId,
        'DivisionId': divisionId,
        'Area': state.area,

        // sample_details inputs
        'SampleCodeNumber': state.sampleCodeNumber.isNotEmpty ? state.sampleCodeNumber : state.sampleCodeData,
        'CollectionDate': state.collectionDate?.toIso8601String(),
        'PlaceOfCollection': state.placeOfCollection,
        'SampleName': state.SampleName,
        'QuantityOfSample': state.QuantitySample,
        'SampleId': sampleId,
        'PreservativeAdded': state.preservativeAdded == true,
        'PreservativeName': state.preservativeName,
        'QuantityOfPreservative': state.preservativeQuantity,
        'WitnessSignature': state.personSignature == true,
        'PaperSlipNumber': state.slipNumber,
        'SignatureOfDo': state.DOSignature == true,
        'WrapperCodeNumber': state.sampleCodeNumber,
        'SealImpression': state.sealImpression == true,
        'SealNumber': state.numberofSeal,
        'MemoFormVI': state.formVI == true,
        'WrapperFormVI': state.FoemVIWrapper == true,
        'Latitude': state.Lattitude.isNotEmpty ? double.tryParse(state.Lattitude) : null,
        'Longitude': state.Longitude.isNotEmpty ? double.tryParse(state.Longitude) : null,
        'SampleIsActive': true,
        'insertedBy': userId,
        'sampleInsertedBy': userId,
      };

      // Log the exact decrypted request we are about to send
      try {
        print('InsertSample request (decrypted JSON): ${jsonEncode(formData)}');
      } catch (_) {
        print('InsertSample request (decrypted) could not be stringified');
      }


      final session = await encryptWithSession(
        data: formData,
        rsaPublicKeyPem: rsaPublicKeyPem,
      );

      // Build lowercase-key payload expected by some endpoints
      final Map<String, String> encryptedPayload = {
        'encryptedData': session.payloadForServer['EncryptedData']!,
        'encryptedAESKey': session.payloadForServer['EncryptedAESKey']!,
        'iv': session.payloadForServer['IV']!,
      };

      // Log the encrypted payload being sent
      try {
        print('InsertSample request (encrypted payload): ${jsonEncode(encryptedPayload)}');
      } catch (_) {
        print('InsertSample request (encrypted) could not be stringified');
      }

      final encryptedResponse = await form6repository.FormSixApi(encryptedPayload);

      if (encryptedResponse != null) {
        print('Encrypted response received: $encryptedResponse');
        String successMessage = 'Form VI data submitted succesfully';
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
          // Expecting InsertSampleResponseDO -> { Success, StatusCode, Message, SerialNo }
          try {
            final Map<String, dynamic> resp = jsonDecode(decrypted) as Map<String, dynamic>;
            final bool success = (resp['Success'] ?? resp['success'] ?? false) == true;
            final String? serialNo = resp['SerialNo']?.toString();
            final String? msg = resp['Message']?.toString();
            if (success) {
              successMessage = serialNo != null && serialNo.isNotEmpty
                  ? (msg != null && msg.isNotEmpty ? '$msg (Serial No: $serialNo)' : 'Submitted (Serial No: $serialNo)')
                  : (msg ?? successMessage);
            } else {
              // if backend returns failure inside 200, show message
              final String err = msg ?? 'Insert failed';
              emit(state.copyWith(message: err, apiStatus: ApiStatus.error));
              return;
            }
          } catch (_) {}

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
            try {
              final Map<String, dynamic> resp = jsonDecode(decryptedFallback) as Map<String, dynamic>;
              final bool success = (resp['Success'] ?? resp['success'] ?? false) == true;
              final String? serialNo = resp['SerialNo']?.toString();
              final String? msg = resp['Message']?.toString();
              if (!success) {
                final String err = msg ?? 'Insert failed';
                emit(state.copyWith(message: err, apiStatus: ApiStatus.error));
                return;
              }
              // success path (fallback)
              successMessage = serialNo != null && serialNo.isNotEmpty
                  ? (msg != null && msg.isNotEmpty ? '$msg (Serial No: $serialNo)' : 'Submitted (Serial No: $serialNo)')
                  : (msg ?? successMessage);
            } catch (_) {}
          } catch (e2) {
            print('Fallback decryption also failed: $e2');
          }
        }

        emit(state.copyWith( 
          message: successMessage,
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

class _ParsedList {
  final List<String> names;
  final Map<String, int> nameToId;
  _ParsedList({required this.names, required this.nameToId});
}


