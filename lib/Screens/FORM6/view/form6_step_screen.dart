import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_inspector/Screens/FORM6/Storage/form6_storage.dart';
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

  final Form6Storage storage = Form6Storage();

  @override
  void initState() {
    super.initState();
    final bloc = context.read<SampleFormBloc>();
    stepFields = _generateStepFields(bloc.state);
    _loadSavedData();
  }

  List<List<Widget>> _generateStepFields(SampleFormState state) {
    final bloc = context.read<SampleFormBloc>();
    switch (widget.section) {
      case 'other':
        return getOtherInformationSteps(state, bloc);
      case 'sample':
        return getSampleDetailsSteps(state, bloc);
      // case 'preservative':
      //   return getPreservativeSteps(state, bloc);
      // case 'seal':
      //   return getSealDetailsSteps(state, bloc);
      // case 'review':
      //   return getFinalReviewSteps(state, bloc);
      default:
        return [[]];
    }
  }


  Future<void> _loadSavedData() async {
    final bloc = context.read<SampleFormBloc>();
    final savedState = await storage.fetchStoredState();

    if (savedState != null) {
      bloc.add(LoadSavedFormData(savedState));
    }

    await Future.delayed(const Duration(milliseconds: 50));
    setState(() {
      stepFields = _generateStepFields(bloc.state);
    });
  }

  void _goToNextStep() async {
    final bloc = context.read<SampleFormBloc>();

    await storage.saveForm6Data(bloc.state);
    await Future.delayed(const Duration(milliseconds: 50));
    await storage.printAllStoredData();

    final state = bloc.state;

    if (currentStep < stepFields.length - 1) {
      setState(() {
        currentStep++;
        stepFields = _generateStepFields(state);
      });
    } else {
      if (widget.section == 'other' && !state.isOtherInfoComplete) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("⚠️ Please complete all required fields."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (widget.section == 'sample' && !state.isSampleInfoComplete) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("⚠️ Please complete all sample fields."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      Navigator.pop(context, 'completed');

      if (widget.section == 'other') {
        Future.delayed(const Duration(milliseconds: 200), () {
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
      }
    }
  }

  void _goToPreviousStep() async {
    if (currentStep == 0) {
      Navigator.pop(context);
    } else {
      final bloc = context.read<SampleFormBloc>();
      await _loadSavedData(); // Update from storage
      setState(() {
        currentStep--;
        stepFields = _generateStepFields(bloc.state); // Rebuild UI with latest state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
              child: BlocBuilder<SampleFormBloc, SampleFormState>(
                builder: (context, state) {
                  final steps = widget.section == 'other'
                      ? getOtherInformationSteps(state, context.read<SampleFormBloc>())
                      : getSampleDetailsSteps(state, context.read<SampleFormBloc>());

                  return ListView(
                    children: steps[currentStep],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _goToPreviousStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customColors.grey,
                      foregroundColor: customColors.black87,
                    ),
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.left_chevron, color: customColors.white),
                        const SizedBox(width: 6),
                        Text("Previous", style: TextStyle(color: customColors.white)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _goToNextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Text(
                          currentStep < stepFields.length - 1
                              ? "SAVE & NEXT"
                              : widget.section == 'other'
                              ? "SAVE & NEXT"
                              : "SUBMIT",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 6),
                        const Icon(CupertinoIcons.right_chevron, color: Colors.white),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
