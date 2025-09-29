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
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:food_inspector/fcm/bloc/token_bloc.dart';
import '../../../core/utils/enums.dart';

// Preferred biometric enum for UI selection (platform may still present available/default method)
enum PreferredBio { face, fingerprint }

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

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _quickLoginAvailable = false;
  bool _showPasswordOnlyMode = false;
  bool _canCheckBiometrics = false;
  bool _hasBiometricHardware = false;
  bool _biometricEnabled = false;
  String? _lastUsername;
  String? _senderName;
  bool _isInitDone = false; // to avoid initial UI flicker
  List<BiometricType> _availableBiometrics = const [];
  String _biometricButtonText = 'Login with Biometrics';

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

      List<BiometricType> available = const [];
      try {
        if (canCheck && hasHardware) {
          available = await _localAuth.getAvailableBiometrics();
        }
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
        _showPasswordOnlyMode = quick;
        _availableBiometrics = available;
        // Derive button text. On many Android devices, Face Unlock is reported as strong/weak, not explicit Face.
        final hasFace = available.contains(BiometricType.face);
        final hasFingerprint = available.contains(BiometricType.fingerprint);
        final hasGeneric = available.contains(BiometricType.strong) || available.contains(BiometricType.weak);
        if (hasFace && hasFingerprint && !hasGeneric) {
          _biometricButtonText = 'Login with Face or Fingerprint';
        } else if (hasFace && !hasGeneric) {
          _biometricButtonText = 'Login with Face';
        } else if (hasFingerprint && !hasGeneric) {
          _biometricButtonText = 'Login with Fingerprint';
        } else {
          _biometricButtonText = 'Login with Biometrics';
        }
        _isInitDone = true;
      });
      if (quick && lastUsername != null && lastUsername.isNotEmpty) {
        loginBloc.add(UsernameEvent(username: lastUsername));
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isInitDone = true;
      });
    }
  }

  Future<void> _authenticateBiometric(PreferredBio preferred) async {
    try {
      final availableBiometrics = await _localAuth.getAvailableBiometrics();

      print("Available biometrics: $availableBiometrics");

      String reason = "Authenticate to login";

      final hasFace = availableBiometrics.contains(BiometricType.face);
      final hasFingerprint = availableBiometrics.contains(BiometricType.fingerprint);
      final hasGeneric = availableBiometrics.contains(BiometricType.strong) || availableBiometrics.contains(BiometricType.weak);

      // If the user explicitly requested a modality that is not present and there is no generic support, do not fall back silently.
      if (preferred == PreferredBio.face && !hasFace && !hasGeneric) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Face authentication is not available on this device or not enrolled.')),
        );
        return;
      }
      if (preferred == PreferredBio.fingerprint && !hasFingerprint && !hasGeneric) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fingerprint authentication is not available on this device or not enrolled.')),
        );
        return;
      }

      // Tailor the prompt based on user's choice and device capabilities
      if (preferred == PreferredBio.face && hasFace) {
        reason = "Authenticate with Face ID / Face Unlock";
      } else if (preferred == PreferredBio.fingerprint && hasFingerprint) {
        reason = "Authenticate with Fingerprint";
      } else {
        // Generic reporting (Android may return only strong/weak). Inform the user that the system will choose the available method.
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              preferred == PreferredBio.face
                  ? 'This device reports generic biometrics. The system may show Face or Fingerprint based on what is enrolled.'
                  : 'This device reports generic biometrics. The system may show Fingerprint or Face based on what is enrolled.',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
        if (hasFace) {
          reason = "Authenticate with Face ID / Face Unlock";
        } else if (hasFingerprint) {
          reason = "Authenticate with Fingerprint";
        }
      }

      final didAuth = await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      if (!mounted) return;

      if (didAuth) {
        // Success → Navigate
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteName.SampleAnalysisScreen,
              (route) => false,
        );
      } else {
        // User cancelled or failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication failed')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Biometric authentication error: $e')),
      );
      if (e is PlatformException) {
        debugPrint('PlatformException during biometric auth: code=${e.code}, message=${e.message}');
      }
    }
  }

  String _supportedBiometricsLabel() {
    if (_availableBiometrics.isEmpty) return 'No biometrics available on this device';
    final parts = <String>[];
    if (_availableBiometrics.contains(BiometricType.face)) parts.add('Face');
    if (_availableBiometrics.contains(BiometricType.fingerprint)) parts.add('Fingerprint');
    // Some devices may return strong/weak instead of explicit types
    final hasGeneric = _availableBiometrics.contains(BiometricType.strong) || _availableBiometrics.contains(BiometricType.weak);
    if (hasGeneric && parts.isEmpty) {
      parts.add('Face or Fingerprint');
    }
    return 'Supported: ' + parts.join(' • ');
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
          child: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) async {
              if (state.apiStatus == ApiStatus.success) {
                try {
                  final token = await FirebaseMessaging.instance.getToken();
                  if (token != null && token.isNotEmpty) {
                    context.read<TokenBloc>().add(
                          SaveFcmTokenRequested(token: token, platform: 'flutter'),
                        );
                  }
                } catch (_) {}
              }
            },
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
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 15,
                            offset: Offset(5, 5),
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
                          Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/img.png',
                                  height: 150,
                                  fit: BoxFit.contain,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          if (!_isInitDone) ...[
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: CircularProgressIndicator(
                                    color: customColors.primary,
                                    strokeWidth: 2.5,
                                  ),
                                ),
                              ),
                            ),
                          ] else ...[
                            if (_quickLoginAvailable && _biometricEnabled && _canCheckBiometrics && _hasBiometricHardware) ...[
                              Builder(builder: (_) {
                                final hasFace = _availableBiometrics.contains(BiometricType.face);
                                final hasFingerprint = _availableBiometrics.contains(BiometricType.fingerprint);
                                final hasGeneric = _availableBiometrics.contains(BiometricType.strong) || _availableBiometrics.contains(BiometricType.weak);
                                final faceEnabled = hasFace || hasGeneric;
                                final fingerEnabled = hasFingerprint || hasGeneric;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton.icon(
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(color: fingerEnabled ? customColors.primary : Colors.grey.shade400, width: 1.5),
                                              foregroundColor: fingerEnabled ? customColors.primary : Colors.grey,
                                            ),
                                            onPressed: fingerEnabled ? () => _authenticateBiometric(PreferredBio.fingerprint) : null,
                                            icon: const Icon(Icons.fingerprint),
                                            label: const Text('Fingerprint'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        _supportedBiometricsLabel(),
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ],
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  if (!_showPasswordOnlyMode)
                                    EmailInput(
                                      formkey: _formKey,
                                      emailFocusNode: emailFocusNode,
                                    ),
                                  SizedBox(height: 16),
                                  if (_isInitDone)
                                    PasswordInput(
                                      formkey: _formKey,
                                      passwordFocusNode: passFocusNode,
                                    ),
                                  SizedBox(height: 16),
                                  if (!_quickLoginAvailable || !_showPasswordOnlyMode)
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF7F8F9),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Color(0xFF1E3A8A).withOpacity(0.1),
                                        ),
                                      ),
                                      child: CaptchaWidget(controller: _captchaController, key: _captchaKey),
                                    ),
                                  SizedBox(height: 6),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, RouteName.forgotPasswordScreen);
                                      },
                                      child: Text(
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
                            )],
                          SizedBox(height: 10),
                          Center(child: Footer()),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}