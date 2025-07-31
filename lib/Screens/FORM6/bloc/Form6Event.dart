part of 'Form6Bloc.dart';

abstract class SampleFormEvent extends Equatable {
  const SampleFormEvent();
  @override
  List<Object?> get props => [];
}

class SampleCodeChanged extends SampleFormEvent {
  final String value;
  const SampleCodeChanged(this.value);
  @override
  List<Object?> get props => [];
}

class senderNameChanged extends SampleFormEvent {
  final String value;
  const senderNameChanged(this.value);
  @override
  List<Object?> get props => [];
}

class DistrictChanged extends SampleFormEvent {
  final String? value;
  const DistrictChanged(this.value);
  @override
  List<Object?> get props => [];
}

class RegionChanged extends SampleFormEvent {
  final String? value;
  const RegionChanged(this.value);
  @override
  List<Object?> get props => [];
}

class DivisionChanged extends SampleFormEvent {
  final String? value;
  const DivisionChanged(this.value);
  @override
  List<Object?> get props => [];
}

class AreaChanged extends SampleFormEvent {
  final String? value;
  const AreaChanged(this.value);
  @override
  List<Object?> get props => [];
}

class CollectionDateChanged extends SampleFormEvent {
  final DateTime value;
  const CollectionDateChanged(this.value);
  @override
  List<Object?> get props => [];
}

class PlaceChanged extends SampleFormEvent {
  final String value;
  const PlaceChanged(this.value);
  @override
  List<Object?> get props => [];
}

class SampleNameChanged extends SampleFormEvent {
  final String value;
  const SampleNameChanged(this.value);
  @override
  List<Object?> get props => [];
}

class QuantitySampleChanged extends SampleFormEvent {
  final String value;
  const QuantitySampleChanged(this.value);
  @override
  List<Object?> get props => [];
}

class articleChanged extends SampleFormEvent {
  final String? value;
  const articleChanged(this.value);
  @override
  List<Object?> get props => [];
}

class PreservativeAddedChanged extends SampleFormEvent {
  final bool value;
  const PreservativeAddedChanged(this.value);
  @override
  List<Object?> get props => [];
}

class preservativeNameChanged extends SampleFormEvent {
  final String value;
  const preservativeNameChanged(this.value);
  @override
  List<Object?> get props => [];
}

class preservativeQuantityChanged extends SampleFormEvent {
  final String value;
  const preservativeQuantityChanged(this.value);
  @override
  List<Object?> get props => [];
}

class personSignatureChanged extends SampleFormEvent {
  final bool value;
  const personSignatureChanged(this.value);
  @override
  List<Object?> get props => [];
}

class slipNumberChanged extends SampleFormEvent {
  final String value;
  const slipNumberChanged(this.value);
  @override
  List<Object?> get props => [];
}

class DOSignatureChanged extends SampleFormEvent {
  final bool value;
  const DOSignatureChanged(this.value);
  @override
  List<Object?> get props => [];
}

class sampleCodeNumberChanged extends SampleFormEvent {
  final String value;
  const sampleCodeNumberChanged(this.value);
  @override
  List<Object?> get props => [];
}
class senderDesignationChanged extends SampleFormEvent {
  final String value;
  const senderDesignationChanged(this.value);
  @override
  List<Object?> get props => [];
}
class DONumberChanged extends SampleFormEvent {
  final String value;
  const DONumberChanged(this.value);
  @override
  List<Object?> get props => [];
}

class sealImpressionChanged extends SampleFormEvent {
  final bool value;
  const sealImpressionChanged(this.value);
  @override
  List<Object?> get props => [];
}

class numberofSealChanged extends SampleFormEvent {
  final String value;
  const numberofSealChanged(this.value);
  @override
  List<Object?> get props => [];
}

class formVIChanged extends SampleFormEvent {
  final bool value;
  const formVIChanged(this.value);
  @override
  List<Object?> get props => [];
}

class FoemVIWrapperChanged extends SampleFormEvent {
  final bool value;
  const FoemVIWrapperChanged(this.value);
  @override
  List<Object?> get props => [];
}

class FormSubmit extends SampleFormEvent {}
