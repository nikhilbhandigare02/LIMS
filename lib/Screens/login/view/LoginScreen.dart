import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_inspector/Screens/login/repository/loginRepository.dart';
import 'package:food_inspector/config/Routes/RouteName.dart';
import '../../../core/utils/footer.dart';
import '../../../core/widgets/RegistrationInput/Curved.dart';
import '../../../core/widgets/loginWidgets/CaptchaWidget.dart';
import '../../../core/widgets/loginWidgets/EmailInputWidget.dart';
import '../../../core/widgets/loginWidgets/PasswordInputWidget.dart';
import '../../../core/widgets/loginWidgets/submitButton.dart';
import '../bloc/loginBloc.dart';
import '../../../config/Themes/colors/colorsTheme.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class LoginScreen extends StatefulWidget {
   LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  late LoginBloc loginBloc;
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _captchaController = TextEditingController();
  final GlobalKey<CaptchaWidgetState> _captchaKey = GlobalKey<CaptchaWidgetState>();

  // Quick login state
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _quickLoginAvailable = false;
  bool _showPasswordOnlyMode = false; // when true, hide username and use lastUsername
  bool _canCheckBiometrics = false;
  bool _hasBiometricHardware = false;
  bool _biometricEnabled = false; // persisted user choice
  String? _lastUsername;
  String? _senderName;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    loginBloc = LoginBloc(loginRepository: LoginRepository());

    // Initialize animations
    _fadeController = AnimationController(
      duration:  Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration:  Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin:  Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    _fadeController.forward();
    _slideController.forward();

    // Load quick login info
    _initQuickLogin();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }


  Future<void> _initQuickLogin() async {
    try {
      final String? isLogin = await _secureStorage.read(key: 'isLogin');
      final String? lastUsername = await _secureStorage.read(key: 'lastUsername');
      final String? senderName = await _secureStorage.read(key: 'sender name');
      final String? biometricEnabled = await _secureStorage.read(key: 'biometricEnabled');
  
      bool canCheck = false;
      bool hasHardware = false;
      try {
        canCheck = await _localAuth.canCheckBiometrics;
        hasHardware = await _localAuth.isDeviceSupported();
      } catch (_) {}

      final bool quick = (isLogin == '1' && (lastUsername != null && lastUsername.isNotEmpty));
      if (!mounted) return;
      setState(() {
        _lastUsername = lastUsername;
        _senderName = senderName ?? lastUsername;
        _canCheckBiometrics = canCheck;
        _hasBiometricHardware = hasHardware;
        _quickLoginAvailable = quick;
        _biometricEnabled = (biometricEnabled == '1');
        _showPasswordOnlyMode = quick; // Default to password-only mode for returning users
      });
      // Prefill bloc username with lastUsername for password-only quick login
      if (quick && lastUsername != null && lastUsername.isNotEmpty) {
        loginBloc.add(UsernameEvent(username: lastUsername));
      }
    } catch (e) {
      // ignore and keep quick login disabled
    }
  }

  Future<void> _handleBiometricLogin() async {
    try {
      final didAuth = await _localAuth.authenticate(
        localizedReason: 'Authenticate to login',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (!mounted) return;
      if (didAuth) {
        // On successful biometric auth, proceed to the main screen
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteName.SampleAnalysisScreen,
          (route) => false,
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Biometric authentication failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [
          //     Color(0xFF60A5FA),
          //     Color(0xFF3B82F6),
          //     Color(0xFF60A5FA),
          //   ],
          // ),
        ),
        child: BlocProvider(
          create: (_) => loginBloc,
          child: SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: ListView(
                  padding:  EdgeInsets.symmetric(horizontal: 16),
                  children: [
                     SizedBox(height: 30),

                    Container(
                      padding:  EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 15,
                            offset:  Offset(5, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                           SizedBox(height: 10),

                           Text(
                            _quickLoginAvailable && _senderName != null && _senderName!.isNotEmpty
                                ? "Welcome, ${_senderName!}"
                                : "Login Here",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF130160),
                            ),
                          ),
                           SizedBox(height: 8),
                           Text(
                            _quickLoginAvailable
                                ? "You can login using biometrics or password."
                                : "Authorized Personnel Only",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          //  SizedBox(height: 10),

                          Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/img.png',
                                  height: 150,
                                  // width: 60,
                                  fit: BoxFit.contain,
                                ),

                               ],
                            ),
                          ),

                           SizedBox(height: 10),

                          // Quick login actions (only if user has enabled biometrics)
                          if (_quickLoginAvailable && _biometricEnabled && _canCheckBiometrics && _hasBiometricHardware) ...[
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: customColors.primary,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: _handleBiometricLogin,
                                icon: const Icon(Icons.fingerprint),
                                label: const Text('Login with Biometrics'),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],

                          // Form with updated styling
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Email Input with new styling
                                if (!_showPasswordOnlyMode) 
                                  Container(
                                    child: EmailInput(
                                      formkey: _formKey,
                                      emailFocusNode: emailFocusNode,
                                    ),
                                  ),
                                 SizedBox(height: 16),

                                Container(
                                  child: PasswordInput(
                                    formkey: _formKey,
                                    passwordFocusNode: passFocusNode,
                                  ),
                                ),
                                 SizedBox(height: 16),

                                if (!_quickLoginAvailable || !_showPasswordOnlyMode)
                                  Container(
                                    decoration: BoxDecoration(
                                      color:  Color(0xFFF7F8F9),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color:  Color(0xFF1E3A8A).withOpacity(0.1),
                                      ),
                                    ),
                                    child: CaptchaWidget(controller: _captchaController, key: _captchaKey),
                                  ),
                                 SizedBox(height: 6),

                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, RouteName.forgotPasswordScreen);
                                    },
                                    child:  Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                        color: customColors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),

                                 SizedBox(height: 6),

                                LoginButton(
                                  formkey: _formKey,
                                  onLoginSuccess: () {
                                    _captchaController.clear();
                                    _captchaKey.currentState?.refreshCaptcha();
                                  },
                                ),
                                if (_showPasswordOnlyMode && !_quickLoginAvailable)
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _showPasswordOnlyMode = false;
                                      });
                                    },
                                    child: const Text('Use different username'),
                                  ),
                              ],
                            ),
                          ),

                           SizedBox(height: 10),

                          Center(
                            // child: TextButton(
                            //   onPressed: () {
                            //     Navigator.pushNamed(context, RouteName.registerScreen);
                            //   },
                            //   child:  Text.rich(
                            //     TextSpan(
                            //       text: "Don't have an account? ",
                            //       style: TextStyle(color: Colors.black),
                            //       children: [
                            //         TextSpan(
                            //           text: "Create one",
                            //           style: TextStyle(
                            //             color: customColors.primary,
                            //             fontWeight: FontWeight.bold,
                            //           ),
                            //         )
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            child:  Footer(),
                          ),
                        ],
                      ),
                    ),
                     SizedBox(height: 30),
                  ]
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}