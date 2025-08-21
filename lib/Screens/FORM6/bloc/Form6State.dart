part of 'Form6Bloc.dart';

class SampleFormState extends Equatable {
  final String senderName;
  final String DONumber;
  final String senderDesignation;
  final String district;
  final List<String> districtOptions;
  final Map<String, int> districtIdByName;
  final String Lattitude;
  final String Longitude;
  final String region;
  final List<String> regionOptions;
  final Map<String, int> regionIdByName;
  final String division;
  final List<String> divisionOptions;
  final Map<String, int> divisionIdByName;
  final String area;
  final String sampleCodeData;
  final DateTime? collectionDate;
  final String placeOfCollection;
  final String SampleName;
  final String QuantitySample;
  final String article;
  final List<String> natureOptions;
  final Map<String, int> natureIdByName;
  final bool? preservativeAdded;
  final String preservativeName;
  final String preservativeQuantity;
  final bool? personSignature;
  final String slipNumber;
  final bool? DOSignature;
  final String sampleCodeNumber;
  final bool? sealImpression;
  final String numberofSeal;
  final bool? formVI;
  final bool? FoemVIWrapper;
  final String message;
  final ApiStatus apiStatus;
  final Map<String, String?> fieldErrors;
  final String lab;
  final List<String> labOptions;
  final Map<String, int> labIdByName;
  final String sendingSampleLocation;

  const SampleFormState({
    this.senderName = '',
    this.DONumber = '',
    this.senderDesignation = '',
    this.district = '',
    this.districtOptions = const [],
    this.districtIdByName = const {},
    this.Longitude = '',
    this.Lattitude = '',
    this.region = '',
    this.regionOptions = const [],
    this.regionIdByName = const {},
    this.division = '',
    this.divisionOptions = const [],
    this.divisionIdByName = const {},
    this.area = '',
    this.sampleCodeData = '',
    this.collectionDate,
    this.placeOfCollection = '',
    this.SampleName = '',
    this.QuantitySample = '',
    this.article = '',
    this.natureOptions = const [],
    this.natureIdByName = const {},
    this.preservativeAdded, // default null
    this.preservativeName = '',
    this.preservativeQuantity = '',
    this.personSignature, // default null
    this.slipNumber = '',
    this.DOSignature, // default null
    this.sampleCodeNumber = '',
    this.sealImpression, // default null
    this.numberofSeal = '',
    this.formVI, // default null
    this.FoemVIWrapper, // default null
    this.message = '',
    this.apiStatus = ApiStatus.initial,
    this.fieldErrors = const {},
    this.lab = '',
    this.labOptions = const [],
    this.labIdByName = const {},
    this.sendingSampleLocation = '',
  });

  SampleFormState copyWith({
    String? senderName,
    String? sampleCodeData,
    String? DONumber,
    String? senderDesignation,
    String? district,
    List<String>? districtOptions,
    Map<String, int>? districtIdByName,
    String? Lattitude,
    String? Longitude,
    String? region,
    List<String>? regionOptions,
    Map<String, int>? regionIdByName,
    String? division,
    List<String>? divisionOptions,
    Map<String, int>? divisionIdByName,
    String? area,
    DateTime? collectionDate,
    String? placeOfCollection,
    String? SampleName,
    String? QuantitySample,
    String? article,
    List<String>? natureOptions,
    Map<String, int>? natureIdByName,
    bool? preservativeAdded,
    String? preservativeName,
    String? preservativeQuantity,
    bool? personSignature,
    String? slipNumber,
    bool? DOSignature,
    String? sampleCodeNumber,
    bool? sealImpression,
    String? numberofSeal,
    bool? formVI,
    bool? FoemVIWrapper,
    final String? message,
    final ApiStatus? apiStatus,
    Map<String, String?>? fieldErrors,
    String? lab,
    List<String>? labOptions,
    Map<String, int>? labIdByName,
    String? sendingSampleLocation,
  }) {
    return SampleFormState(
      senderName: senderName ?? this.senderName,
      sampleCodeData: sampleCodeData ?? this.sampleCodeData,
      DONumber: DONumber ?? this.DONumber,
      senderDesignation: senderDesignation ?? this.senderDesignation,
      district: district ?? this.district,
      districtOptions: districtOptions ?? this.districtOptions,
      districtIdByName: districtIdByName ?? this.districtIdByName,
      Longitude: Longitude ?? this.Longitude,
      Lattitude: Lattitude ?? this.Lattitude,
      region: region ?? this.region,
      regionOptions: regionOptions ?? this.regionOptions,
      regionIdByName: regionIdByName ?? this.regionIdByName,
      division: division ?? this.division,
      divisionOptions: divisionOptions ?? this.divisionOptions,
      divisionIdByName: divisionIdByName ?? this.divisionIdByName,
      area: area ?? this.area,
      collectionDate: collectionDate ?? this.collectionDate,
      placeOfCollection: placeOfCollection ?? this.placeOfCollection,
      SampleName: SampleName ?? this.SampleName,
      QuantitySample: QuantitySample ?? this.QuantitySample,
      article: article ?? this.article,
      natureOptions: natureOptions ?? this.natureOptions,
      natureIdByName: natureIdByName ?? this.natureIdByName,
      preservativeAdded: preservativeAdded ?? this.preservativeAdded,
      preservativeName: preservativeName ?? this.preservativeName,
      preservativeQuantity: preservativeQuantity ?? this.preservativeQuantity,
      personSignature: personSignature ?? this.personSignature,
      slipNumber: slipNumber ?? this.slipNumber,
      DOSignature: DOSignature ?? this.DOSignature,
      sampleCodeNumber: sampleCodeNumber ?? this.sampleCodeNumber,
      sealImpression: sealImpression ?? this.sealImpression,
      numberofSeal: numberofSeal ?? this.numberofSeal,
      formVI: formVI ?? this.formVI,
      FoemVIWrapper: FoemVIWrapper ?? this.FoemVIWrapper,
      message: message ?? this.message,
      apiStatus: apiStatus ?? this.apiStatus,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      lab: lab ?? this.lab,
      labOptions: labOptions ?? this.labOptions,
      labIdByName: labIdByName ?? this.labIdByName,
      sendingSampleLocation: sendingSampleLocation ?? this.sendingSampleLocation,
    );
  }

  @override
  List<Object?> get props => [
    senderName,
    DONumber,
    senderDesignation,
    district,
    districtOptions,
    districtIdByName,
    region,
    regionOptions,
    regionIdByName,
    Lattitude,
    Longitude,
    division,
    divisionOptions,
    divisionIdByName,
    area,
    sampleCodeData,
    collectionDate,
    placeOfCollection,
    SampleName,
    QuantitySample,
    article,
    natureOptions,
    natureIdByName,
    preservativeAdded,
    preservativeName,
    preservativeQuantity,
    personSignature,
    slipNumber,
    DOSignature,
    sampleCodeNumber,
    sealImpression,
    numberofSeal,
    formVI,
    FoemVIWrapper,
    message,
    apiStatus,
    fieldErrors,
    lab,
    labOptions,
    labIdByName,
    sendingSampleLocation,
  ];

  bool get isOtherInfoComplete {
    return senderName.isNotEmpty &&
        senderDesignation.isNotEmpty &&
        DONumber.isNotEmpty &&
        district.isNotEmpty &&
        division.isNotEmpty && // Changed order
        region.isNotEmpty && // Changed order
        area.isNotEmpty &&
        lab.isNotEmpty &&
        sendingSampleLocation.isNotEmpty;
  }

  bool get isSampleInfoComplete {
    return sampleCodeData.isNotEmpty &&
        collectionDate != null &&
        placeOfCollection.isNotEmpty &&
        SampleName.isNotEmpty &&
        QuantitySample.isNotEmpty &&
        article.isNotEmpty &&
        preservativeAdded != null &&
        personSignature != null &&
        slipNumber.isNotEmpty &&
        DOSignature != null &&
        sampleCodeNumber.isNotEmpty &&
        sealImpression != null &&
        numberofSeal.isNotEmpty &&
        formVI != null &&
        FoemVIWrapper != null;
  }

  Map<String, dynamic> toMap() {
    return {
      'senderName': senderName,
      'sampleCodeData': sampleCodeData,
      'DONumber': DONumber,
      'senderDesignation': senderDesignation,
      'district': district,
      'region': region,
      'division': division,
      'area': area,
      'collectionDate': collectionDate?.toIso8601String(),
      'placeOfCollection': placeOfCollection,
      'SampleName': SampleName,
      'QuantitySample': QuantitySample,
      'article': article,
      'preservativeAdded': preservativeAdded == null ? null : (preservativeAdded! ? 1 : 0),
      'preservativeName': preservativeName,
      'preservativeQuantity': preservativeQuantity,
      'personSignature': personSignature == null ? null : (personSignature! ? 1 : 0),
      'slipNumber': slipNumber,
      'DOSignature': DOSignature == null ? null : (DOSignature! ? 1 : 0),
      'sampleCodeNumber': sampleCodeNumber,
      'sealImpression': sealImpression == null ? null : (sealImpression! ? 1 : 0),
      'numberofSeal': numberofSeal,
      'formVI': formVI == null ? null : (formVI! ? 1 : 0),
      'FoemVIWrapper': FoemVIWrapper == null ? null : (FoemVIWrapper! ? 1 : 0),
      'message': message,
      'apiStatus': apiStatus.name,
      'StateId': 1,   // defaulting to the active state; replace with selected StateId when available
      'DistrictId': districtIdByName[district],
      'DivisionId': divisionIdByName[division],
      'RegionId': regionIdByName[region],
      'Area': area,
      'lab': lab,
      'LabId': labIdByName[lab],
      'sendingSampleLocation': sendingSampleLocation,
    };
  }

  factory SampleFormState.fromMap(Map<String, dynamic> map) {
    return SampleFormState(
      senderName: map['senderName'] ?? '',
      sampleCodeData: map['sampleCodeData'] ?? '',
      DONumber: map['DONumber'] ?? '',
      senderDesignation: map['senderDesignation'] ?? '',
      district: map['district'] ?? '',
      region: map['region'] ?? '',
      division: map['division'] ?? '',
      area: map['area'] ?? '',
      collectionDate: map['collectionDate'] != null ? DateTime.tryParse(map['collectionDate']) : null,
      placeOfCollection: map['placeOfCollection'] ?? '',
      SampleName: map['SampleName'] ?? '',
      QuantitySample: map['QuantitySample'] ?? '',
      article: map['article'] ?? '',
      preservativeAdded: map['preservativeAdded'] == null
          ? null
          : map['preservativeAdded'] == 1,
      preservativeName: map['preservativeName'] ?? '',
      preservativeQuantity: map['preservativeQuantity'] ?? '',
      personSignature: map['personSignature'] == null
          ? null
          : map['personSignature'] == 1,
      slipNumber: map['slipNumber'] ?? '',
      DOSignature: map['DOSignature'] == null
          ? null
          : map['DOSignature'] == 1,
      sampleCodeNumber: map['sampleCodeNumber'] ?? '',
      sealImpression: map['sealImpression'] == null
          ? null
          : map['sealImpression'] == 1,
      numberofSeal: map['numberofSeal'] ?? '',
      formVI: map['formVI'] == null
          ? null
          : map['formVI'] == 1,
      FoemVIWrapper: map['FoemVIWrapper'] == null
          ? null
          : map['FoemVIWrapper'] == 1,
      message: map['message'] ?? '',
      apiStatus: ApiStatus.values.firstWhere(
            (e) => e.name == map['apiStatus'],
        orElse: () => ApiStatus.initial,
      ),
      lab: map['lab'] ?? '',
      labOptions: map['labOptions'] != null ? List<String>.from(map['labOptions']) : const [],
      labIdByName: map['labIdByName'] != null ? Map<String, int>.from(map['labIdByName']) : const {},
      sendingSampleLocation: map['sendingSampleLocation'] ?? '',
    );
  }
}
