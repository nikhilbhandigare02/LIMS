import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../bloc/Form6Bloc.dart';
import 'form6_database.dart';

class Form6Storage {
  final db = Form6Database.instance;
  final _secureStorage = FlutterSecureStorage();

  // 🔹 Get current logged-in userId
  Future<int?> getCurrentUserId() async {
    final String? loginDataJson = await _secureStorage.read(key: 'loginData');
    int? userId;

    if (loginDataJson != null && loginDataJson.isNotEmpty) {
      try {
        final map = jsonDecode(loginDataJson) as Map<String, dynamic>;
        final dynamic uid = map['userId'] ?? map['UserId'] ?? map['user_id'];
        if (uid is int) {
          userId = uid;
        } else if (uid != null) {
          userId = int.tryParse(uid.toString());
        }
      } catch (_) {
        // ignore errors
      }
    }

    return userId;
  }
  Future<void> saveForm6Data(SampleFormState state) async {
    final userId = await getCurrentUserId();
    if (userId == null) throw Exception('User not logged in');
    final userIdStr = userId.toString(); // ✅ convert int to String

    // Only persist document metadata locally to avoid huge rows
    final List<Map<String, dynamic>> documentsJson = state.uploadedDocs.map((doc) => {
      'name': doc.name,
      'mimeType': doc.mimeType,
      'extension': doc.extension,
      // base64 intentionally omitted from SQLite to prevent CursorWindow overflow
    }).toList();

    final Map<String, dynamic> data = {
      'senderName': state.senderName,
      'DONumber': state.DONumber,
      'senderDesignation': state.senderDesignation,
      'district': state.district,
      'region': state.region,
      'division': state.division,
      'area': state.area,
      'sampleCodeData': state.sampleCodeData,
      'collectionDate': state.collectionDate?.toIso8601String(),
      'placeOfCollection': state.placeOfCollection,
      'SampleName': state.SampleName,
      'QuantitySample': state.QuantitySample,
      'article': state.article,
      'preservativeAdded': state.preservativeAdded == null ? null : (state.preservativeAdded! ? 1 : 0),
      'preservativeName': state.preservativeName,
      'preservativeQuantity': state.preservativeQuantity,
      'personSignature': state.personSignature == null ? null : (state.personSignature! ? 1 : 0),
      'slipNumber': state.slipNumber,
      'DOSignature': state.DOSignature == null ? null : (state.DOSignature! ? 1 : 0),
      'sampleCodeNumber': state.sampleCodeNumber,
      'sealImpression': state.sealImpression == null ? null : (state.sealImpression! ? 1 : 0),
      'numberofSeal': state.numberofSeal,
      'formVI': state.formVI == null ? null : (state.formVI! ? 1 : 0),
      'FoemVIWrapper': state.FoemVIWrapper == null ? null : (state.FoemVIWrapper! ? 1 : 0),
      'districtOptions': jsonEncode(state.districtOptions),
      'districtIdByName': jsonEncode(state.districtIdByName),
      'regionOptions': jsonEncode(state.regionOptions),
      'regionIdByName': jsonEncode(state.regionIdByName),
      'divisionOptions': jsonEncode(state.divisionOptions),
      'divisionIdByName': jsonEncode(state.divisionIdByName),
      'natureOptions': jsonEncode(state.natureOptions),
      'natureIdByName': jsonEncode(state.natureIdByName),
      'lab': state.lab,
      'labOptions': jsonEncode(state.labOptions),
      'labIdByName': jsonEncode(state.labIdByName),
      'sealNumber': state.sealNumber,
      'sealNumberOptions': jsonEncode(state.sealNumberOptions),
      'doSlipNumbers': state.doSlipNumbers,
      'doSealNumbersOptions': jsonEncode(state.doSealNumbersOptions),
      'doSealNumbersIdByName': jsonEncode(state.doSealNumbersIdByName),
      'sendingSampleLocation': state.sendingSampleLocation,
      'uploadedDocuments': jsonEncode(documentsJson),
      'documentNames': jsonEncode(state.uploadedDocs.map((doc) => doc.name).toList()),
      'documentName': state.documentName,
      'Lattitude': state.Lattitude,
      'Longitude': state.Longitude,
    };

    // ✅ Save data per user
    await db.insertForm6Data(data, userId: userIdStr);
    print("✅ Saved Form6 data to FSOLIMS table for user $userId including ${state.uploadedDocs.length} documents");
  }

  Future<SampleFormState?> fetchStoredState() async {
    final userId = await getCurrentUserId();
    if (userId == null) throw Exception('User not logged in');
    final userIdStr = userId.toString();
    if (userId == null) return null;

    final data = await db.fetchForm6Data(userId: userIdStr);
    if (data == null) return null;

    bool? toBool(dynamic val) {
      if (val == null) return null;
      return val == 1;
    }

    List<String> parseStringList(String? jsonStr) {
      if (jsonStr == null || jsonStr.isEmpty) return [];
      try {
        final List<dynamic> parsed = jsonDecode(jsonStr);
        return parsed.cast<String>();
      } catch (_) {
        return [];
      }
    }

    Map<String, int> parseStringIntMap(String? jsonStr) {
      if (jsonStr == null || jsonStr.isEmpty) return {};
      try {
        final Map<String, dynamic> parsed = jsonDecode(jsonStr);
        return parsed.map((key, value) => MapEntry(key, value as int));
      } catch (_) {
        return {};
      }
    }

    List<UploadedDoc> parseDocuments(String? jsonStr) {
      if (jsonStr == null || jsonStr.isEmpty) return [];
      try {
        final List<dynamic> parsed = jsonDecode(jsonStr);
        return parsed.map((docMap) => UploadedDoc.fromMap(docMap)).toList();
      } catch (_) {
        return [];
      }
    }

    return SampleFormState(
      senderName: data['senderName'] ?? '',
      DONumber: data['DONumber'] ?? '',
      senderDesignation: data['senderDesignation'] ?? '',
      district: data['district'] ?? '',
      region: data['region'] ?? '',
      division: data['division'] ?? '',
      area: data['area'] ?? '',
      sampleCodeData: data['sampleCodeData'] ?? '',
      collectionDate: data['collectionDate'] != null
          ? DateTime.tryParse(data['collectionDate'])
          : null,
      placeOfCollection: data['placeOfCollection'] ?? '',
      SampleName: data['SampleName'] ?? '',
      QuantitySample: data['QuantitySample'] ?? '',
      article: data['article'] ?? '',
      preservativeAdded: toBool(data['preservativeAdded']),
      preservativeName: data['preservativeName'] ?? '',
      preservativeQuantity: data['preservativeQuantity'] ?? '',
      personSignature: toBool(data['personSignature']),
      slipNumber: data['slipNumber'] ?? '',
      DOSignature: toBool(data['DOSignature']),
      sampleCodeNumber: data['sampleCodeNumber'] ?? '',
      sealImpression: toBool(data['sealImpression']),
      numberofSeal: data['numberofSeal'] ?? '',
      formVI: toBool(data['formVI']),
      FoemVIWrapper: toBool(data['FoemVIWrapper']),
      districtOptions: parseStringList(data['districtOptions']),
      districtIdByName: parseStringIntMap(data['districtIdByName']),
      regionOptions: parseStringList(data['regionOptions']),
      regionIdByName: parseStringIntMap(data['regionIdByName']),
      divisionOptions: parseStringList(data['divisionOptions']),
      divisionIdByName: parseStringIntMap(data['divisionIdByName']),
      natureOptions: parseStringList(data['natureOptions']),
      natureIdByName: parseStringIntMap(data['natureIdByName']),
      lab: data['lab'] ?? '',
      labOptions: parseStringList(data['labOptions']),
      labIdByName: parseStringIntMap(data['labIdByName']),
      sealNumber: data['sealNumber'] ?? '',
      sealNumberOptions: parseStringList(data['sealNumberOptions']),
      doSlipNumbers: data['doSlipNumbers'] ?? '',
      doSealNumbersOptions: parseStringList(data['doSealNumbersOptions']),
      doSealNumbersIdByName: parseStringIntMap(data['doSealNumbersIdByName']),
      sendingSampleLocation: data['sendingSampleLocation'] ?? '',
      uploadedDocs: const [],
      documentNames: parseStringList(data['documentNames']),
      documentName: data['documentName'] ?? '',
      Lattitude: data['Lattitude'] ?? '',
      Longitude: data['Longitude'] ?? '',
    );
  }



  Future<void> clearFormData() async {
    final userId = await getCurrentUserId();
    if (userId == null) throw Exception('User not logged in');

    await db.clearForm6Data(userId: userId.toString());
    print('🧹 Cleared form6 data for user $userId from SQLite');
  }


  Future<void> printAllStoredData() async {
    final result = await db.queryAll();
    if (result.isEmpty) {
      print('📭 SQLite form6 table is empty.');
    } else {
      print('📦 Form6 Stored Data:');
      for (var row in result) {
        row.forEach((key, value) {
          if (key == 'uploadedDocuments' && value != null) {
            try {
              final docs = jsonDecode(value as String) as List;
              print('🔑 $key => ${docs.length} documents stored');
            } catch (_) {}
          } else if (key == 'documentNames' && value != null) {
            try {
              final names = jsonDecode(value as String) as List;
              print('🔑 $key => ${names.join(', ')}');
            } catch (_) {}
          } else {
            print('🔑 $key => $value');
          }
        });
      }
    }
  }

  Future<void> testDocumentStorage() async {
    print('🧪 Testing document storage...');

    final testDoc = UploadedDoc(
      name: 'test_document.pdf',
      base64Data: 'dGVzdCBjb250ZW50',
      mimeType: 'application/pdf',
      extension: 'pdf',
    );

    final testState = SampleFormState(
      senderName: 'Test User',
      uploadedDocs: [testDoc],
      documentNames: [testDoc.name],
    );

    await saveForm6Data(testState);

    final retrievedState = await fetchStoredState();
    if (retrievedState != null) {
      print('✅ Test document retrieved for user');
    } else {
      print('❌ Failed to retrieve test document');
    }

    await clearFormData();
  }
}
