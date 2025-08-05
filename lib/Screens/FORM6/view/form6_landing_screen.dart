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
  // Future<void> handleSubmit() async {
  //   if (isOtherComplete && isSampleComplete) {
  //     await secureStorage.deleteAll(); // 🧹 Clear everything
  //     Message.showTopRightOverlay(context, '✅ Form submitted successfully.', MessageType.success);
  //
  //     Navigator.pop(context);
  //   } else {
  //     showIncompleteMessage();
  //   }
  // }

  Future<void> handleSubmit() async {
    if (isOtherComplete && isSampleComplete) {
      await storage.clearFormData();
      Message.showTopRightOverlay(
        context,
        '✅ Form submitted successfully.',
        MessageType.success,
      );
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => SampleFormBloc(form6repository: Form6Repository()),
          child: Form6LandingScreen(),
        ),
      ));
    } else {
      Message.showTopRightOverlay(
        context,
        '⚠️ Please fill all form sections.',
        MessageType.error,
      );
    }
  }
  void showIncompleteMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('⚠️ Please fill both sections before submitting.'),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 600,
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  children: [
                    _buildSectionCard(
                      title: 'FSO Details',
                      isComplete: isOtherComplete,
                      backgroundColor: Colors.blue.shade100,
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<SampleFormBloc>(),
                              child: Form6StepScreen(section: 'other'),
                            ),
                          ),
                        );
                        if (result == 'completed') {
                          setState(() => isOtherComplete = true);
                          await storage.markSectionComplete(section: 'other');
                        }

                      },
                    ),
                    _buildSectionCard(
                      title: 'Sample Details',
                      isComplete: isSampleComplete,
                      backgroundColor: Colors.green.shade100,
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<SampleFormBloc>(),
                              child: Form6StepScreen(section: 'sample'),
                            ),
                          ),
                        );
                        if (result == 'completed') {
                          setState(() => isSampleComplete = true);
                          await storage.markSectionComplete(section: 'sample');
                        }

                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              if (isOtherComplete && isSampleComplete)
                ElevatedButton.icon(
                  onPressed: () async {
                    final storage = Form6Storage();

                    if (isOtherComplete && isSampleComplete) {
                      await storage.clearFormData(); // ✅ Clear only Form VI fields

                      Message.showTopRightOverlay(
                        context,
                        '✅ Form submitted successfully.',
                        MessageType.success,
                      );

                      await Future.delayed(Duration(milliseconds: 300)); // let storage clear

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
                  },
                  icon: Icon(Icons.check_circle, color: customColors.white),
                  label: Text(
                    "Submit Form",
                    style: TextStyle(color: customColors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customColors.primary,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              if (!isOtherComplete || !isSampleComplete)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    '⚠️ Form not filled. Please fill the form.',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required bool isComplete,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: customColors.black54,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isComplete ? Icons.check_circle : Icons.info_outline,
              size: 40,
              color: isComplete ? customColors.green : customColors.orange,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              isComplete ? '✅ Complete' : '❌ Incomplete',
              style: TextStyle(
                fontSize: 14,
                color: isComplete ? customColors.green : customColors.redAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
