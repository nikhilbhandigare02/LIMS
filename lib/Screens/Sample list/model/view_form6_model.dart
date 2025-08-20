/// success : true
/// message : "Form6 data fetched successfully."
/// statusCode : 200
/// form6Details : [{"success":1,"message":"Form VI data fetched successfully","statusCode":200,"serialNo":"S001","sampleCodeNumber":"SCN0001","collectionDate":"13-08-2025 10:00:00","placeOfCollection":"Mumbai","sampleName":"Water Sample","quantityOfSample":"500 ml","sampleId":"0","preservativeAdded":"1","preservativeName":"Sodium Thiosulfate","quantityOfPreservative":"5 g","witnessSignature":"1","paperSlipNumber":"PS-001","signatureOfDO":"1","wrapperCodeNumber":"WC-2025-01","sealImpression":"True","sealNumber":"SEAL-001","memoFormVI":"1","wrapperFormVI":"1","latitude":"19.0760","longitude":"72.8777","status":"Sample received by courier/Physically","senderName":"fso aditya","senderDesignation":"FSO","doNumber":"DO-12345","country":"India","state":"Maharashtra","district":"Mumbai","division":"Pimpri-Chinchwad Division","region":"Pune City Region 2","area":"Central Lab Area"}]

class ViewForm6Model {
  ViewForm6Model({
      bool? success, 
      String? message, 
      num? statusCode, 
      List<Form6Details>? form6Details,}){
    _success = success;
    _message = message;
    _statusCode = statusCode;
    _form6Details = form6Details;
}

  ViewForm6Model.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _statusCode = json['statusCode'];
    if (json['form6Details'] != null) {
      _form6Details = [];
      json['form6Details'].forEach((v) {
        _form6Details?.add(Form6Details.fromJson(v));
      });
    }
  }
  bool? _success;
  String? _message;
  num? _statusCode;
  List<Form6Details>? _form6Details;
ViewForm6Model copyWith({  bool? success,
  String? message,
  num? statusCode,
  List<Form6Details>? form6Details,
}) => ViewForm6Model(  success: success ?? _success,
  message: message ?? _message,
  statusCode: statusCode ?? _statusCode,
  form6Details: form6Details ?? _form6Details,
);
  bool? get success => _success;
  String? get message => _message;
  num? get statusCode => _statusCode;
  List<Form6Details>? get form6Details => _form6Details;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    map['statusCode'] = _statusCode;
    if (_form6Details != null) {
      map['form6Details'] = _form6Details?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// success : 1
/// message : "Form VI data fetched successfully"
/// statusCode : 200
/// serialNo : "S001"
/// sampleCodeNumber : "SCN0001"
/// collectionDate : "13-08-2025 10:00:00"
/// placeOfCollection : "Mumbai"
/// sampleName : "Water Sample"
/// quantityOfSample : "500 ml"
/// sampleId : "0"
/// preservativeAdded : "1"
/// preservativeName : "Sodium Thiosulfate"
/// quantityOfPreservative : "5 g"
/// witnessSignature : "1"
/// paperSlipNumber : "PS-001"
/// signatureOfDO : "1"
/// wrapperCodeNumber : "WC-2025-01"
/// sealImpression : "True"
/// sealNumber : "SEAL-001"
/// memoFormVI : "1"
/// wrapperFormVI : "1"
/// latitude : "19.0760"
/// longitude : "72.8777"
/// status : "Sample received by courier/Physically"
/// senderName : "fso aditya"
/// senderDesignation : "FSO"
/// doNumber : "DO-12345"
/// country : "India"
/// state : "Maharashtra"
/// district : "Mumbai"
/// division : "Pimpri-Chinchwad Division"
/// region : "Pune City Region 2"
/// area : "Central Lab Area"

class Form6Details {
  Form6Details({
      num? success, 
      String? message, 
      num? statusCode, 
      String? serialNo, 
      String? sampleCodeNumber, 
      String? collectionDate, 
      String? placeOfCollection, 
      String? sampleName, 
      String? quantityOfSample, 
      String? sampleId, 
      String? preservativeAdded, 
      String? preservativeName, 
      String? quantityOfPreservative, 
      String? witnessSignature, 
      String? paperSlipNumber, 
      String? signatureOfDO, 
      String? wrapperCodeNumber, 
      String? sealImpression, 
      String? sealNumber, 
      String? memoFormVI, 
      String? wrapperFormVI, 
      String? latitude, 
      String? longitude, 
      String? status, 
      String? senderName, 
      String? senderDesignation, 
      String? doNumber, 
      String? country, 
      String? state, 
      String? district, 
      String? division, 
      String? region, 
      String? area,}){
    _success = success;
    _message = message;
    _statusCode = statusCode;
    _serialNo = serialNo;
    _sampleCodeNumber = sampleCodeNumber;
    _collectionDate = collectionDate;
    _placeOfCollection = placeOfCollection;
    _sampleName = sampleName;
    _quantityOfSample = quantityOfSample;
    _sampleId = sampleId;
    _preservativeAdded = preservativeAdded;
    _preservativeName = preservativeName;
    _quantityOfPreservative = quantityOfPreservative;
    _witnessSignature = witnessSignature;
    _paperSlipNumber = paperSlipNumber;
    _signatureOfDO = signatureOfDO;
    _wrapperCodeNumber = wrapperCodeNumber;
    _sealImpression = sealImpression;
    _sealNumber = sealNumber;
    _memoFormVI = memoFormVI;
    _wrapperFormVI = wrapperFormVI;
    _latitude = latitude;
    _longitude = longitude;
    _status = status;
    _senderName = senderName;
    _senderDesignation = senderDesignation;
    _doNumber = doNumber;
    _country = country;
    _state = state;
    _district = district;
    _division = division;
    _region = region;
    _area = area;
}

  Form6Details.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _statusCode = json['statusCode'];
    _serialNo = json['serialNo'];
    _sampleCodeNumber = json['sampleCodeNumber'];
    _collectionDate = json['collectionDate'];
    _placeOfCollection = json['placeOfCollection'];
    _sampleName = json['sampleName'];
    _quantityOfSample = json['quantityOfSample'];
    _sampleId = json['sampleId'];
    _preservativeAdded = json['preservativeAdded'];
    _preservativeName = json['preservativeName'];
    _quantityOfPreservative = json['quantityOfPreservative'];
    _witnessSignature = json['witnessSignature'];
    _paperSlipNumber = json['paperSlipNumber'];
    _signatureOfDO = json['signatureOfDO'];
    _wrapperCodeNumber = json['wrapperCodeNumber'];
    _sealImpression = json['sealImpression'];
    _sealNumber = json['sealNumber'];
    _memoFormVI = json['memoFormVI'];
    _wrapperFormVI = json['wrapperFormVI'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _status = json['status'];
    _senderName = json['senderName'];
    _senderDesignation = json['senderDesignation'];
    _doNumber = json['doNumber'];
    _country = json['country'];
    _state = json['state'];
    _district = json['district'];
    _division = json['division'];
    _region = json['region'];
    _area = json['area'];
  }
  num? _success;
  String? _message;
  num? _statusCode;
  String? _serialNo;
  String? _sampleCodeNumber;
  String? _collectionDate;
  String? _placeOfCollection;
  String? _sampleName;
  String? _quantityOfSample;
  String? _sampleId;
  String? _preservativeAdded;
  String? _preservativeName;
  String? _quantityOfPreservative;
  String? _witnessSignature;
  String? _paperSlipNumber;
  String? _signatureOfDO;
  String? _wrapperCodeNumber;
  String? _sealImpression;
  String? _sealNumber;
  String? _memoFormVI;
  String? _wrapperFormVI;
  String? _latitude;
  String? _longitude;
  String? _status;
  String? _senderName;
  String? _senderDesignation;
  String? _doNumber;
  String? _country;
  String? _state;
  String? _district;
  String? _division;
  String? _region;
  String? _area;
Form6Details copyWith({  num? success,
  String? message,
  num? statusCode,
  String? serialNo,
  String? sampleCodeNumber,
  String? collectionDate,
  String? placeOfCollection,
  String? sampleName,
  String? quantityOfSample,
  String? sampleId,
  String? preservativeAdded,
  String? preservativeName,
  String? quantityOfPreservative,
  String? witnessSignature,
  String? paperSlipNumber,
  String? signatureOfDO,
  String? wrapperCodeNumber,
  String? sealImpression,
  String? sealNumber,
  String? memoFormVI,
  String? wrapperFormVI,
  String? latitude,
  String? longitude,
  String? status,
  String? senderName,
  String? senderDesignation,
  String? doNumber,
  String? country,
  String? state,
  String? district,
  String? division,
  String? region,
  String? area,
}) => Form6Details(  success: success ?? _success,
  message: message ?? _message,
  statusCode: statusCode ?? _statusCode,
  serialNo: serialNo ?? _serialNo,
  sampleCodeNumber: sampleCodeNumber ?? _sampleCodeNumber,
  collectionDate: collectionDate ?? _collectionDate,
  placeOfCollection: placeOfCollection ?? _placeOfCollection,
  sampleName: sampleName ?? _sampleName,
  quantityOfSample: quantityOfSample ?? _quantityOfSample,
  sampleId: sampleId ?? _sampleId,
  preservativeAdded: preservativeAdded ?? _preservativeAdded,
  preservativeName: preservativeName ?? _preservativeName,
  quantityOfPreservative: quantityOfPreservative ?? _quantityOfPreservative,
  witnessSignature: witnessSignature ?? _witnessSignature,
  paperSlipNumber: paperSlipNumber ?? _paperSlipNumber,
  signatureOfDO: signatureOfDO ?? _signatureOfDO,
  wrapperCodeNumber: wrapperCodeNumber ?? _wrapperCodeNumber,
  sealImpression: sealImpression ?? _sealImpression,
  sealNumber: sealNumber ?? _sealNumber,
  memoFormVI: memoFormVI ?? _memoFormVI,
  wrapperFormVI: wrapperFormVI ?? _wrapperFormVI,
  latitude: latitude ?? _latitude,
  longitude: longitude ?? _longitude,
  status: status ?? _status,
  senderName: senderName ?? _senderName,
  senderDesignation: senderDesignation ?? _senderDesignation,
  doNumber: doNumber ?? _doNumber,
  country: country ?? _country,
  state: state ?? _state,
  district: district ?? _district,
  division: division ?? _division,
  region: region ?? _region,
  area: area ?? _area,
);
  num? get success => _success;
  String? get message => _message;
  num? get statusCode => _statusCode;
  String? get serialNo => _serialNo;
  String? get sampleCodeNumber => _sampleCodeNumber;
  String? get collectionDate => _collectionDate;
  String? get placeOfCollection => _placeOfCollection;
  String? get sampleName => _sampleName;
  String? get quantityOfSample => _quantityOfSample;
  String? get sampleId => _sampleId;
  String? get preservativeAdded => _preservativeAdded;
  String? get preservativeName => _preservativeName;
  String? get quantityOfPreservative => _quantityOfPreservative;
  String? get witnessSignature => _witnessSignature;
  String? get paperSlipNumber => _paperSlipNumber;
  String? get signatureOfDO => _signatureOfDO;
  String? get wrapperCodeNumber => _wrapperCodeNumber;
  String? get sealImpression => _sealImpression;
  String? get sealNumber => _sealNumber;
  String? get memoFormVI => _memoFormVI;
  String? get wrapperFormVI => _wrapperFormVI;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get status => _status;
  String? get senderName => _senderName;
  String? get senderDesignation => _senderDesignation;
  String? get doNumber => _doNumber;
  String? get country => _country;
  String? get state => _state;
  String? get district => _district;
  String? get division => _division;
  String? get region => _region;
  String? get area => _area;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    map['statusCode'] = _statusCode;
    map['serialNo'] = _serialNo;
    map['sampleCodeNumber'] = _sampleCodeNumber;
    map['collectionDate'] = _collectionDate;
    map['placeOfCollection'] = _placeOfCollection;
    map['sampleName'] = _sampleName;
    map['quantityOfSample'] = _quantityOfSample;
    map['sampleId'] = _sampleId;
    map['preservativeAdded'] = _preservativeAdded;
    map['preservativeName'] = _preservativeName;
    map['quantityOfPreservative'] = _quantityOfPreservative;
    map['witnessSignature'] = _witnessSignature;
    map['paperSlipNumber'] = _paperSlipNumber;
    map['signatureOfDO'] = _signatureOfDO;
    map['wrapperCodeNumber'] = _wrapperCodeNumber;
    map['sealImpression'] = _sealImpression;
    map['sealNumber'] = _sealNumber;
    map['memoFormVI'] = _memoFormVI;
    map['wrapperFormVI'] = _wrapperFormVI;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['status'] = _status;
    map['senderName'] = _senderName;
    map['senderDesignation'] = _senderDesignation;
    map['doNumber'] = _doNumber;
    map['country'] = _country;
    map['state'] = _state;
    map['district'] = _district;
    map['division'] = _division;
    map['region'] = _region;
    map['area'] = _area;
    return map;
  }

}