part of 'Form6Bloc.dart';

abstract class SampleFormEvent extends Equatable {
  const SampleFormEvent();
  @override
  List<Object?> get props => [];
}

class SampleCodeDataChanged extends SampleFormEvent {
  final String value;
  const SampleCodeDataChanged(this.value);
  @override
  List<Object?> get props => [value];
}
class UpdateValidationErrors extends SampleFormEvent {
  final Map<String, String?> errors;

  const UpdateValidationErrors(this.errors);

  @override
  List<Object?> get props => [errors];
}

class senderNameChanged extends SampleFormEvent {
  final String value;
  const senderNameChanged(this.value);
  @override
  List<Object?> get props => [value];
}
class Lattitude extends SampleFormEvent {
  final String value;
  const Lattitude(this.value);
  @override
  List<Object?> get props => [value];
}
class Longitude extends SampleFormEvent {
  final String value;
  const Longitude(this.value);
  @override
  List<Object?> get props => [value];
}

class DistrictChanged extends SampleFormEvent {
  final String? value;
  const DistrictChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class RegionChanged extends SampleFormEvent {
  final String? value;
  const RegionChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class DivisionChanged extends SampleFormEvent {
  final String? value;
  const DivisionChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class AreaChanged extends SampleFormEvent {
  final String? value;
  const AreaChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class CollectionDateChanged extends SampleFormEvent {
  final DateTime value;
  const CollectionDateChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class PlaceChanged extends SampleFormEvent {
  final String value;
  const PlaceChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class SampleNameChanged extends SampleFormEvent {
  final String value;
  const SampleNameChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class QuantitySampleChanged extends SampleFormEvent {
  final String value;
  const QuantitySampleChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class articleChanged extends SampleFormEvent {
  final String? value;
  const articleChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class FetchNatureOfSampleRequested extends SampleFormEvent {
  final int? categoryId; // optional filter if backend supports
  const FetchNatureOfSampleRequested({this.categoryId});
  @override
  List<Object?> get props => [categoryId];
}

class PreservativeAddedChanged extends SampleFormEvent {
  final bool? value;
  const PreservativeAddedChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class preservativeNameChanged extends SampleFormEvent {
  final String value;
  const preservativeNameChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class preservativeQuantityChanged extends SampleFormEvent {
  final String value;
  const preservativeQuantityChanged(this.value);
  List<Object?> get props => [value];

}
class LoadSavedFormData extends SampleFormEvent {
  final SampleFormState savedState;

  LoadSavedFormData(this.savedState);
  @override
  List<Object?> get props => [];
}

class personSignatureChanged extends SampleFormEvent {
  final bool? value;
  const personSignatureChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class slipNumberChanged extends SampleFormEvent {
  final String value;
  const slipNumberChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class DOSignatureChanged extends SampleFormEvent {
  final bool? value;
  const DOSignatureChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class sampleCodeNumberChanged extends SampleFormEvent {
  final String value;
  const sampleCodeNumberChanged(this.value);
  @override
  List<Object?> get props => [value];
}
class senderDesignationChanged extends SampleFormEvent {
  final String value;
  const senderDesignationChanged(this.value);
  @override
  List<Object?> get props => [value];
}
class DONumberChanged extends SampleFormEvent {
  final String value;
  const DONumberChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class sealImpressionChanged extends SampleFormEvent {
  final bool? value;
  const sealImpressionChanged(this.value);
  @override
  List<Object?> get props => [value];
}
class ResetForm6Event extends SampleFormEvent{}
class numberofSealChanged extends SampleFormEvent {
  final String value;
  const numberofSealChanged(this.value);
  @override
  List<Object?> get props => [value];
}
class documentNameChangedEvent extends SampleFormEvent {
  final String value;
  const documentNameChangedEvent(this.value);
  @override
  List<Object?> get props => [value];
}
class UploadDocumentEvent extends SampleFormEvent {
  final String value;
  const UploadDocumentEvent(this.value);
  @override
  List<Object?> get props => [value];
}

class AddUploadedDocuments extends SampleFormEvent {
  final List<UploadedDoc> documents;
  const AddUploadedDocuments(this.documents);
  @override
  List<Object?> get props => [documents];
}

class RemoveUploadedDocument extends SampleFormEvent {
  final int index;
  const RemoveUploadedDocument(this.index);
  @override
  List<Object?> get props => [index];
}
class UpdateFormField extends SampleFormEvent {
  final String field;
  final dynamic value;

  const UpdateFormField({required this.field, required this.value});

  @override
  List<Object?> get props => [field, value];
}

class formVIChanged extends SampleFormEvent {
  final bool? value;
  const formVIChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class FoemVIWrapperChanged extends SampleFormEvent {
  final bool? value;
  const FoemVIWrapperChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class FormSubmit extends SampleFormEvent {}
class FormResetEvent extends SampleFormEvent {}
class FetchLocationRequested extends SampleFormEvent {}

class FetchDistrictsRequested extends SampleFormEvent {
  final int stateId;
  const FetchDistrictsRequested(this.stateId);
  @override
  List<Object?> get props => [stateId];
}

class FetchRegionsRequested extends SampleFormEvent {
  final int divisionId;
  const FetchRegionsRequested(this.divisionId);
  @override
  List<Object?> get props => [divisionId];
}

class FetchDivisionsRequested extends SampleFormEvent {
  final int districtId;
  const FetchDivisionsRequested(this.districtId);
  @override
  List<Object?> get props => [districtId];
}

class FetchLabMasterRequested extends SampleFormEvent {
  const FetchLabMasterRequested();
}

class LabChanged extends SampleFormEvent {
  final String? value;
  const LabChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class SendingSampleLocationChanged extends SampleFormEvent {
  final String value;
  const SendingSampleLocationChanged(this.value);
  @override
  List<Object?> get props => [value];
}
class SealNumberChanged extends SampleFormEvent {
  final String? value;
  const SealNumberChanged(this.value);
  @override
  List<Object?> get props => [value];
}
class FetchSealNumberChanged extends SampleFormEvent {
  const FetchSealNumberChanged();
}
