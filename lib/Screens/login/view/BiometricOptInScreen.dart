import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:food_inspector/config/Routes/RouteName.dart';
import 'package:food_inspector/config/Themes/colors/colorsTheme.dart';

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

  @override
  void initState() {
    super.initState();
    _checkSupport();
  }

  Future<void> _checkSupport() async {
    bool canCheck = false;
    bool supported = false;
    List<BiometricType> available = const [];
    try {
      canCheck = await _localAuth.canCheckBiometrics;
      supported = await _localAuth.isDeviceSupported();
      if (canCheck && supported) {
        available = await _localAuth.getAvailableBiometrics();
      }
    } catch (_) {}
    if (!mounted) return;
    setState(() {
      _supported = (canCheck && supported);
      _hasFace = available.contains(BiometricType.face);
      _hasFingerprint = available.contains(BiometricType.fingerprint);
    });
  }

  Future<void> _onChoose(bool enable) async {
    await _storage.write(key: 'biometricEnabled', value: enable ? '1' : '0');
    await _storage.write(key: 'isLogin', value: '1');
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteName.SampleAnalysisScreen,
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            // 📌 Middle section (logo + text)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                      "Quick & Secure Sign-in",
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
                            ? "Enable biometric authentication (Face ID / Face Unlock) for faster login. You can still use your password anytime."
                            : "Enable biometric authentication (Touch ID / Fingerprint) for faster login. You can still use your password anytime.",
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

            // 📌 Warning box if biometrics not supported
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
                        'Biometric authentication is not available on this device. '
                            'You can enable it later if supported.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // 📌 Bottom buttons
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
                      onPressed: () => _onChoose(false),
                      child: Text(
                        "Not now",
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
                      onPressed: _supported ? () => _onChoose(true) : null,
                      icon: Icon(_hasFace ? Icons.face : Icons.fingerprint, size: 22),
                      label: const Text(
                        "Enable",
                        style: TextStyle(fontSize: 16),
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
