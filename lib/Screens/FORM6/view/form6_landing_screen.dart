import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_inspector/Screens/FORM6/repository/form6Repository.dart';
import 'package:food_inspector/config/Routes/RouteName.dart';
import 'package:food_inspector/config/Themes/colors/colorsTheme.dart';
import 'package:food_inspector/core/utils/Message.dart';
import 'package:food_inspector/core/utils/enums.dart';
import 'package:food_inspector/core/widgets/AppHeader/AppHeader.dart';
import '../../../core/widgets/AppDrawer/Drawer.dart';
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
        // Compute completion from saved fields for resilience across app restarts
        if (savedState != null) {
          final s = savedState;
          isOtherInfoComplete = _isFsoInfoComplete(s);
          isSampleInfoComplete = _isSampleInfoComplete(s);
          isPreservativeComplete = _isPreservativeInfoComplete(s);
          isSealComplete = _isSealInfoComplete(s);
          isReviewComplete = isOtherInfoComplete && isSampleInfoComplete && isPreservativeComplete && isSealComplete;
        } else {
          isOtherInfoComplete = false;
          isSampleInfoComplete = false;
          isPreservativeComplete = false;
          isSealComplete = false;
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
        '⚠️ Form not filled. Please fill the form.',
        MessageType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SampleFormBloc, SampleFormState>(
      listener: (context, state) async {
        // Update completion status whenever state changes
        final newOtherComplete = _isFsoInfoComplete(state);
        final newSampleComplete = _isSampleInfoComplete(state);
        final newPreservativeComplete = _isPreservativeInfoComplete(state);
        final newSealComplete = _isSealInfoComplete(state);
        final newReviewComplete = newOtherComplete && newSampleComplete && newPreservativeComplete && newSealComplete;

        final changed =
            newOtherComplete != isOtherInfoComplete ||
            newSampleComplete != isSampleInfoComplete ||
            newPreservativeComplete != isPreservativeComplete ||
            newSealComplete != isSealComplete ||
            newReviewComplete != isReviewComplete;

        if (changed) {
          print("🔄 State changed - Other: $newOtherComplete, Sample: $newSampleComplete, Preservative: $newPreservativeComplete, Seal: $newSealComplete, Review: $newReviewComplete");
          setState(() {
            isOtherInfoComplete = newOtherComplete;
            isSampleInfoComplete = newSampleComplete;
            isPreservativeComplete = newPreservativeComplete;
            isSealComplete = newSealComplete;
            isReviewComplete = newReviewComplete;
          });
        }

        // Handle submit states
        if (state.apiStatus == ApiStatus.loading) {
          AppDialog.show(context, "Loading...", MessageType.info);
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
              : '✅ Form VI submitted successfully.';

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
              : 'Form submission failed.';

          // Show error popup
          AppDialog.show(context, errMsg, MessageType.error);
        }

      },
      child: Scaffold(
        backgroundColor: customColors.white,
        appBar: AppHeader(
          screenTitle: 'Form VI',
          // username: 'Rajan',
          userId: 'S1234',
          showBack: false,
        ),
        drawer: CustomDrawer(),

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 50),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Form VI Sections',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                _buildVerticalStepProgress(),
                const SizedBox(height: 15),
                _buildSubmitButton(),
                const SizedBox(height: 15),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalStepProgress() {
    List<Map<String, dynamic>> steps = [
      {
        'title': 'FSO Info',
        'subtitle': 'Food Safety Officer details',
        'icon': Icons.person_outline,
        'isComplete': isOtherInfoComplete,
        'color': Colors.blue,
        'section': 'other',
      },
      {
        'title': 'Sample Info',
        'subtitle': 'Basic sample details',
        'icon': Icons.science_outlined,
        'isComplete': isSampleInfoComplete,
        'color': Colors.green,
        'section': 'sample',
      },
      {
        'title': 'Preservative Info',
        'subtitle': 'Preservative information',
        'icon': Icons.local_pharmacy_outlined,
        'isComplete': isPreservativeComplete,
        'color': Colors.purple,
        'section': 'sample',
      },
      {
        'title': 'Seal Details',
        'subtitle': 'Seal and security details',
        'icon': Icons.security_outlined,
        'isComplete': isSealComplete,
        'color': Colors.orange,
        'section': 'sample',
      },
      {
        'title': 'Review & Submit',
        'subtitle': 'Final review and submission',
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
                if (step['title'] == 'Preservative Info') {
                  initialStep = 1; // Second step for preservative info
                } else if (step['title'] == 'Seal Details') {
                  initialStep = 2; // Third step for seal details
                } else if (step['title'] == 'Review & Submit') {
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

  Widget _buildSubmitButton() {
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
            "Submit Form",
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

// Completion helper functions
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
      s.QuantitySample.isNotEmpty &&
      s.article.isNotEmpty;
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