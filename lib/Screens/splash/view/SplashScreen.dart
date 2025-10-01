import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../config/Themes/colors/colorsTheme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/Routes/RouteName.dart';
import '../bloc/UpdateAppBloc.dart';
import '../bloc/UpdateAppEvent.dart';
import '../bloc/UpdateAppState.dart';
import '../repository/UpdateAppRepository.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with TickerProviderStateMixin {
  late final UpdateAppBloc _updateBloc;
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _fadeController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize BLoC and trigger update check
    _updateBloc = UpdateAppBloc(UpdateAppRepository());
    _updateBloc.add(const CheckForUpdate());

    // Initialize animation controllers
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Define animations
    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    // Start animations
    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    _textController.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _updateBloc.close();
    _logoController.dispose();
    _textController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _updateBloc,
      child: Scaffold(
        backgroundColor: customColors.white,
        body: BlocListener<UpdateAppBloc, UpdateAppState>(
          listener: (context, state) async {
            if (state is UpdateAppUpToDate) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouteName.loginScreen,
                (route) => false,
              );
            } else if (state is UpdateAppFailure) {
              // On failure, proceed to login
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouteName.loginScreen,
                (route) => false,
              );
            } else if (state is UpdateAppUpdateAvailable) {
              _showUpdateDialog(context, state.update);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  customColors.white,
                  Colors.blue[50]!,
                  Colors.blue[100]!,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo Animation
                          ScaleTransition(
                            scale: _logoAnimation,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: customColors.primary,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: customColors.primary.withOpacity(
                                      0.3,
                                    ),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.science,
                                size: 60,
                                color: customColors.white,
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // App Name Animation
                          SlideTransition(
                            position:
                                Tween<Offset>(
                                  begin: const Offset(0, 0.5),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _textController,
                                    curve: Curves.easeOut,
                                  ),
                                ),
                            child: FadeTransition(
                              opacity: _textAnimation,
                              child: Column(
                                children: [
                                  Text(
                                    'LIMS',
                                    style: TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: customColors.primary,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Laboratory Information Management System',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: customColors.grey600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Section
                  Expanded(
                    flex: 1,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          // Food Testing Icons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildFeatureIcon(
                                Icons.local_dining,
                                'Food Testing',
                              ),
                              const SizedBox(width: 30),
                              _buildFeatureIcon(Icons.science, 'Lab Analysis'),
                              const SizedBox(width: 30),
                              _buildFeatureIcon(
                                Icons.verified,
                                'Quality Control',
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          // Loading Indicator
                          Container(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                customColors.primary,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Text(
                            'Loading...',
                            style: TextStyle(
                              fontSize: 14,
                              color: customColors.grey600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: customColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: customColors.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Icon(icon, size: 24, color: customColors.primary),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: customColors.grey600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showUpdateDialog(BuildContext context, dynamic update) {
    final bool mandatory = update.isMandatory ?? false;

    showDialog(
      barrierDismissible: false, // **DO NOT CLOSE ON OUTSIDE TAP**
      context: context,
      builder: (_) {
        return WillPopScope(
          onWillPop: () async => !mandatory, // **Back button only allowed for non-mandatory**
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: SizedBox(
                      height: 160,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Lottie.asset(
                          "assets/animations/App_update_animation.json",
                          repeat: true,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    update.updateTitle ?? "Update Available",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    update.updateDescription ??
                        "A new version of the app is available. Please update to continue.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (!mandatory)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade400,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 12,
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              RouteName.loginScreen,
                                  (route) => false,
                            );
                          },
                          child:  Row(
                            children: [
                              // Icon(Icons.skip, color: Colors.white,),
                              // SizedBox(width: 4,),
                              Text(
                                "Later",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: customColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 12,
                          ),
                          elevation: 3,
                          shadowColor: customColors.primary.withOpacity(0.3),
                        ),
                        onPressed: () async {
                          final url = update.downloadUrl as String?;
                          if (url != null && await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(
                              Uri.parse(url),
                              mode: LaunchMode.externalApplication,
                            );
                          }
                          if (!mandatory) Navigator.pop(context);
                        },
                        child:  Row(
                          children: [
                            // Icon(Icons.update, color: Colors.white,),
                            // SizedBox(width: 4,),
                            Text(
                              "Update",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
   }
