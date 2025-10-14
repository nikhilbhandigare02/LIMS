import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_inspector/Screens/FORM6/Storage/form6_storage.dart';
import 'package:food_inspector/config/Themes/colors/colorsTheme.dart';
import 'package:food_inspector/core/widgets/AppHeader/AppHeader.dart';
import 'dart:async';

import '../../../core/utils/Message.dart';
import '../../../core/utils/enums.dart';
import '../../../core/widgets/AppDrawer/Drawer.dart';
import '../../../l10n/app_localizations.dart';
import '../bloc/Form6Bloc.dart';
import 'form_steps.dart';
import 'form6_landing_screen.dart';

class Form6StepScreen extends StatefulWidget {
  final String section;
  final int initialStep;
  const Form6StepScreen({
    super.key,
    required this.section,
    this.initialStep = 0,
  });

  @override
  State<Form6StepScreen> createState() => _Form6StepScreenState();
}

class _Form6StepScreenState extends State<Form6StepScreen> {
  int currentStep = 0;
  late List<List<Widget>> stepFields;
  late List<GlobalKey<FormState>> _formKeys;
  bool _depsInitialized = false;

  final Form6Storage storage = Form6Storage();
  Timer? _saveDebounce;

  void _scheduleAutoSave(SampleFormState state) {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 350), () async {
      try {
        await storage.saveForm6Data(state);
        // print("📝 Auto-saved form state.");
      } catch (e) {
        // print("⚠️ Auto-save failed: $e");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Avoid using context-dependent localization in initState
    stepFields = [[]];
    _formKeys = [GlobalKey<FormState>()];
    currentStep = widget.initialStep;
    _loadSavedData();
    print("🔄 Form6StepScreen initialized for section: ${widget.section} with initial step: $currentStep");
    context.read<SampleFormBloc>().add(FetchLocationRequested());
    context.read<SampleFormBloc>().add(const FetchDistrictsRequested(1));
    // context.read<SampleFormBloc>().add(const FetchNatureOfSampleRequested());
  }

  @override
  void dispose() {
    _saveDebounce?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_depsInitialized) {
      final bloc = context.read<SampleFormBloc>();
      setState(() {
        stepFields = _generateStepFields(bloc.state);
        _formKeys = List.generate(stepFields.length, (_) => GlobalKey<FormState>());
        final int maxIndex = stepFields.isNotEmpty ? stepFields.length - 1 : 0;
        currentStep = widget.initialStep <= maxIndex
            ? (widget.initialStep < 0 ? 0 : widget.initialStep)
            : maxIndex;
      });
      _depsInitialized = true;
    }
  }

  List<List<Widget>> _generateStepFields(SampleFormState state) {
    final bloc = context.read<SampleFormBloc>();
    switch (widget.section) {
      case 'other':
        return getOtherInformationSteps(state, bloc, context);
      case 'sample':
        return getSampleDetailsSteps(state, bloc, context);
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
      // Clamp currentStep in case the number of steps changed
      final int maxIndex = stepFields.isNotEmpty ? stepFields.length - 1 : 0;
      if (currentStep > maxIndex) currentStep = maxIndex;
      if (currentStep < 0) currentStep = 0;
    });
  }

  void _goToNextStep() async {
    final bloc = context.read<SampleFormBloc>();
    final state = bloc.state;
    // Compute steps from latest state to be consistent with UI
    final steps = widget.section == 'other'
        ? getOtherInformationSteps(state, bloc, context)
        : getSampleDetailsSteps(state, bloc, context);

    // Ensure form keys are in sync with steps before validation
    if (_formKeys.length != steps.length) {
      _formKeys = List.generate(steps.length, (_) => GlobalKey<FormState>());
      // Clamp current step to bounds
      final int maxIndex = steps.isNotEmpty ? steps.length - 1 : 0;
      if (currentStep > maxIndex) currentStep = maxIndex;
      if (currentStep < 0) currentStep = 0;
    }

    final currentFormKey = _formKeys[currentStep];
    final isValid = currentFormKey.currentState?.validate() ?? true;

    if (!isValid) {
      print("⛔ Validation failed at step $currentStep for section ${widget.section}");
      AppDialog.show(
          context,
          AppLocalizations.of(context)!.form6_step_validation_error,
          MessageType.error
      );
      return;
    }

    try {
      await storage.saveForm6Data(state);
    } catch (e) {
      print("❗ Failed to save Form6 data locally: $e");
    }
    await Future.delayed(const Duration(milliseconds: 50));

    // If still steps left in current section
    if (currentStep < steps.length - 1) {
      setState(() {
        currentStep++;
      });
      print("➡️ Moved to next step: $currentStep/${steps.length - 1} in section ${widget.section}");
      return;
    }

    bool isComplete = false;
    String errorMessage = "";

    if (widget.section == 'other') {
      isComplete = state.isOtherInfoComplete;
      errorMessage = AppLocalizations.of(context)!.form6_step_other_section_incomplete;
      print("ℹ️ Other completeness: $isComplete | senderName='${state.senderName}' senderDesignation='${state.senderDesignation}' DONumber='${state.DONumber}' district='${state.district}' division='${state.division}' region='${state.region}' area='${state.area}' lab='${state.lab}' sendingSampleLocation='${state.sendingSampleLocation}'");
    } else if (widget.section == 'sample') {
      isComplete = state.isSampleInfoComplete;
      errorMessage = AppLocalizations.of(context)!.form6_step_sample_section_incomplete;
      print("ℹ️ Sample completeness: $isComplete | sampleCodeData='${state.sampleCodeData}' collectionDate='${state.collectionDate}' place='${state.placeOfCollection}' SampleName='${state.SampleName}' Quantity='${state.QuantitySample}' NumberOfSample='${state.NumberOfSample}' article='${state.article}' preservativeAdded='${state.preservativeAdded}' personSignature='${state.personSignature}' DOSignature='${state.DOSignature}' sampleCodeNumber='${state.sampleCodeNumber}' sealImpression='${state.sealImpression}' numberofSeal='${state.numberofSeal}' formVI='${state.formVI}' FoemVIWrapper='${state.FoemVIWrapper}' uploadedDocs='${state.uploadedDocs.length}' doSlipNumbers='${state.doSlipNumbers}'");
    }

    if (!isComplete) {
      print("⛔ Section '${widget.section}' incomplete. Staying on last step.");
      AppDialog.show(context, errorMessage, MessageType.error);
      return;
    }

    if (widget.section == 'other') {
      print("✅ Other section complete. Navigating to 'sample' section.");
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
      print("✅ Sample section complete. Finishing and returning to landing.");
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
    final localizations = AppLocalizations.of(context)!;

    return MultiBlocListener(
      listeners: [
        BlocListener<SampleFormBloc, SampleFormState>(
          listenWhen: (prev, curr) => prev != curr,
          listener: (context, state) {
            _scheduleAutoSave(state);
          },
        ),
        BlocListener<SampleFormBloc, SampleFormState>(
          listenWhen: (prev, curr) => prev.documentName != curr.documentName,
          listener: (context, state) async {
            await storage.saveForm6Data(state);
          },
        ),
        BlocListener<SampleFormBloc, SampleFormState>(
          listenWhen: (prev, curr) => prev.uploadedDocs != curr.uploadedDocs,
          listener: (context, state) async {
            await storage.saveForm6Data(state);
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: customColors.grey50,
        appBar: AppHeader(
          screenTitle: localizations.form6_step_form_vi_title,
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
                        ? getOtherInformationSteps(state, context.read<SampleFormBloc>(), context)
                        : getSampleDetailsSteps(state, context.read<SampleFormBloc>(), context);

                    // Keep form keys in sync with steps
                    if (_formKeys.length != steps.length) {
                      _formKeys = List.generate(steps.length, (_) => GlobalKey<FormState>());
                      // Clamp current step to bounds
                      final int maxIndex = steps.isNotEmpty ? steps.length - 1 : 0;
                      if (currentStep > maxIndex) currentStep = maxIndex;
                      if (currentStep < 0) currentStep = 0;
                    }

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
                          Text(
                              localizations.form6_step_previous_button,
                              style: TextStyle(color: customColors.white)
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _goToNextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: customColors.primary,
                        foregroundColor: customColors.white,
                      ),
                      child: Row(
                        children: [
                          BlocBuilder<SampleFormBloc, SampleFormState>(
                            buildWhen: (p, n) => false, // label depends on currentStep and steps length
                            builder: (context, state) {
                              final steps = widget.section == 'other'
                                  ? getOtherInformationSteps(state, context.read<SampleFormBloc>(), context)
                                  : getSampleDetailsSteps(state, context.read<SampleFormBloc>(), context);
                              final isLastStep = !(currentStep < (steps.length - 1));
                              final label = !isLastStep
                                  ? localizations.form6_step_save_next_button
                                  : (widget.section == 'other'
                                      ? localizations.form6_step_save_next_button
                                      : localizations.form6_step_submit_button);
                              return Text(
                                label,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              );
                            },
                          ),
                          const SizedBox(width: 6),
                          const Icon(CupertinoIcons.right_chevron, color: customColors.white),
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