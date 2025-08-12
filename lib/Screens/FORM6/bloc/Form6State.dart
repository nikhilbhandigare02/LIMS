part of 'Form6Bloc.dart';

class SampleFormState extends Equatable {
  final String senderName;
  final String DONumber;
  final String senderDesignation;
  final String district;
  final String Lattitude;
  final String Longitude;
  final String region;
  final String division;
  final String area;
  final String sampleCodeData;
  final DateTime? collectionDate;
  final String placeOfCollection;
  final String SampleName;
  final String QuantitySample;
  final String article;
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

  const SampleFormState({
    this.senderName = '',
    this.DONumber = '',
    this.senderDesignation = '',
    this.district = '',
    this.Longitude = '',
    this.Lattitude = '',
    this.region = '',
    this.division = '',
    this.area = '',
    this.sampleCodeData = '',
    this.collectionDate,
    this.placeOfCollection = '',
    this.SampleName = '',
    this.QuantitySample = '',
    this.article = '',
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
  });

  SampleFormState copyWith({
    String? senderName,
    String? sampleCodeData,
    String? DONumber,
    String? senderDesignation,
    String? district,
    String? Lattitude,
    String? Longitude,
    String? region,
    String? division,
    String? area,
    DateTime? collectionDate,
    String? placeOfCollection,
    String? SampleName,
    String? QuantitySample,
    String? article,
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
  }) {
    return SampleFormState(
      senderName: senderName ?? this.senderName,
      sampleCodeData: sampleCodeData ?? this.sampleCodeData,
      DONumber: DONumber ?? this.DONumber,
      senderDesignation: senderDesignation ?? this.senderDesignation,
      district: district ?? this.district,
      Longitude: Longitude ?? this.Longitude,
      Lattitude: Lattitude ?? this.Lattitude,
      region: region ?? this.region,
      division: division ?? this.division,
      area: area ?? this.area,
      collectionDate: collectionDate ?? this.collectionDate,
      placeOfCollection: placeOfCollection ?? this.placeOfCollection,
      SampleName: SampleName ?? this.SampleName,
      QuantitySample: QuantitySample ?? this.QuantitySample,
      article: article ?? this.article,
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
    );
  }

  @override
  List<Object?> get props => [
    senderName,
    DONumber,
    senderDesignation,
    district,
    region,
    Lattitude,
    Longitude,
    division,
    area,
    sampleCodeData,
    collectionDate,
    placeOfCollection,
    SampleName,
    QuantitySample,
    article,
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
  ];

  bool get isOtherInfoComplete {
    return senderName.isNotEmpty &&
        senderDesignation.isNotEmpty &&
        DONumber.isNotEmpty &&
        district.isNotEmpty &&
        region.isNotEmpty &&
        division.isNotEmpty &&
        area.isNotEmpty;
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
    );
  }
}
