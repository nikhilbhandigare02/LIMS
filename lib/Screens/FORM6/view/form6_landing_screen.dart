import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_inspector/core/widgets/AppHeader/AppHeader.dart';
import '../bloc/Form6Bloc.dart';
import 'form6_step_screen.dart';

class Form6LandingScreen extends StatefulWidget {
  @override
  State<Form6LandingScreen> createState() => _Form6LandingScreenState();
}

class _Form6LandingScreenState extends State<Form6LandingScreen> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  bool isOtherComplete = false;
  bool isSampleComplete = false;

  @override
  void initState() {
    super.initState();
    loadCompletionStatus();
  }

  Future<void> loadCompletionStatus() async {
    String? other = await secureStorage.read(key: 'form6_other_section');
    String? sample = await secureStorage.read(key: 'form6_sample_section');

    setState(() {
      isOtherComplete = other == 'complete';
      isSampleComplete = sample == 'complete';
    });

    print('🔐 Secure Storage Loaded:');
    print('isOtherComplete: $isOtherComplete');
    print('isSampleComplete: $isSampleComplete');
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

  // Future<void> handleSubmit() async {
  //   if (isOtherComplete && isSampleComplete) {
  //     await secureStorage.deleteAll();
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('✅ Form submitted successfully.'),
  //         backgroundColor: Colors.green,
  //         behavior: SnackBarBehavior.floating,
  //       ),
  //     );
  //
  //     Navigator.pushReplacementNamed(context, '/home');
  //   } else {
  //     showIncompleteMessage();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        screenTitle: 'Form VI',
        username: 'Rajan',
        userId: 'S1234',
      ),
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
                          await secureStorage.write(key: 'form6_other_section', value: 'complete');
                          setState(() => isOtherComplete = true);
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
                          await secureStorage.write(key: 'form6_sample_section', value: 'complete');
                          setState(() => isSampleComplete = true);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // ElevatedButton.icon(
              //   onPressed: handleSubmit,
              //   icon: Icon(Icons.check_circle),
              //   label: Text("Submit Form"),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.teal,
              //     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              //     textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              //   ),
              // ),
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
              color: Colors.black12,
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
              color: isComplete ? Colors.green : Colors.orange,
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
                color: isComplete ? Colors.green : Colors.redAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
