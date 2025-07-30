// ===== sample_form_screen.dart =====
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_inspector/Screens/home/repository/homeRepository.dart';

import '../../../core/widgets/HomeWidgets/HomeWidgets.dart';
import '../bloc/homeBloc.dart';


class Form6Screen extends StatefulWidget {
  const Form6Screen({super.key});

  @override
  State<Form6Screen> createState() => _Form6ScreenState();
}

class _Form6ScreenState extends State<Form6Screen> {
  late SampleFormBloc sampleFormBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sampleFormBloc = SampleFormBloc(form6repository: Form6Repository());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sampleFormBloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('Sample Form')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<SampleFormBloc, SampleFormState>(
            builder: (context, state) {
              return ListView(
                children: [
                  Text('Officer Information'),
                  BlocTextInput(
                    label: "Name of Sender",
                    initialValue: state.senderName,
                    onChanged: (val) => context.read<SampleFormBloc>().add(SampleCodeChanged(val)),
                  ),
                  SizedBox(height: 20,),

                  BlocTextInput(
                    label: "sender Official Designation",
                    initialValue: state.senderDesignation,
                    onChanged: (val) => context.read<SampleFormBloc>().add(senderDesignationChanged(val)),
                  ),
                  SizedBox(height: 20,),

                  BlocTextInput(
                    label: "DO Number",
                    initialValue: state.DONumber,
                    onChanged: (val) => context.read<SampleFormBloc>().add(DONumberChanged(val)),
                  ),
                  SizedBox(height: 20,),

                  BlocDropdown(
                    label: "District",
                    value: state.district ?? '',
                    items: const ["Milk", "Water", "Soil"],
                    onChanged: (val){ if (val != null) { context.read<SampleFormBloc>().add(DistrictChanged(val));}},
                  ),
                  SizedBox(height: 20,),

                  BlocDropdown(
                    label: "Region",
                    value: state.region,
                    items: const ["Milk", "Water", "Soil"],
                    onChanged: (val){ if (val != null) { context.read<SampleFormBloc>().add(RegionChanged(val));}},
                  ),
                  SizedBox(height: 20,),

                  BlocDropdown(
                    label: "Division",
                    value: state.division,
                    items: const ["Milk", "Water", "Soil"],
                    onChanged: (val){ if (val != null) { context.read<SampleFormBloc>().add(DivisionChanged(val));}},
                  ),
                  SizedBox(height: 20,),

                  BlocDropdown(
                    label: "Area",
                    value: state.area,
                    items: const ["Milk", "Water", "Soil"],
                    onChanged: (val){ if (val != null) { context.read<SampleFormBloc>().add(AreaChanged(val));}},
                  ),
                  SizedBox(height: 20,),

                  SizedBox(height: 20,),
                  Text('Sample Information'),
                  BlocTextInput(
                    label: "Sample Code Number",
                    initialValue: state.sampleCode,
                    onChanged: (val) => context.read<SampleFormBloc>().add(SampleCodeChanged(val)),
                  ),
                  const SizedBox(height: 16),
                  BlocDatePicker(
                    label: "Date of Collection",
                    selectedDate: state.collectionDate,
                    onChanged: (date) => context.read<SampleFormBloc>().add(CollectionDateChanged(date)),
                  ),
                  const SizedBox(height: 16),
                  BlocTextInput(
                    label: "Place of Collection",
                    initialValue: state.placeOfCollection,
                    onChanged: (val) => context.read<SampleFormBloc>().add(PlaceChanged(val)),
                  ),
                  SizedBox(height: 20,),

                  BlocTextInput(
                    label: "Sample Name",
                    initialValue: state.SampleName,
                    onChanged: (val) => context.read<SampleFormBloc>().add(SampleNameChanged(val)),
                  ),
                  SizedBox(height: 20,),

                  BlocTextInput(
                    label: "Quantity of Sample",
                    initialValue: state.QuantitySample,
                    onChanged: (val) => context.read<SampleFormBloc>().add(QuantitySampleChanged(val)),
                  ),
                  SizedBox(height: 20,),

                  BlocDropdown(
                    label: "Number of Sample/Article",
                    value: state.article,
                    items: const ["Milk", "Water", "Soil"],
                    onChanged: (val){ if (val != null) { context.read<SampleFormBloc>().add(articleChanged(val));}},
                  ),
                  const SizedBox(height: 16),
                  BlocYesNoRadio(
                    label: "Preservative Added?",
                    value: state.preservativeAdded,
                    onChanged: (val) => context.read<SampleFormBloc>().add(PreservativeAddedChanged(val)),
                  ),
                  SizedBox(height: 20,),

                  BlocTextInput(
                    label: "if yes, mention the name of preservative",
                    initialValue: state.preservativeName,
                    onChanged: (val) => context.read<SampleFormBloc>().add(preservativeNameChanged(val)),
                  ),
                  SizedBox(height: 20,),

                  BlocTextInput(
                    label: "Quantity of preservative",
                    initialValue: state.preservativeQuantity,
                    onChanged: (val) => context.read<SampleFormBloc>().add(preservativeQuantityChanged(val)),
                  ),
                  SizedBox(height: 20,),

                  BlocYesNoRadio(
                    label: "Signature & Thumb expression of the person/witness from whom the sample has been taken",
                    value: state.personSignature,
                    onChanged: (val) => context.read<SampleFormBloc>().add(personSignatureChanged(val)),
                  ),
                  SizedBox(height: 20,),

                  BlocTextInput(
                    label: "Paper Slip Number",
                    initialValue: state.slipNumber,
                    onChanged: (val) => context.read<SampleFormBloc>().add(slipNumberChanged(val)),
                  ),
                  SizedBox(height: 20,),

                  BlocYesNoRadio(
                    label: "Signature of DO or any officer authorised by FSO",
                    value: state.DOSignature,
                    onChanged: (val) => context.read<SampleFormBloc>().add(DOSignatureChanged(val)),
                  ),
                  SizedBox(height: 20,),

                  BlocTextInput(
                    label: "Code number of sample on Wrapper",
                    initialValue: state.sampleCodeNumber,
                    onChanged: (val) => context.read<SampleFormBloc>().add(sampleCodeNumberChanged(val)),
                  ),
                  SizedBox(height: 20,),

                  BlocYesNoRadio(
                    label: "Impression of Seal of the sender",
                    value: state.sealImpression,
                    onChanged: (val) => context.read<SampleFormBloc>().add(sealImpressionChanged(val)),
                  ),
                  SizedBox(height: 20,),

                  BlocTextInput(
                    label: "Number of seal",
                    initialValue: state.numberofSeal,
                    onChanged: (val) => context.read<SampleFormBloc>().add(numberofSealChanged(val)),
                  ),
                  SizedBox(height: 20,),

                  BlocYesNoRadio(
                    label: "Memorandum in Form VI (Sealed packed & Specimen of the seal) ",
                    value: state.formVI,
                    onChanged: (val) => context.read<SampleFormBloc>().add(formVIChanged(val)),
                  ),
                  SizedBox(height: 20,),

                  BlocYesNoRadio(
                    label: "Form VI is inside the sample wrapper",
                    value: state.FoemVIWrapper,
                    onChanged: (val) => context.read<SampleFormBloc>().add(FoemVIWrapperChanged(val)),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SampleFormBloc>().add(FormSubmit());
                    },
                    child: const Text("Submit"),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}