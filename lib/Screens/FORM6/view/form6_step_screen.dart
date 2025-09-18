import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_inspector/Screens/FORM6/Storage/form6_storage.dart';
import 'package:food_inspector/config/Themes/colors/colorsTheme.dart';
import 'package:food_inspector/core/widgets/AppHeader/AppHeader.dart';
import '../../../core/utils/Message.dart';
import '../../../core/utils/enums.dart';
import '../../../core/widgets/AppDrawer/Drawer.dart';
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
  late List<GlobalKey<FormState>> _formKeys;

  final Form6Storage storage = Form6Storage();

  @override
  void initState() {
    super.initState();
    final bloc = context.read<SampleFormBloc>();
    stepFields = _generateStepFields(bloc.state);
    _formKeys = List.generate(stepFields.length, (_) => GlobalKey<FormState>());
    _loadSavedData();
    print("🔄 Form6StepScreen initialized for section: ${widget.section}");
    context.read<SampleFormBloc>().add(FetchLocationRequested());
    context.read<SampleFormBloc>().add(const FetchDistrictsRequested(1));
    context.read<SampleFormBloc>().add(const FetchNatureOfSampleRequested());
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
      _formKeys = List.generate(stepFields.length, (_) => GlobalKey<FormState>());
    });
  }

  void _goToNextStep() async {
    final currentFormKey = _formKeys[currentStep];
    final isValid = currentFormKey.currentState?.validate() ?? true;

    if (!isValid) {
      AppDialog.show(context, 'Please correct the highlighted fields', MessageType.error);
      return;
    }

    final bloc = context.read<SampleFormBloc>();
    final state = bloc.state;

    await storage.saveForm6Data(state);
    await Future.delayed(const Duration(milliseconds: 50));

    // If still steps left in current section
    if (currentStep < stepFields.length - 1) {
      setState(() {
        currentStep++;
        stepFields = _generateStepFields(state);
        if (_formKeys.length != stepFields.length) {
          _formKeys = List.generate(stepFields.length, (_) => GlobalKey<FormState>());
        }
      });
      return;
    }

    // ✅ Section-level validation
    bool isComplete = false;
    String errorMessage = "";

    if (widget.section == 'other') {
      isComplete = state.isOtherInfoComplete;
      errorMessage = "⚠️ Please complete all required fields.";
    } else if (widget.section == 'sample') {
      isComplete = state.isSampleInfoComplete;
      errorMessage = "⚠️ Please complete all sample fields.";
    }

    if (!isComplete) {
      AppDialog.show(context, errorMessage, MessageType.error);
      return;
    }

    // ✅ If section complete → go to next section
    if (widget.section == 'other') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: bloc,
            child: const Form6StepScreen(section: 'sample'),
          ),
        ),
      );
    } else {
      // If last section → go back to landing
      Navigator.pop(context, 'completed');
    }
  }
  void _goToPreviousStep() async {
    if (currentStep == 0) {
      if (widget.section == 'sample') {
        // Go back to Other section instead of landing
        final bloc = context.read<SampleFormBloc>();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: bloc,
              child: const Form6StepScreen(section: 'other'),
            ),
          ),
        );
      } else {
        Navigator.pop(context);
      }
    } else {
      final bloc = context.read<SampleFormBloc>();
      await _loadSavedData();
      setState(() {
        currentStep--;
        stepFields = _generateStepFields(bloc.state);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<SampleFormBloc, SampleFormState>(
      listenWhen: (prev, curr) => prev.documentName != curr.documentName,
      listener: (context, state) async {
        await storage.saveForm6Data(state);
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppHeader(
          screenTitle: widget.section == 'other' ? 'Form VI' : 'Form VI',
          // username: ' ',
          userId: ' ',
          showBack: false,
        ),
        drawer: CustomDrawer(),

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

                    return Form(
                      key: _formKeys[currentStep],
                      child: ListView(
                        children: steps[currentStep],
                      ),
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
      ),
    );
  }
}
