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
    print("🔄 Form6StepScreen initialized for section: ${widget.section}");
    context.read<SampleFormBloc>().add(FetchLocationRequested());
  }

  List<List<Widget>> _generateStepFields(SampleFormState state) {
    final bloc = context.read<SampleFormBloc>();
    switch (widget.section) {
      case 'other':
        return getOtherInformationSteps(state, bloc);
      case 'sample':
        return getSampleDetailsSteps(state, bloc);
      default:
        return [[]];
    }
  }

  Future<void> _loadSavedData() async {
    final bloc = context.read<SampleFormBloc>();
    final savedState = await storage.fetchStoredState();

    if (savedState != null) {
      print("🔄 Loading saved state for section: ${widget.section}");
      bloc.add(LoadSavedFormData(savedState));
    }

    await Future.delayed(const Duration(milliseconds: 50));
    setState(() {
      stepFields = _generateStepFields(bloc.state);
    });
  }

  void _goToNextStep() async {
    final bloc = context.read<SampleFormBloc>();
    final state = bloc.state;

    print("🔄 Going to next step. Current step: $currentStep, Total steps: ${stepFields.length}");
    print("🔄 Current completion status - Other: ${state.isOtherInfoComplete}, Sample: ${state.isSampleInfoComplete}");

    // Save current state
    await storage.saveForm6Data(state);
    await Future.delayed(const Duration(milliseconds: 50));

    if (currentStep < stepFields.length - 1) {
      setState(() {
        currentStep++;
        stepFields = _generateStepFields(state);
      });
      print("🔄 Moved to step: $currentStep");
    } else {
      // Validate completion based on section
      bool isComplete = false;
      String errorMessage = "";
      
      if (widget.section == 'other') {
        isComplete = state.isOtherInfoComplete;
        errorMessage = "⚠️ Please complete all required fields.";
        print("🔄 Other section completion check: $isComplete");
      } else if (widget.section == 'sample') {
        isComplete = state.isSampleInfoComplete;
        errorMessage = "⚠️ Please complete all sample fields.";
        print("🔄 Sample section completion check: $isComplete");
      }

      if (!isComplete) {
        print("❌ Section not complete, showing error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Mark section as complete in storage
      if (widget.section == 'other') {
        await storage.markSectionComplete(section: 'other');
        print("✅ Marked 'other' section as complete");
      } else if (widget.section == 'sample') {
        await storage.markSectionComplete(section: 'sample');
        print("✅ Marked 'sample' section as complete");
      }

      // Return to landing screen with completion status
      print("🔄 Returning to landing screen with completion status");
      Navigator.pop(context, 'completed');

      // Navigate to next section if available
      if (widget.section == 'other') {
        Future.delayed(const Duration(milliseconds: 200), () {
          print("🔄 Navigating to sample section");
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
      await _loadSavedData();
      setState(() {
        currentStep--;
        stepFields = _generateStepFields(bloc.state);
      });
      print("🔄 Moved to previous step: $currentStep");
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
