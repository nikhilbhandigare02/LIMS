import '../bloc/Form6Bloc.dart';
import 'form6_database.dart';

class Form6Storage {
  final db = Form6Database.instance;

  Future<void> saveForm6Data(SampleFormState state) async {
    final data = {
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
      'isOtherInfoComplete': state.isOtherInfoComplete ? 1 : 0,
      'isSampleInfoComplete': state.isSampleInfoComplete ? 1 : 0,
    };

    await db.insertForm6Data(data);
    print("✅ Saved Form6 data to SQLite");
  }

  Future<SampleFormState?> fetchStoredState() async {
    final data = await db.fetchForm6Data();
    if (data == null) return null;

    bool? toBool(dynamic val) {
      if (val == null) return null;
      return val == 1;
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
          print('🔑 $key => $value');
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
}
