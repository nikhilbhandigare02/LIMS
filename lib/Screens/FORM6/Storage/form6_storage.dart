import 'dart:convert';
import 'dart:typed_data';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../bloc/Form6Bloc.dart';
import 'form6_database.dart';

class Form6Storage {
  final db = Form6Database.instance;
  final _secureStorage = FlutterSecureStorage();

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
      'SampleName': state.SampleName,
      'QuantitySample': state.QuantitySample,
      'NumberOfSample': state.NumberOfSample,
      'preservativeAdded': state.preservativeAdded == null ? null : (state.preservativeAdded! ? 1 : 0),
      'preservativeName': state.preservativeName,
      'preservativeQuantity': state.preservativeQuantity,
      'personSignature': state.personSignature == null ? null : (state.personSignature! ? 1 : 0),
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
      'lab': state.lab,
      'labOptions': jsonEncode(state.labOptions),
      'labIdByName': jsonEncode(state.labIdByName),
      'sealNumber': state.sealNumber,
      'sealNumberOptions': jsonEncode(state.sealNumberOptions),
      'doSlipNumbers': state.doSlipNumbers,
      'doSealNumbersOptions': jsonEncode(state.doSealNumbersOptions),
      'doSealNumbersIdByName': jsonEncode(state.doSealNumbersIdByName),

      'uploadedDocuments': jsonEncode(documentsJson),
      'documentNames': jsonEncode(state.uploadedDocs.map((doc) => doc.name).toList()),
      'documentName': state.documentName,
      'Lattitude': state.Lattitude,
      'Longitude': state.Longitude,
      // New additional details fields (vi)-(viii)
      'specialRequestReason': state.specialRequestReason,
      'additionalRelevantInfo': state.additionalRelevantInfo,
      'parametersAsPerFSSAI': state.parametersAsPerFSSAI,
      'additionalTests': state.additionalTests,
    };

    // ✅ Save data per user
    await db.insertForm6Data(data, userId: userIdStr);
    print("✅ Saved Form6 data to FSOLIMS table for user $userId including ${state.uploadedDocs.length} documents");

    // ✅ Persist documents into chunk table
    await _saveDocumentsForUser(userIdStr, state.uploadedDocs);
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

    // Base state from FSOLIMS metadata
    final baseState = SampleFormState(
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
      SampleName: data['SampleName'] ?? '',
      QuantitySample: data['QuantitySample'] ?? '',
      NumberOfSample: data['NumberOfSample'] ?? '',
      preservativeAdded: toBool(data['preservativeAdded']),
      preservativeName: data['preservativeName'] ?? '',
      preservativeQuantity: data['preservativeQuantity'] ?? '',
      personSignature: toBool(data['personSignature']),
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
      lab: data['lab'] ?? '',
      labOptions: parseStringList(data['labOptions']),
      labIdByName: parseStringIntMap(data['labIdByName']),
      sealNumber: data['sealNumber'] ?? '',
      sealNumberOptions: parseStringList(data['sealNumberOptions']),
      doSlipNumbers: data['doSlipNumbers'] ?? '',
      doSealNumbersOptions: parseStringList(data['doSealNumbersOptions']),
      doSealNumbersIdByName: parseStringIntMap(data['doSealNumbersIdByName']),
      uploadedDocs: const [],
      documentNames: parseStringList(data['documentNames']),
      documentName: data['documentName'] ?? '',
      Lattitude: data['Lattitude'] ?? '',
      Longitude: data['Longitude'] ?? '',
      specialRequestReason: data['specialRequestReason'] ?? '',
      additionalRelevantInfo: data['additionalRelevantInfo'] ?? '',
      parametersAsPerFSSAI: data['parametersAsPerFSSAI'] ?? '',
      additionalTests: data['additionalTests'] ?? '',
    );

    // ⬇️ Rehydrate documents from chunk table
    try {
      final rows = await db.fetchDocumentRowsForUser(userId: userIdStr);
      print('🔎 fetchStoredState: found ${rows.length} document chunk rows for user $userIdStr');
      if (rows.isNotEmpty) {
        final Map<int, List<List<int>>> bufferByDoc = {};
        final Map<int, Map<String, Object?>> metaByDoc = {};
        for (final r in rows) {
          final int docIdx = (r['docIndex'] as int);
          final int chunkIdx = (r['chunkIndex'] as int);
          final dynamic raw = r['data'];
          final List<int> chunk = raw is Uint8List ? raw.toList() : (raw as List<int>);
          bufferByDoc.putIfAbsent(docIdx, () => []);
          // Ensure list is large enough
          final list = bufferByDoc[docIdx]!;
          if (list.length <= chunkIdx) {
            list.length = chunkIdx + 1;
          }
          list[chunkIdx] = chunk;
          metaByDoc[docIdx] = r;
        }

        final List<UploadedDoc> docs = [];
        final sortedKeys = bufferByDoc.keys.toList()..sort();
        for (final k in sortedKeys) {
          final parts = bufferByDoc[k]!..removeWhere((e) => e == null);
          final bytes = <int>[];
          for (final p in parts) {
            if (p != null) bytes.addAll(p);
          }
          final meta = metaByDoc[k]!;
          final name = (meta['name'] as String?) ?? '';
          final mimeType = meta['mimeType'] as String?;
          final extension = meta['extension'] as String?;
          final sizeBytes = (meta['sizeBytes'] is int) ? meta['sizeBytes'] as int : null;
          final base64Data = base64Encode(bytes);
          docs.add(UploadedDoc(
            name: name,
            base64Data: base64Data,
            mimeType: mimeType,
            extension: extension,
            sizeBytes: sizeBytes ?? bytes.length,
          ));
        }

        return baseState.copyWith(
          uploadedDocs: docs,
          documentNames: docs.map((d) => d.name).toList(),
        );
      }
    } catch (_) {
      // ignore reconstruction errors, fallback to base state
    }

    return baseState;
  }



  Future<void> clearFormData() async {
    final userId = await getCurrentUserId();
    if (userId == null) throw Exception('User not logged in');

    final uid = userId.toString();
    await db.clearForm6Data(userId: uid);
    await db.clearDocumentsForUser(userId: uid);
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

// Private helpers
extension on Form6Storage {
  Future<void> _saveDocumentsForUser(String userId, List<UploadedDoc> docs) async {
    // Clear existing rows and insert new ones atomically
    final database = await db.database;
    await database.transaction((txn) async {
      await txn.delete('Form6Documents', where: 'userId = ?', whereArgs: [userId]);

      const int maxPerFile = 5 * 1024 * 1024; // 5MB
      const int chunkSize = 1024 * 900; // ~900KB per chunk to be safe
      for (int i = 0; i < docs.length; i++) {
        final d = docs[i];
        if (d.base64Data.isEmpty) continue;
        final bytes = base64Decode(d.base64Data);
        if (bytes.length > maxPerFile) {
          throw Exception('File exceeds 5 MB: ${d.name}');
        }
        int chunkIndex = 0;
        for (int offset = 0; offset < bytes.length; offset += chunkSize) {
          final end = (offset + chunkSize > bytes.length) ? bytes.length : offset + chunkSize;
          final chunk = bytes.sublist(offset, end);
          await txn.insert(
            'Form6Documents',
            {
              'userId': userId,
              'docIndex': i,
              'chunkIndex': chunkIndex,
              'data': Uint8List.fromList(chunk),
              'name': d.name,
              'mimeType': d.mimeType,
              'extension': d.extension,
              'sizeBytes': d.sizeBytes ?? bytes.length,
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
          chunkIndex++;
        }
        print('💾 Saved document ${i + 1}/${docs.length}: ${d.name} (${bytes.length} bytes) in ${chunkIndex} chunk(s)');
      }
    });
  }
}
