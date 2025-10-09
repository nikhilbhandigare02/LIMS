import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_inspector/Screens/FORM6/repository/form6Repository.dart';
import 'package:food_inspector/config/Routes/RouteName.dart';
import 'package:food_inspector/config/Themes/colors/colorsTheme.dart';
import 'package:food_inspector/core/utils/Message.dart';
import 'package:food_inspector/core/utils/enums.dart';
import 'package:food_inspector/core/widgets/AppHeader/AppHeader.dart';
import '../../../core/widgets/AppDrawer/Drawer.dart';

import '../../../l10n/app_localizations.dart';
import '../Storage/form6_storage.dart';
import '../bloc/Form6Bloc.dart';
import 'form6_step_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

class Form6LandingScreen extends StatefulWidget {
  @override
  State<Form6LandingScreen> createState() => _Form6LandingScreenState();
}

class _Form6LandingScreenState extends State<Form6LandingScreen> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  bool isOtherInfoComplete = false; // FSO Info
  bool isSampleInfoComplete = false; // Sample Info
  bool isPreservativeComplete = false; // Preservative Info
  bool isSealComplete = false; // Seal Details
  bool isAdditionalDetailsComplete = false; // (vi)-(viii) Additional details
  bool isReviewComplete = false; // Review & Submit
  final Form6Storage storage = Form6Storage();

  @override
  void initState() {
    super.initState();
    loadCompletionStatus();
    _loadSavedStateToBloc();
  }

  Future<void> _loadSavedStateToBloc() async {
    final savedState = await storage.fetchStoredState();
    if (savedState != null) {
      context.read<SampleFormBloc>().add(LoadSavedFormData(savedState));
      print("🔄 Loaded saved state to BLoC");
    }
  }

  Future<void> loadCompletionStatus() async {
    final savedState = await storage.fetchStoredState();
    if (mounted) {
      setState(() {
        if (savedState != null) {
          final s = savedState;
          isOtherInfoComplete = _isFsoInfoComplete(s);
          isSampleInfoComplete = _isSampleInfoComplete(s);
          isPreservativeComplete = _isPreservativeInfoComplete(s);
          isSealComplete = _isSealInfoComplete(s);
          isAdditionalDetailsComplete = _isAdditionalDetailsComplete(s);
          isReviewComplete = isOtherInfoComplete && isSampleInfoComplete && isPreservativeComplete && isSealComplete;
        } else {
          isOtherInfoComplete = false;
          isSampleInfoComplete = false;
          isPreservativeComplete = false;
          isSealComplete = false;
          isAdditionalDetailsComplete = false;
          isReviewComplete = false;
        }
      });
      print("🔄 Loaded completion status - Other: $isOtherInfoComplete, Sample: $isSampleInfoComplete, Preservative: $isPreservativeComplete, Seal: $isSealComplete, Review: $isReviewComplete");
    }
  }

  Future<void> handleSubmit() async {
    if (isOtherInfoComplete && isSampleInfoComplete && isPreservativeComplete && isSealComplete) {
      context.read<SampleFormBloc>().add(FormSubmit());
    } else {
      Message.showTopRightOverlay(
        context,
        AppLocalizations.of(context)!.form6_landing_form_not_filled,
        MessageType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return WillPopScope(
        onWillPop: () async {
          final confirmed = await ConfirmDialog.show(
            context,
            title: localizations.form6_landing_exit_app,
            message: localizations.form6_landing_exit_confirmation,
            confirmText: localizations.form6_landing_exit,
            confirmColor: Colors.red,
            icon: Icons.exit_to_app,
          );

          if (confirmed) {
            return true;
          }
          return false;
        },
        child:  BlocListener<SampleFormBloc, SampleFormState>(
          listener: (context, state) async {
            final newOtherComplete = _isFsoInfoComplete(state);
            final newSampleComplete = _isSampleInfoComplete(state);
            final newPreservativeComplete = _isPreservativeInfoComplete(state);
            final newSealComplete = _isSealInfoComplete(state);
            final newAdditionalDetailsComplete = _isAdditionalDetailsComplete(state);
            final newReviewComplete = newOtherComplete && newSampleComplete && newPreservativeComplete && newSealComplete;

            final changed =
                newOtherComplete != isOtherInfoComplete ||
                    newSampleComplete != isSampleInfoComplete ||
                    newPreservativeComplete != isPreservativeComplete ||
                    newSealComplete != isSealComplete ||
                    newAdditionalDetailsComplete != isAdditionalDetailsComplete ||
                    newReviewComplete != isReviewComplete;

            if (changed) {
              print("🔄 State changed - Other: $newOtherComplete, Sample: $newSampleComplete, Preservative: $newPreservativeComplete, Seal: $newSealComplete, Review: $newReviewComplete");
              setState(() {
                isOtherInfoComplete = newOtherComplete;
                isSampleInfoComplete = newSampleComplete;
                isPreservativeComplete = newPreservativeComplete;
                isSealComplete = newSealComplete;
                isAdditionalDetailsComplete = newAdditionalDetailsComplete;
                isReviewComplete = newReviewComplete;
              });
            }

            // Handle submit states
            if (state.apiStatus == ApiStatus.loading) {
              AppDialog.show(context, localizations.form6_landing_loading, MessageType.info);
            } else if (state.apiStatus == ApiStatus.success) {
              // Close loading first
              AppDialog.closePopup(context);

              // Clear saved form only on success
              await storage.clearFormData();
              setState(() {
                isOtherInfoComplete = false;
                isSampleInfoComplete = false;
                isPreservativeComplete = false;
                isSealComplete = false;
                isReviewComplete = false;
              });

              final successMsg = state.message.isNotEmpty
                  ? state.message
                  : localizations.form6_landing_form_submitted;

              AppDialog.show(context, successMsg, MessageType.success, onOk: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => SampleFormBloc(form6repository: Form6Repository()),
                      child: Form6LandingScreen(),
                    ),
                  ),
                      (route) => false,
                );
              });
            } else if (state.apiStatus == ApiStatus.error) {
              // Close loading first
              AppDialog.closePopup(context);

              final errMsg = state.message.isNotEmpty
                  ? state.message
                  : localizations.form6_landing_submission_failed;

              // Show error popup
              AppDialog.show(context, errMsg, MessageType.error);
            }

          },
          child: Scaffold(
            backgroundColor: customColors.white,
            appBar: AppHeader(
              screenTitle: localizations.form6_landing_title,
              showBack: false,
            ),
            drawer: CustomDrawer(),

            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 50),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      localizations.form6_landing_sections_title,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    _buildVerticalStepProgress(localizations),
                    const SizedBox(height: 15),
                    _buildSubmitButton(localizations),
                    const SizedBox(height: 15),

                  ],
                ),
              ),
            ),
          ),
        ) ) ;
  }

  Widget _buildVerticalStepProgress(AppLocalizations localizations) {
    List<Map<String, dynamic>> steps = [
      {
        'title': localizations.form6_landing_fso_info_title,
        'subtitle': localizations.form6_landing_fso_info_subtitle,
        'icon': Icons.person_outline,
        'isComplete': isOtherInfoComplete,
        'color': Colors.blue,
        'section': 'other',
      },
      {
        'title': localizations.form6_landing_sample_info_title,
        'subtitle': localizations.form6_landing_sample_info_subtitle,
        'icon': Icons.science_outlined,
        'isComplete': isSampleInfoComplete,
        'color': Colors.green,
        'section': 'sample',
      },
      {
        'title': localizations.form6_landing_preservative_info_title,
        'subtitle': localizations.form6_landing_preservative_info_subtitle,
        'icon': Icons.local_pharmacy_outlined,
        'isComplete': isPreservativeComplete,
        'color': Colors.purple,
        'section': 'sample',
      },
      {
        'title': localizations.form6_landing_seal_details_title,
        'subtitle': localizations.form6_landing_seal_details_subtitle,
        'icon': Icons.security_outlined,
        'isComplete': isSealComplete,
        'color': Colors.orange,
        'section': 'sample',
      },
      {
        'title': 'Additional details (vi)-(viii)',
        'subtitle': 'Special request, additional info, parameters to test',
        'icon': Icons.assignment_outlined,
        'isComplete': isAdditionalDetailsComplete,
        'color': Colors.teal,
        'section': 'sample',
      },
      {
        'title': localizations.form6_landing_review_submit_title,
        'subtitle': localizations.form6_landing_review_submit_subtitle,
        'icon': Icons.send_outlined,
        'isComplete': isReviewComplete,
        'color': Colors.indigo,
        'section': 'sample',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: List.generate(steps.length, (index) {
            final step = steps[index];
            final isLast = index == steps.length - 1;

            return InkWell(
              onTap: () async {
                print("🔄 Navigating to section: ${step['section']}");

                // Determine the initial step based on the section
                int initialStep = 0;
                if (step['title'] == localizations.form6_landing_preservative_info_title) {
                  initialStep = 1; // Second step for preservative info
                } else if (step['title'] == localizations.form6_landing_seal_details_title) {
                  initialStep = 2; // Third step for seal details
                } else if (step['title'] == 'Additional details (vi)-(viii)') {
                  initialStep = 3; // Fourth step for additional details
                } else if (step['title'] == localizations.form6_landing_review_submit_title) {
                  initialStep = 2; // Use last available step for review
                }

                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<SampleFormBloc>(),
                      child: Form6StepScreen(
                        section: step['section'],
                        initialStep: initialStep,
                      ),
                    ),
                  ),
                );

                if (result == 'completed') {
                  print("🔄 Form section completed, reloading status");
                  await loadCompletionStatus();
                  final savedState = await storage.fetchStoredState();
                  if (savedState != null) {
                    context.read<SampleFormBloc>().add(LoadSavedFormData(savedState));
                  }
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Indicator + line - NOW UNIFORM FOR ALL STEPS
                  Column(
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: Center(
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: step['isComplete']
                                  ? step['color']
                                  : customColors.grey300,
                              shape: BoxShape.circle,
                              boxShadow: step['isComplete']
                                  ? [
                                BoxShadow(
                                  color: step['color'].withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ]
                                  : [],
                            ),
                            child: Icon(
                              step['isComplete']
                                  ? Icons.check
                                  : step['icon'],
                              size: 18,
                              color: step['isComplete']
                                  ? customColors.white
                                  : customColors.grey600,
                            ),
                          ),
                        ),
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 40,
                          color: step['isComplete']
                              ? step['color']
                              : customColors.grey300,
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: step['isComplete']
                            ? step['color'].withOpacity(0.05)
                            : customColors.grey50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: step['isComplete']
                              ? step['color'].withOpacity(0.2)
                              : customColors.grey200,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left: Title + subtitle
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                step['title'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: step['isComplete']
                                      ? step['color']
                                      : customColors.grey800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                step['subtitle'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: customColors.grey600,
                                ),
                              ),
                            ],
                          ),
                          // Right: Arrow icon
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: step['isComplete']
                                ? step['color']
                                : customColors.grey400,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(AppLocalizations localizations) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: 0.0,
            child: child,
          ),
        );
      },
      child: (isOtherInfoComplete && isSampleInfoComplete && isPreservativeComplete && isSealComplete)
          ? Container(
        width: double.infinity,
        child: TextButton.icon(
          key: const ValueKey("submitButton"),
          onPressed: handleSubmit,
          icon: Icon(Icons.check_circle, color: customColors.white),
          label: Text(
            localizations.form6_landing_submit_button,
            style: TextStyle(color: customColors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: customColors.primary,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      )
          : Card(
        key: const ValueKey("warningText"),
        color: customColors.red50,
        margin: const EdgeInsets.only(top: 10),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

// Completion helper functions (unchanged)
bool _isFsoInfoComplete(SampleFormState s) {
  return s.senderDesignation.isNotEmpty &&
      s.DONumber.isNotEmpty &&
      s.district.isNotEmpty &&
      s.region.isNotEmpty &&
      s.division.isNotEmpty;
}

bool _isSampleInfoComplete(SampleFormState s) {
  final bool hasAnyCode = s.sampleCodeNumber.isNotEmpty || s.sampleCodeData.isNotEmpty;
  return hasAnyCode &&
      s.collectionDate != null &&
      s.placeOfCollection.isNotEmpty &&
      s.SampleName.isNotEmpty &&
      s.QuantitySample.isNotEmpty;
  // s.article.isNotEmpty;
}

bool _isPreservativeInfoComplete(SampleFormState s) {
  if (s.preservativeAdded == null) return false;
  if (s.preservativeAdded == true) {
    return s.preservativeName.isNotEmpty && s.preservativeQuantity.isNotEmpty;
  }
  return true;
}

bool _isSealInfoComplete(SampleFormState s) {
  final bool hasDoSeal = s.doSlipNumbers.isNotEmpty;
  return s.personSignature != null &&
      s.DOSignature != null &&
      s.sealImpression != null &&
      s.numberofSeal.isNotEmpty &&
      hasDoSeal;
}

// New helper: completion for additional details step (vi)-(viii)
bool _isAdditionalDetailsComplete(SampleFormState s) {
  // additionalTests is optional; other three are required
  return s.specialRequestReason.isNotEmpty &&
      s.additionalRelevantInfo.isNotEmpty &&
      s.parametersAsPerFSSAI.isNotEmpty;
}