import 'dart:convert';
import '../bloc/Form6Bloc.dart';
import 'form6_database.dart';

class Form6Storage {
  final db = Form6Database.instance;

  Future<void> saveForm6Data(SampleFormState state) async {
    // Only persist document metadata locally to avoid huge rows
    final List<Map<String, dynamic>> documentsJson = state.uploadedDocs.map((doc) => {
      'name': doc.name,
      'mimeType': doc.mimeType,
      'extension': doc.extension,
      // base64 intentionally omitted from SQLite to prevent CursorWindow overflow
    }).toList();

    final data = {
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
      'isOtherInfoComplete': state.isOtherInfoComplete ? 1 : 0,
      'isSampleInfoComplete': state.isSampleInfoComplete ? 1 : 0,
      // Store dropdown options as JSON strings
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
      'sendingSampleLocation': state.sendingSampleLocation,
      // Store uploaded documents and names
      'uploadedDocuments': jsonEncode(documentsJson),
      'documentNames': jsonEncode(state.uploadedDocs.map((doc) => doc.name).toList()),
      'documentName': state.documentName,
    };

    await db.insertForm6Data(data);
    print("✅ Saved Form6 data to SQLite including ${state.uploadedDocs.length} documents");
  }

  Future<SampleFormState?> fetchStoredState() async {
    final data = await db.fetchForm6Data();
    if (data == null) return null;

    bool? toBool(dynamic val) {
      if (val == null) return null;
      return val == 1;
    }

    // Parse dropdown options from JSON strings
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

    // Parse uploaded documents from JSON string
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
      // Do not restore senderName from local storage; always fetch from secure storage
      senderName: '',
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
      // Restore dropdown options
      districtOptions: parseStringList(data['districtOptions']),
      districtIdByName: parseStringIntMap(data['districtIdByName']),
      regionOptions: parseStringList(data['regionOptions']),
      regionIdByName: parseStringIntMap(data['regionIdByName']),
      divisionOptions: parseStringList(data['divisionOptions']),
      divisionIdByName: parseStringIntMap(data['divisionIdByName']),
      natureOptions: parseStringList(data['natureOptions']),
      natureIdByName: parseStringIntMap(data['natureIdByName']),
      // Add missing fields
      lab: data['lab'] ?? '',
      labOptions: parseStringList(data['labOptions']),
      labIdByName: parseStringIntMap(data['labIdByName']),
      sealNumber: data['sealNumber'] ?? '',
      sealNumberOptions: parseStringList(data['sealNumberOptions']),
      sendingSampleLocation: data['sendingSampleLocation'] ?? '',
      // Do not restore base64 documents from SQLite (we do not store base64)
      uploadedDocs: const [],
      documentNames: parseStringList(data['documentNames']),
      documentName: data['documentName'] ?? '',
    );
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
              for (int i = 0; i < docs.length; i++) {
                final doc = docs[i] as Map<String, dynamic>;
                print('   📄 Document ${i + 1}: ${doc['name']} (${doc['extension'] ?? 'no ext'}) - ${(doc['base64Data'] as String).length} chars base64');
              }
            } catch (e) {
              print('🔑 $key => Error parsing documents: $e');
            }
          } else if (key == 'documentNames' && value != null) {
            try {
              final names = jsonDecode(value as String) as List;
              print('🔑 $key => ${names.join(', ')}');
            } catch (e) {
              print('🔑 $key => Error parsing names: $e');
            }
          } else {
            print('🔑 $key => $value');
          }
        });
      }
    }
  }

  Future<void> markSectionComplete({
    required String section,
    String? subSection,
  }) async {
    final db = await Form6Database.instance.database;
    final Map<String, dynamic>? currentData = await Form6Database.instance.fetchForm6Data();

    if (currentData == null) return;

    final updatedData = Map<String, dynamic>.from(currentData);

    if (section == 'other') {
      updatedData['isOtherInfoComplete'] = 1;
    } else if (section == 'sample') {
      updatedData['isSampleInfoComplete'] = 1;
    }

    await db.delete('form6'); // clear old
    await db.insert('form6', updatedData); // save new
    print("✅ Marked section '$section' as complete");
  }

  Future<void> clearFormData() async {
    await db.clearForm6Data();
    print('🧹 Cleared all form6 data from SQLite');
  }

  Future<void> testDocumentStorage() async {
    print('🧪 Testing document storage...');
    
    // Create a test document
    final testDoc = UploadedDoc(
      name: 'test_document.pdf',
      base64Data: 'dGVzdCBjb250ZW50', // base64 for "test content"
      mimeType: 'application/pdf',
      extension: 'pdf',
    );
    
    // Create a test state
    final testState = SampleFormState(
      senderName: 'Test User',
      uploadedDocs: [testDoc],
      documentNames: [testDoc.name],
    );
    
    // Save the test state
    await saveForm6Data(testState);
    print('✅ Test document saved');
    
    // Retrieve and verify
    final retrievedState = await fetchStoredState();
    if (retrievedState != null && retrievedState.uploadedDocs.isNotEmpty) {
      final retrievedDoc = retrievedState.uploadedDocs.first;
      print('✅ Document retrieved: ${retrievedDoc.name}');
      print('✅ Base64 data length: ${retrievedDoc.base64Data.length}');
      print('✅ Extension: ${retrievedDoc.extension}');
      print('✅ MIME type: ${retrievedDoc.mimeType}');
    } else {
      print('❌ Failed to retrieve test document');
    }
    
    // Clean up
    await clearFormData();
    print('🧹 Test data cleaned up');
  }
}
