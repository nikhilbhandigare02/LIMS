// form6_step_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_inspector/config/Themes/colors/colorsTheme.dart';
import 'package:food_inspector/core/widgets/AppHeader/AppHeader.dart';
import '../bloc/Form6Bloc.dart';
import 'form_steps.dart';
import 'form6_landing_screen.dart';

class Form6StepScreen extends StatefulWidget {
  final String section;
  const Form6StepScreen({super.key, required this.section});

  @override
  State<Form6StepScreen> createState() => _Form6StepScreenState();
}

class _Form6StepScreenState extends State<Form6StepScreen> {
  int currentStep = 0;
  late List<List<Widget>> stepFields;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    final state = context.read<SampleFormBloc>().state;
    final bloc = context.read<SampleFormBloc>();

    stepFields = widget.section == 'other'
        ? getOtherInformationSteps(state, bloc)
        : getSampleDetailsSteps(state, bloc);
  }

  Future<void> saveOtherInfo(SampleFormState state) async {
    final data = {
      'senderName': state.senderName,
      'DONumber': state.DONumber,
      'senderDesignation': state.senderDesignation,
      'district': state.district,
      'region': state.region,
      'division': state.division,
      'area': state.area,
    };
    await secureStorage.write(key: 'form6_other_data', value: data.toString());
    await secureStorage.write(key: 'form6_other_section', value: 'complete');
    print('✅ Saved Other Info: $data');
  }

  Future<void> saveSampleInfo(SampleFormState state) async {
    final data = {
      'sampleCode': state.sampleCodeData,
      'collectionDate': state.collectionDate,
      'placeOfCollection': state.placeOfCollection,
      'SampleName': state.SampleName,
      'QuantitySample': state.QuantitySample,
      'article': state.article,
      'preservativeAdded': state.preservativeAdded,
      'preservativeName': state.preservativeName,
      'preservativeQuantity': state.preservativeQuantity,
      'personSignature': state.personSignature,
      'slipNumber': state.slipNumber,
      'DOSignature': state.DOSignature,
      'sampleCodeNumber': state.sampleCodeNumber,
      'sealImpression': state.sealImpression,
      'numberofSeal': state.numberofSeal,
      'formVI': state.formVI,
      'FoemVIWrapper': state.FoemVIWrapper,
    };

    await secureStorage.write(key: 'form6_sample_data', value: data.toString());
    await secureStorage.write(key: 'form6_sample_section', value: 'complete');
    print('✅ Saved Sample Info: $data');
  }

  Future<void> clearFormData() async {
    await secureStorage.deleteAll();
    print('🧹 Cleared all form6 data from secure storage');
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SampleFormBloc>();

    return Scaffold(
      appBar: AppHeader(
        screenTitle: widget.section == 'other' ? 'Other Information' : 'Sample Details',
        username: 'Rajan',
        userId: 'S0001',
        showBack: true,

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                children: stepFields[currentStep],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (currentStep == 0) {
                        Navigator.pop(context);
                      } else {
                        setState(() => currentStep--);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customColors.grey,
                      foregroundColor: customColors.black87,
                    ),
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.left_chevron, color: customColors.white,),
                        SizedBox(width: 6,),
                         Text("Previous", style: TextStyle(color: customColors.white),),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      final isLastStep = currentStep == stepFields.length - 1;

                      if (!isLastStep) {
                        setState(() => currentStep++);
                      } else {
                        final state = bloc.state;

                        if (widget.section == 'other') {
                          await saveOtherInfo(state);
                          Navigator.pop(context, 'completed');

                          // Optional: Navigate to Sample step after short delay
                          Future.delayed(Duration(milliseconds: 300), () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: bloc,
                                  child: const Form6StepScreen(section: 'sample'),
                                ),
                              ),
                            );
                          });
                        } else {
                          await saveSampleInfo(state);
                          await clearFormData();
                          Navigator.pop(context, 'completed');
                        }
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          currentStep < stepFields.length - 1
                              ? "Next"
                              : widget.section == 'other'
                              ? "Save & Next"
                              : "Submit",
                          style: TextStyle(fontWeight: FontWeight.bold,),
                        ),
                        SizedBox(width: 6,),
                        Icon(CupertinoIcons.right_chevron, color: Colors.white,)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
