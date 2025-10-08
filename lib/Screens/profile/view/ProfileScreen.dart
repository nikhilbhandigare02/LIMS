import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_inspector/l10n/app_localizations.dart';

import '../../../config/Themes/colors/colorsTheme.dart';

class UserProfileScreen extends StatefulWidget {
  final VoidCallback? onBackTap;

  const UserProfileScreen({super.key, this.onBackTap});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  String _fullName = 'John Doe';
  String _username = 'john.doe';
  String _doNumber = 'DO-2024-001234';
  String _email = 'john.doe@example.com';
  final String _designation = 'Food Safety Officer';

  @override
  void initState() {
    super.initState();
    _loadUserFromSecureStorage();
  }

  Future<void> _loadUserFromSecureStorage() async {
    try {
      final String? jsonString = await _secureStorage.read(key: 'loginData');
      if (jsonString == null || jsonString.isEmpty) return;

      final Map<String, dynamic> data = _tryParseJson(jsonString);

      String? fullName = _firstNonEmpty(data, ['fullName', 'FullName', 'name', 'Name']);
      String? username = _firstNonEmpty(data, ['username', 'Username', 'userName', 'UserName']);
      String? email = _firstNonEmpty(data, ['email', 'Email']);
      String? doNumber = _firstNonEmpty(data, ['doNumber', 'DONumber', 'DoNumber', 'do_no', 'doNo', 'DoNo']);

      setState(() {
        if (fullName != null) _fullName = fullName;
        if (username != null) _username = username;
        if (email != null) _email = email;
        if (doNumber != null) _doNumber = doNumber;
      });
    } catch (e) {
      print('Failed to load user from secure storage: $e');
    }
  }

  Map<String, dynamic> _tryParseJson(String jsonString) {
    try {
      return (jsonDecode(jsonString) as Map).cast<String, dynamic>();
    } catch (_) {
      return {};
    }
  }

  String? _firstNonEmpty(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final dynamic value = map[key];
      if (value == null) continue;
      final String s = value.toString().trim();
      if (s.isNotEmpty) return s;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: CurvedClipper(),
                  child: Container(
                    height: screenHeight * 0.35,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: customColors.primary,
                      // gradient: LinearGradient(
                      //   colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
                      //   begin: Alignment.topLeft,
                      //   end: Alignment.bottomRight,
                      // ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Positioned(
                  top: 25,
                  left: screenWidth * 0.06,
                  child: IconButton(
                    icon: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, 2),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.keyboard_arrow_left_sharp,
                        size: 38,
                        color: Colors.black54,
                      ),
                    ),
                    onPressed: widget.onBackTap ?? () => Navigator.of(context).pop(),
                  ),
                ),
                Container(
                  height: screenHeight * 0.35,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: screenHeight * 0.08),
                  child: Column(
                    children: [
                      // Profile Image
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 15,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: screenWidth * 0.12,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: screenWidth * 0.15,
                            color:   customColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _fullName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _designation,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Bottom Cards Section
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.06),
              child: Column(
                children: [
                  _buildInfoCard(
                    icon: Icons.person_outline,
                    title: AppLocalizations.of(context)!.fullName,
                    value: _fullName,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    icon: Icons.alternate_email,
                    title: AppLocalizations.of(context)!.username,
                    value: _username,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    icon: Icons.badge_outlined,
                    title: AppLocalizations.of(context)!.officialDesignation,
                    value: _designation,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    icon: Icons.email_outlined,
                    title: AppLocalizations.of(context)!.email,
                    value: _email,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    IconData? actionIcon,
    VoidCallback? onActionTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E88E5).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF1E88E5),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          if (actionIcon != null && onActionTap != null)
            IconButton(
              onPressed: onActionTap,
              icon: Icon(
                actionIcon,
                color: const Color(0xFF1E88E5),
                size: 20,
              ),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFF1E88E5).withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 20,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
