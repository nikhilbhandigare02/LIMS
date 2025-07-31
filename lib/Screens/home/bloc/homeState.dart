part of 'homeBloc.dart';

class SampleFormState extends Equatable {
  final String senderName;
  final String sampleCode;
  final String DONumber;
  final String senderDesignation;
  final String district;
  final String region;
  final String division;
  final String area;
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

  const SampleFormState({
    this.senderName = '',
    this.sampleCode = '',
    this.DONumber = '',
    this.senderDesignation = '',
    this.district = '',
    this.region = '',
    this.division = '',
    this.area = '',
    this.collectionDate,
    this.placeOfCollection = '',
    this.SampleName = '',
    this.QuantitySample = '',
    this.article = '',
    this.preservativeAdded ,
    this.preservativeName = '',
    this.preservativeQuantity = '',
    this.personSignature,
    this.slipNumber = '',
    this.DOSignature,
    this.sampleCodeNumber = '',
    this.sealImpression,
    this.numberofSeal = '',
    this.formVI,
    this.FoemVIWrapper,
    this.message = '',
    this.apiStatus = ApiStatus.initial
  });

  SampleFormState copyWith({
    String? senderName,
    String? sampleCode,
    String? DONumber,
    String? senderDesignation,
    String? district,
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
    final ApiStatus? apiStatus
  }) {
    return SampleFormState(
      senderName: senderName ?? this.senderName,
      sampleCode: sampleCode ?? this.sampleCode,
      DONumber: DONumber ?? this.DONumber,
      senderDesignation: senderDesignation ?? this.senderDesignation,
      district: district ?? this.district,
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
        apiStatus: apiStatus ?? this.apiStatus
    );
  }

  @override
  List<Object?> get props => [
    senderName,
    sampleCode,
    DONumber,
    senderDesignation,
    district,
    region,
    division,
    area,
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
    apiStatus
  ];
}
