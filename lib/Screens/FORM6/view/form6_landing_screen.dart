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

class Form6LandingScreen extends StatefulWidget {
  @override
  State<Form6LandingScreen> createState() => _Form6LandingScreenState();
}

class _Form6LandingScreenState extends State<Form6LandingScreen> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  bool isOtherComplete = false;
  bool isSampleComplete = false;
  final Form6Storage storage = Form6Storage();

  @override
  void initState() {
    super.initState();
    loadCompletionStatus();
  }

  Future<void> loadCompletionStatus() async {
    final savedState = await storage.fetchStoredState();
    setState(() {
      isOtherComplete = savedState?.isOtherInfoComplete ?? false;
      isSampleComplete = savedState?.isSampleInfoComplete ?? false;
    });
  }

  Future<void> handleSubmit() async {
    if (isOtherComplete && isSampleComplete) {
      await storage.clearFormData();
      setState(() {
        isOtherComplete = false;
        isSampleComplete = false;
      });

      Message.showTopRightOverlay(
        context,
        '✅ Form submitted successfully.',
        MessageType.success,
      );
      await Future.delayed(Duration(milliseconds: 300));
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
    return Scaffold(
      backgroundColor: customColors.white,
      appBar: AppHeader(
        screenTitle: 'Form VI',
        username: 'Rajan',
        userId: 'S1234',
      ),
      drawer: CustomDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Form Sections',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                // _buildSectionCard(
                //   title: 'FSO Details',
                //   isComplete: isOtherComplete,
                //   backgroundColor: Colors.blue.shade100,
                //   onTap: () async {
                //     final result = await Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (_) => BlocProvider.value(
                //           value: context.read<SampleFormBloc>(),
                //           child: Form6StepScreen(section: 'other'),
                //         ),
                //       ),
                //     );
                //     if (result == 'completed') {
                //       setState(() => isOtherComplete = true);
                //       await storage.markSectionComplete(section: 'other');
                //     }
                //   },
                // ),
                // _buildSectionCard(
                //   title: 'Sample Details',
                //   isComplete: isSampleComplete,
                //   backgroundColor: Colors.green.shade100,
                //   onTap: () async {
                //     final result = await Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (_) => BlocProvider.value(
                //           value: context.read<SampleFormBloc>(),
                //           child: Form6StepScreen(section: 'sample'),
                //         ),
                //       ),
                //     );
                //     if (result == 'completed') {
                //       setState(() => isSampleComplete = true);
                //       await storage.markSectionComplete(section: 'sample');
                //     }
                //   },
                // ),
                const SizedBox(height: 30),
                _buildVerticalStepProgress(),
                const SizedBox(height: 15),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildSectionCard({
  //   required String title,
  //   required bool isComplete,
  //   required Color backgroundColor,
  //   required VoidCallback onTap,
  // }) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       width: double.infinity,
  //       decoration: BoxDecoration(
  //         color: backgroundColor,
  //         borderRadius: BorderRadius.circular(16),
  //         boxShadow: [
  //           BoxShadow(
  //             color: customColors.black54,
  //             blurRadius: 4,
  //             offset: Offset(2, 2),
  //           ),
  //         ],
  //       ),
  //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               Icon(
  //                 isComplete ? Icons.check_circle : Icons.info_outline,
  //                 size: 30,
  //                 color: isComplete ? customColors.green : customColors.orange,
  //               ),
  //               const SizedBox(width: 12),
  //               Text(
  //                 title,
  //                 style: const TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 8),
  //           Text(
  //             isComplete ? '✅ Complete' : '❌ Incomplete',
  //             style: TextStyle(
  //               fontSize: 14,
  //               color: isComplete ? customColors.green : customColors.redAccent,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildVerticalStepProgress() {
    List<Map<String, dynamic>> steps = [
      {
        'title': 'FSO Info',
        'subtitle': 'Food Safety Officer details',
        'icon': Icons.person_outline,
        'isComplete': isOtherComplete,
        'color': Colors.blue,
        'section': 'other',
        'isSub': false,
      },
      {
        'title': 'Sample Info',
        'subtitle': 'Basic sample details',
        'icon': Icons.science_outlined,
        'isComplete': isSampleComplete,
        'color': Colors.green,
        'section': 'sample',
        'isSub': false,
      },
      {
        'title': 'Preservative Info',
        'subtitle': 'Preservative information',
        'icon': Icons.local_pharmacy_outlined,
        'isComplete': isSampleComplete,
        'color': Colors.purple,
        'section': 'sample',
        'isSub': true,
      },
      {
        'title': 'Seal Details',
        'subtitle': 'Seal and security details',
        'icon': Icons.security_outlined,
        'isComplete': isSampleComplete,
        'color': Colors.orange,
        'section': 'other',
        'isSub': true,
      },
      {
        'title': 'Review & Submit',
        'subtitle': 'Final review and submission',
        'icon': Icons.send_outlined,
        'isComplete': isOtherComplete && isSampleComplete,
        'color': Colors.indigo,
        'section': 'sample',
        'isSub': false,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Column(
          children: List.generate(steps.length, (index) {
            final step = steps[index];
            final isLast = index == steps.length - 1;
            final isSub = step['isSub'] == true;

            return InkWell(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<SampleFormBloc>(),
                      child: Form6StepScreen(section: step['section']),
                    ),
                  ),
                );

                if (result == 'completed') {
                  await loadCompletionStatus();
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Indicator + line
                  Column(
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: Center(
                          child: isSub
                              ? Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.shade500,
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ),
                          )
                              : Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: step['isComplete']
                                  ? step['color']
                                  : Colors.grey.shade300,
                              shape: BoxShape.circle,
                              boxShadow: step['isComplete']
                                  ? [
                                BoxShadow(
                                  color: step['color']
                                      .withOpacity(0.3),
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
                                  ? Colors.white
                                  : Colors.grey.shade600,
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
                              : Colors.grey.shade300,
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
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: step['isComplete']
                              ? step['color'].withOpacity(0.2)
                              : Colors.grey.shade200,
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
                                  fontSize: isSub ? 14 : 16,
                                  fontWeight: FontWeight.w600,
                                  color: step['isComplete']
                                      ? step['color']
                                      : Colors.grey.shade800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                step['subtitle'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
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
                                : Colors.grey.shade400,
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
      child: (isOtherComplete && isSampleComplete)
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
        color: Colors.red.shade50,
        margin: const EdgeInsets.only(top: 10),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 12.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Form not filled. Please fill the form.',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
