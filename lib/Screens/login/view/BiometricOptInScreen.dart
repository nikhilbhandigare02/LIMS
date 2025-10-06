import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';
import 'package:food_inspector/Screens/login/view/permission_screen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:food_inspector/config/Routes/RouteName.dart';
import 'package:food_inspector/config/Themes/colors/colorsTheme.dart';

import '../../../l10n/app_localizations.dart';

class BiometricOptInScreen extends StatefulWidget {
  const BiometricOptInScreen({Key? key}) : super(key: key);

  @override
  State<BiometricOptInScreen> createState() => _BiometricOptInScreenState();
}

class _BiometricOptInScreenState extends State<BiometricOptInScreen> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _supported = false;
  bool _hasFace = false;
  bool _hasFingerprint = false;
  bool _authenticating = false;
  bool _canCheckBiometrics = false;

  @override
  void initState() {
    super.initState();
    _checkSupport();
  }

  Future<void> _checkSupport() async {
    try {
      // Check if device supports biometrics
      _canCheckBiometrics = await _localAuth.canCheckBiometrics;
      _supported = await _localAuth.isDeviceSupported();

      if (_supported && _canCheckBiometrics) {
        final available = await _localAuth.getAvailableBiometrics();

        if (!mounted) return;
        setState(() {
          _hasFace = available.contains(BiometricType.face) ||
              available.contains(BiometricType.face);
          _hasFingerprint = available.contains(BiometricType.fingerprint) ||
              available.contains(BiometricType.strong) ||
              available.contains(BiometricType.weak);
        });
      }
    } on PlatformException catch (e) {
      print("Biometric check error: ${e.message}");
      if (!mounted) return;
      setState(() {
        _supported = false;
      });
    } catch (e) {
      print("Unexpected error: $e");
      if (!mounted) return;
      setState(() {
        _supported = false;
      });
    }
  }

  Future<void> _navigateAfterBiometricChoice() async {
    try {
      final perm = await _storage.read(key: 'permissionGranted');
      final needsPermission = (perm != '1');

      if (!mounted) return;
      if (needsPermission) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PermissionScreen(
              onContinue: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteName.SampleAnalysisScreen,
                      (route) => false,
                );
              },
            ),
          ),
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteName.SampleAnalysisScreen,
              (route) => false,
        );
      }
    } catch (_) {
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteName.SampleAnalysisScreen,
            (route) => false,
      );
    }
  }

  Future<void> _onChoose(bool enable) async {
    try {
      await _storage.write(key: 'biometricEnabled', value: enable ? '1' : '0');
      await _storage.write(key: 'isLogin', value: '1');

      if (!mounted) return;
      await _navigateAfterBiometricChoice();
    } catch (e) {
      print("Storage error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)?.errorSavingPreferences ?? 'Error saving preferences')),
      );
    }
  }

  Future<void> _authenticateAndEnable() async {
    if (!_supported || !_canCheckBiometrics) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)?.biometricNotSupported ?? 'Biometric authentication not supported on this device.')),
      );
      return;
    }

    setState(() => _authenticating = true);

    try {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: _hasFace
            ? (AppLocalizations.of(context)?.biometricFaceDesc ?? 'Authenticate with Face ID to enable quick sign-in')
            : (AppLocalizations.of(context)?.biometricFingerprintDesc ?? 'Authenticate with fingerprint to enable quick sign-in'),
        authMessages: [
          AndroidAuthMessages(
            signInTitle: AppLocalizations.of(context)?.authRequiredTitle ?? 'Authentication Required',
            biometricHint: '',
            biometricNotRecognized: AppLocalizations.of(context)?.biometricNotRecognized ?? 'Biometric not recognized. Try again.',
            biometricRequiredTitle: AppLocalizations.of(context)?.biometricRequiredTitle ?? 'Biometric required',
            cancelButton: AppLocalizations.of(context)?.cancel ?? 'Cancel',
          ),
        ],
        options: const AuthenticationOptions(
          biometricOnly: true, // Force biometric only (no fallback to device credentials)
          stickyAuth: true,
          useErrorDialogs: true, // Let system handle error dialogs
          sensitiveTransaction: false,
        ),
      );

      if (!mounted) return;

      if (didAuthenticate) {
        await _onChoose(true);
      } else {
        setState(() => _authenticating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)?.authCanceledOrFailed ?? 'Authentication canceled or failed.')),
        );
      }
    } on PlatformException catch (e) {
      if (!mounted) return;
      setState(() => _authenticating = false);

      String message = AppLocalizations.of(context)?.authErrorOccurred ?? 'Authentication error occurred.';
      switch (e.code) {
        case 'NotAvailable':
          message = AppLocalizations.of(context)?.biometricNotAvailable ?? 'Biometric authentication is not available.';
          break;
        case 'NotEnrolled':
          message = _hasFace
              ? (AppLocalizations.of(context)?.noFaceEnrolled ?? 'No face biometric enrolled. Please set up Face ID in device settings.')
              : (AppLocalizations.of(context)?.noFingerprintEnrolled ?? 'No fingerprint enrolled. Please set up fingerprint in device settings.');
          break;
        case 'LockedOut':
          message = AppLocalizations.of(context)?.biometricLockedTemporary ?? 'Biometric authentication is temporarily locked. Try again later or use passcode.';
          break;
        case 'PermanentlyLockedOut':
          message = AppLocalizations.of(context)?.biometricLockedPermanent ?? 'Biometric authentication is permanently locked. Please set up new biometrics.';
          break;
        case 'PasscodeNotSet':
          message = AppLocalizations.of(context)?.passcodeNotSet ?? 'Device passcode is not set. Please set a device passcode to use biometric authentication.';
          break;
        case 'NotInteractive':
        case 'Failed':
          message = AppLocalizations.of(context)?.authFailedTryAgain ?? 'Authentication failed. Please try again.';
          break;
        default:
          message = e.message ?? (AppLocalizations.of(context)?.unknownErrorOccurred ?? 'Unknown error occurred.');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _authenticating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)?.unableToStartBiometric ?? 'Unable to start biometric authentication.')),
      );
    }
  }

  // Add this method to test biometric functionality
  Future<void> _testBiometric() async {
    try {
      final available = await _localAuth.getAvailableBiometrics();
      print("Available biometrics: $available");
      print("Device supported: ${await _localAuth.isDeviceSupported()}");
      print("Can check biometrics: ${await _localAuth.canCheckBiometrics}");
    } catch (e) {
      print("Test error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            // Middle section
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Test button for debugging (remove in production)
                    if (kDebugMode)
                      TextButton(
                        onPressed: _testBiometric,
                        child: Text(l10n?.debugTestBiometric ?? 'Debug: Test Biometric'),
                      ),

                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: customColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _hasFace ? Icons.face : Icons.fingerprint,
                        size: 100,
                        color: customColors.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      AppLocalizations.of(context)!.biometricAuthentication,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF130160),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        _hasFace
                            ? (AppLocalizations.of(context)!.biometricFaceDesc ?? "Enable Face ID for faster and secure login. You can still use your password anytime.")
                            : (l10n?.biometricFingerprintDesc ?? "Enable fingerprint authentication for faster and secure login. You can still use your password anytime."),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Warning box
            if (!_supported)
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, color: Colors.orange),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        (l10n?.biometricNotAvailableWarning ?? 'Biometric authentication is not available on this device. You can enable it later if supported.'),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Bottom buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: customColors.primary, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _authenticating ? null : () => _onChoose(false),
                      child: Text(
                        l10n?.notNow ?? "Not now",
                        style: TextStyle(color: customColors.primary, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: customColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      onPressed: (_supported && !_authenticating) ? _authenticateAndEnable : null,
                      icon: _authenticating
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                          : Icon(_hasFace ? Icons.face : Icons.fingerprint, size: 22),
                      label: Text(
                        _authenticating
                            ? (AppLocalizations.of(context)!.biometricAuthentication ?? 'Authenticating...')
                            : (l10n?.enable ?? 'Enable'),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}