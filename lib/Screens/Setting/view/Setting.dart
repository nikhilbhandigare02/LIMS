import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../l10n/locale_notifier.dart';
import '../../../config/Routes/RouteName.dart';
import '../../../core/widgets/AppDrawer/Drawer.dart';
import '../../../core/widgets/AppHeader/AppHeader.dart';
import '../../update_password/view/UpdatePassword.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool _isBiometricEnabled = false;
  String _selectedLanguage = 'English';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadBiometricPref();
    _loadLanguagePref();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppHeader(
        screenTitle: AppLocalizations.of(context)?.settingsTitle ?? "Setting",

        showBack: false,
      ),
      drawer: CustomDrawer(),

      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          _buildListTile(
            icon: Icons.person_outline,
            title: 'My Profile',
            onTap: () {
              Navigator.pushNamed(context, RouteName.profileScreen);
            },
          ),
          Divider(height: 1, thickness: 0.5, color: Colors.grey[300]),
          _buildListTile(
            icon: Icons.lock_outline,
            title: 'Update Password',
            onTap: () {
              Navigator.pushNamed(context, RouteName. updateScreen);
            },
          ),
          _buildBiometricTile(context), // <-- biometric tile
          Divider(height: 1, thickness: 0.5, color: Colors.grey[300]),
          _buildLanguageTile(context),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap, 
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF1E88E5)),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        hoverColor: Colors.grey[100],
      ),
    );
  }

  Future<void> _loadBiometricPref() async {
    final value = await _storage.read(key: 'biometricEnabled');
    setState(() {
      _isBiometricEnabled = value == '1'; // default false if null
    });
  }

  Future<void> _toggleBiometric(bool enable) async {
    setState(() {
      _isBiometricEnabled = enable;
    });

    // Save state in secure storage
    await _storage.write(
      key: 'biometricEnabled',
      value: enable ? '1' : '0',
    );

    if (enable) {
      print("✅ Biometric Enabled");
      // here you can call local_auth to authenticate user before enabling
    } else {
      print("❌ Biometric Disabled");
    }
  }
  Future<void> _loadLanguagePref() async {
    final value = await _storage.read(key: 'appLanguage');
    setState(() {
      _selectedLanguage = value ?? 'English';
    });
  }

  Future<void> _saveLanguagePref(String language) async {
    await _storage.write(key: 'appLanguage', value: language);
    setState(() {
      _selectedLanguage = language;
    });
  }
  Widget _buildBiometricTile(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            // Leading icon
            Container(
              margin: const EdgeInsets.only(left: 16),
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.fingerprint, color: Colors.white, size: 20),
            ),

            const SizedBox(width: 16),

            // Title
            Expanded(
              child: Text(
                AppLocalizations.of(context)?.biometricAuthentication ?? "Biometric Authentication",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),

            // Switch at the far end
            Transform.scale(
              scale: 0.9,
              child: Switch(
                value: _isBiometricEnabled,
                onChanged: _toggleBiometric,
                activeColor: const Color(0xFF1E88E5),
                activeTrackColor: const Color(0xFF1E88E5).withOpacity(0.5),
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.grey.shade400,
              ),
            ),
            const SizedBox(width: 16), // right padding
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.language, color: Colors.white, size: 20),
        ),
        title: Text(
          AppLocalizations.of(context)?.language ?? 'Language',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(_selectedLanguage),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF1E88E5)),
        onTap: _showLanguageSelector,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        hoverColor: Colors.grey[100],
      ),
    );
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Choose Language',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),
              _languageOption('Marathi'),
              _languageOption('Hindi'),
              _languageOption('English'),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _languageOption(String language) {
    final isSelected = _selectedLanguage == language;
    return ListTile(
      title: Text(language),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: Color(0xFF1E88E5))
          : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
      onTap: () async {
        await _saveLanguagePref(language);
        // Update global app locale for live switch
        switch (language.toLowerCase()) {
          case 'hindi':
            appLocale.value = const Locale('hi');
            break;
          case 'marathi':
            appLocale.value = const Locale('mr');
            break;
          default:
            appLocale.value = const Locale('en');
        }
        if (mounted) Navigator.pop(context);
      },
    );
  }
}