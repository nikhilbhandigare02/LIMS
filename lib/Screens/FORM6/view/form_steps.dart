import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/HomeWidgets/HomeWidgets.dart';
import '../bloc/Form6Bloc.dart';

List<List<Widget>> getOtherInformationSteps(SampleFormState state, SampleFormBloc bloc) => [
  [
    BlocTextInput(label: "Name of Sender", initialValue: state.senderName, onChanged: (val) => bloc.add(senderNameChanged(val))),
    SizedBox(height: 16,),
    BlocTextInput(label: "Sender Official Designation", initialValue: state.senderDesignation, onChanged: (val) => bloc.add(senderDesignationChanged(val))),
    SizedBox(height: 16,),
    BlocTextInput(label: "DO Number", initialValue: state.DONumber, onChanged: (val) => bloc.add(DONumberChanged(val))),
    SizedBox(height: 16,),
    BlocDropdown(label: "District", value: state.district ?? '', items: ["Kolhapur", "Thane", "Pune", "Mumbai"], onChanged: (val) => bloc.add(DistrictChanged(val))),
    SizedBox(height: 16,),
    BlocDropdown(label: "Region", value: state.region, items: ["East", "West"], onChanged: (val) => bloc.add(RegionChanged(val))),
    SizedBox(height: 16,),
    BlocDropdown(label: "Division", value: state.division, items: ["Div1", "Div2"], onChanged: (val) => bloc.add(DivisionChanged(val))),
    SizedBox(height: 16,),
    BlocDropdown(label: "Area", value: state.area, items: ["Urban", "Rural"], onChanged: (val) => bloc.add(AreaChanged(val))),
  ],

];

List<List<Widget>> getSampleDetailsSteps(SampleFormState state, SampleFormBloc bloc) => [
  [
    BlocTextInput(label: "Sample Code Number", initialValue: state.sampleCode, onChanged: (val) => bloc.add(SampleCodeChanged(val))),
    SizedBox(height: 16,),

    BlocDatePicker(label: "Date of Collection", selectedDate: state.collectionDate, onChanged: (date) => bloc.add(CollectionDateChanged(date))),
    SizedBox(height: 16,),

    BlocTextInput(label: "Place of Collection", initialValue: state.placeOfCollection, onChanged: (val) => bloc.add(PlaceChanged(val))),
    SizedBox(height: 16,),

    BlocTextInput(label: "Sample Name", initialValue: state.SampleName, onChanged: (val) => bloc.add(SampleNameChanged(val))),
    SizedBox(height: 16,),

    BlocTextInput(label: "Quantity of Sample", initialValue: state.QuantitySample, onChanged: (val) => bloc.add(QuantitySampleChanged(val))),
    SizedBox(height: 16,),
    BlocDropdown(label: "Nature of Sample/Article", value: state.article, items: ["Milk", "Water"], onChanged: (val) => bloc.add(articleChanged(val))),

  ],
  [
    BlocBuilder<SampleFormBloc, SampleFormState>(
      builder: (context, state) {
        return BlocYesNoRadio(
          label: "Preservative Added?",
          value: state.preservativeAdded,
          onChanged: (val) => bloc.add(PreservativeAddedChanged(val)),
        );
      },
    ),    SizedBox(height: 16,),
    BlocTextInput(label: "if yes, Mention the name of Preservative", initialValue: state.preservativeName, onChanged: (val) => bloc.add(preservativeNameChanged(val))),
    SizedBox(height: 16,),
    BlocTextInput(label: "Quantity of Preservative ", initialValue: state.preservativeQuantity, onChanged: (val) => bloc.add(preservativeQuantityChanged(val))),
    SizedBox(height: 16,),
    BlocBuilder<SampleFormBloc, SampleFormState>(
      builder: (context, state) {
        return BlocYesNoRadio(
          label: "Signature & thumb impression of the person/witness from whom the sample has been taken",
          value: state.personSignature,
          onChanged: (val) => bloc.add(personSignatureChanged(val)),
        );
      },
    ),
    SizedBox(height: 16,),
    BlocTextInput(label: "Paper Slip Number", initialValue: state.slipNumber, onChanged: (val) => bloc.add(slipNumberChanged(val))),
    SizedBox(height: 16,),
    BlocBuilder<SampleFormBloc, SampleFormState>(
      builder: (context, state) {
        return BlocYesNoRadio(
          label: "Signature of DO OR any officer authorized by FSO",
          value: state.DOSignature,
          onChanged: (val) => bloc.add(DOSignatureChanged(val)),
        );
      },
    ),
  ],
  [

    BlocTextInput(label: "Code Number of sample on Wrapper", initialValue: state.sampleCodeNumber, onChanged: (val) => bloc.add(sampleCodeNumberChanged(val))),
    SizedBox(height: 16,),
    BlocBuilder<SampleFormBloc, SampleFormState>(
      builder: (context, state) {
        return BlocYesNoRadio(
          label: "Impression of seal of the sender ",
          value: state.sealImpression,
          onChanged: (val) => bloc.add(sealImpressionChanged(val)),
        );
      },
    ),
    SizedBox(height: 16,),
    BlocTextInput(label: "Number of Seal", initialValue: state.numberofSeal, onChanged: (val) => bloc.add(numberofSealChanged(val))),
    SizedBox(height: 16,),
    BlocBuilder<SampleFormBloc, SampleFormState>(
      builder: (context, state) {
        return BlocYesNoRadio(
          label: "Memorandum in Form VI (Sealed packed & Specimen of the seal)",
          value: state.formVI,
          onChanged: (val) => bloc.add(formVIChanged(val)),
        );
      },
    ),
    SizedBox(height: 16,),
    BlocBuilder<SampleFormBloc, SampleFormState>(
      builder: (context, state) {
        return BlocYesNoRadio(
          label: "Form VI is inside the sample Wrapper?",
          value: state.FoemVIWrapper,
          onChanged: (val) => bloc.add(FoemVIWrapperChanged(val)),
        );
      },
    ),
  ],

];
