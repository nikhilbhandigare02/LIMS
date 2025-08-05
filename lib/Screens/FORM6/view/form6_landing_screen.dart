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
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Form Sections',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
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
                const SizedBox(height: 30),
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
        'isComplete': isOtherComplete,
        'isSub': false,
        'section': 'other',
      },
      {
        'title': 'Sample Info',
        'isComplete': isSampleComplete,
        'isSub': false,
        'section': 'sample',
      },
      {
        'title': 'Preservative Info',
        'isComplete': isSampleComplete,
        'isSub': true,
        'section': 'preservative',
      },
      {
        'title': 'Seal Details',
        'isComplete': isOtherComplete,
        'isSub': true,
        'section': 'seal',
      },
      {
        'title': 'Review & Submit',
        'isComplete': isSampleComplete,
        'isSub': false,
        'section': 'review',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progress',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Column(
            children: List.generate(steps.length, (index) {
              final step = steps[index];
              final isLast = index == steps.length - 1;

              return InkWell(
                onTap: () {
                  if (step['section'] != 'review') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<SampleFormBloc>(),
                          child: Form6StepScreen(section: step['section']),
                        ),
                      ),
                    );
                  }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // MARKER + VERTICAL LINE
                    Column(
                      children: [
                        Container(
                          width: 24,
                          height: 35,
                          alignment: Alignment.center,
                          child: step['isSub']
                              ? Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: step['isComplete']
                                  ? Colors.green
                                  : Colors.redAccent,
                            ),
                          )
                              : CircleAvatar(
                            radius: 12,
                            backgroundColor: step['isComplete']
                                ? Colors.green
                                : Colors.redAccent,
                            child: Icon(
                              step['isComplete']
                                  ? Icons.check
                                  : Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        // Animated line
                        if (!isLast)
                          AnimatedContainer(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                            width: 2,
                            height: 40,
                            decoration: BoxDecoration(
                              color: step['isComplete']
                                  ? Colors.green
                                  : Colors.grey.shade400,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),

                    // TITLE + RIGHT ICON
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              step['title'],
                              style: TextStyle(
                                fontSize: step['isSub'] ? 14 : 18,
                                fontWeight: step['isSub']
                                    ? FontWeight.normal
                                    : FontWeight.w600,
                                color: step['isComplete']
                                    ? Colors.green
                                    : Colors.redAccent,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey.shade600,
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
          ? Center(
            child: ElevatedButton.icon(
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
            textStyle:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
          )
          : Container(
        key: const ValueKey("warningText"),
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text(
              'Form not filled. Please fill the form.',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
