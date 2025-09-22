/// success : true
/// message : "Form6 data fetched successfully."
/// statusCode : 200
/// form6Details : [{"success":1,"message":"Form VI data fetched successfully","statusCode":200,"serialNo":"LIMS_337","sampleCodeNumber":"56","collectionDate":"19-09-2025 16:41:12","placeOfCollection":"dh","sampleName":"rh","quantityOfSample":"dh","natureOfSample":"Loose","preservativeAdded":"0","preservativeName":"","quantityOfPreservative":"","witnessSignature":"0","signatureOfDO":"0","wrapperCodeNumber":"56","sealImpression":"False","sealNumber":"56","memoFormVI":"0","wrapperFormVI":"0","latitude":"19.217273","longitude":"72.9804205","status":"Sample Assigned to Analyst","senderName":"Aditya FSO","senderDesignation":"Food Safety Officer","doNumber":"65","country":"India","state":"Maharashtra","district":"Pune","division":"Pune City Division","region":"Pune City Region 1","area":"hd","slip_number":"asdasdasd","documentName":null,"documentUrl":"[{\"DocumentName\":\"62b97e6953c65bae2efa492e-lab_report-b5c059d4-873c-4d03-87ec-6aeb87d6a667.pdf\",\"DocumentUrl\":\"http://103.118.17.144:803/ViewDocument/2025\\September/62b97e6953c65bae2efa492e-lab_report-b5c059d4-873c-4d03-87ec-6aeb87d6a667.pdf\"},{\"DocumentName\":\"Screenshot_2025-09-15-18-40-32-422_io.mlite.credit_Access(1)(2)(3).jpg\",\"DocumentUrl\":\"http://103.118.17.144:803/ViewDocument/2025\\September/Screenshot_2025-09-15-18-40-32-422_io.mlite.credit_Access(1)(2)(3).jpg\"}]"}]

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
/// serialNo : "LIMS_337"
/// sampleCodeNumber : "56"
/// collectionDate : "19-09-2025 16:41:12"
/// placeOfCollection : "dh"
/// sampleName : "rh"
/// quantityOfSample : "dh"
/// natureOfSample : "Loose"
/// preservativeAdded : "0"
/// preservativeName : ""
/// quantityOfPreservative : ""
/// witnessSignature : "0"
/// signatureOfDO : "0"
/// wrapperCodeNumber : "56"
/// sealImpression : "False"
/// sealNumber : "56"
/// memoFormVI : "0"
/// wrapperFormVI : "0"
/// latitude : "19.217273"
/// longitude : "72.9804205"
/// status : "Sample Assigned to Analyst"
/// senderName : "Aditya FSO"
/// senderDesignation : "Food Safety Officer"
/// doNumber : "65"
/// country : "India"
/// state : "Maharashtra"
/// district : "Pune"
/// division : "Pune City Division"
/// region : "Pune City Region 1"
/// area : "hd"
/// slip_number : "asdasdasd"
/// documentName : null
/// documentUrl : "[{\"DocumentName\":\"62b97e6953c65bae2efa492e-lab_report-b5c059d4-873c-4d03-87ec-6aeb87d6a667.pdf\",\"DocumentUrl\":\"http://103.118.17.144:803/ViewDocument/2025\\September/62b97e6953c65bae2efa492e-lab_report-b5c059d4-873c-4d03-87ec-6aeb87d6a667.pdf\"},{\"DocumentName\":\"Screenshot_2025-09-15-18-40-32-422_io.mlite.credit_Access(1)(2)(3).jpg\",\"DocumentUrl\":\"http://103.118.17.144:803/ViewDocument/2025\\September/Screenshot_2025-09-15-18-40-32-422_io.mlite.credit_Access(1)(2)(3).jpg\"}]"

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
      String? natureOfSample, 
      String? preservativeAdded, 
      String? preservativeName, 
      String? quantityOfPreservative, 
      String? witnessSignature, 
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
      String? slipNumber, 
      dynamic documentName, 
      String? documentUrl,}){
    _success = success;
    _message = message;
    _statusCode = statusCode;
    _serialNo = serialNo;
    _sampleCodeNumber = sampleCodeNumber;
    _collectionDate = collectionDate;
    _placeOfCollection = placeOfCollection;
    _sampleName = sampleName;
    _quantityOfSample = quantityOfSample;
    _natureOfSample = natureOfSample;
    _preservativeAdded = preservativeAdded;
    _preservativeName = preservativeName;
    _quantityOfPreservative = quantityOfPreservative;
    _witnessSignature = witnessSignature;
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
    _slipNumber = slipNumber;
    _documentName = documentName;
    _documentUrl = documentUrl;
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
    _natureOfSample = json['natureOfSample'];
    _preservativeAdded = json['preservativeAdded'];
    _preservativeName = json['preservativeName'];
    _quantityOfPreservative = json['quantityOfPreservative'];
    _witnessSignature = json['witnessSignature'];
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
    _slipNumber = json['slip_number'];
    _documentName = json['documentName'];
    _documentUrl = json['documentUrl'];
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
  String? _natureOfSample;
  String? _preservativeAdded;
  String? _preservativeName;
  String? _quantityOfPreservative;
  String? _witnessSignature;
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
  String? _slipNumber;
  dynamic _documentName;
  String? _documentUrl;
Form6Details copyWith({  num? success,
  String? message,
  num? statusCode,
  String? serialNo,
  String? sampleCodeNumber,
  String? collectionDate,
  String? placeOfCollection,
  String? sampleName,
  String? quantityOfSample,
  String? natureOfSample,
  String? preservativeAdded,
  String? preservativeName,
  String? quantityOfPreservative,
  String? witnessSignature,
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
  String? slipNumber,
  dynamic documentName,
  String? documentUrl,
}) => Form6Details(  success: success ?? _success,
  message: message ?? _message,
  statusCode: statusCode ?? _statusCode,
  serialNo: serialNo ?? _serialNo,
  sampleCodeNumber: sampleCodeNumber ?? _sampleCodeNumber,
  collectionDate: collectionDate ?? _collectionDate,
  placeOfCollection: placeOfCollection ?? _placeOfCollection,
  sampleName: sampleName ?? _sampleName,
  quantityOfSample: quantityOfSample ?? _quantityOfSample,
  natureOfSample: natureOfSample ?? _natureOfSample,
  preservativeAdded: preservativeAdded ?? _preservativeAdded,
  preservativeName: preservativeName ?? _preservativeName,
  quantityOfPreservative: quantityOfPreservative ?? _quantityOfPreservative,
  witnessSignature: witnessSignature ?? _witnessSignature,
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
  slipNumber: slipNumber ?? _slipNumber,
  documentName: documentName ?? _documentName,
  documentUrl: documentUrl ?? _documentUrl,
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
  String? get natureOfSample => _natureOfSample;
  String? get preservativeAdded => _preservativeAdded;
  String? get preservativeName => _preservativeName;
  String? get quantityOfPreservative => _quantityOfPreservative;
  String? get witnessSignature => _witnessSignature;
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
  String? get slipNumber => _slipNumber;
  dynamic get documentName => _documentName;
  String? get documentUrl => _documentUrl;

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
    map['natureOfSample'] = _natureOfSample;
    map['preservativeAdded'] = _preservativeAdded;
    map['preservativeName'] = _preservativeName;
    map['quantityOfPreservative'] = _quantityOfPreservative;
    map['witnessSignature'] = _witnessSignature;
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
    map['slip_number'] = _slipNumber;
    map['documentName'] = _documentName;
    map['documentUrl'] = _documentUrl;
    return map;
  }

}