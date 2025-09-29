import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_inspector/config/Themes/colors/colorsTheme.dart';

import '../../../Screens/Sample list/view/SampleList.dart';
import '../../../config/Themes/colors/colorsTheme.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String screenTitle;
  // final String username;
 // final String userId;
  final bool showBack;
  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;
  final List<Widget>? actions;

  const AppHeader({
    super.key,
    required this.screenTitle,
    // required this.username,
   // required this.userId,
    this.showBack = false,
    this.onBackTap,
    this.onMenuTap,
    this.actions
  });

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    Future<String?> loadDisplayName() async {
      try {
        const storage = FlutterSecureStorage();
        final String? jsonString = await storage.read(key: 'loginData');
        if (jsonString == null || jsonString.isEmpty) return null;
        final Map<String, dynamic> data = jsonDecode(jsonString) as Map<String, dynamic>;
        // Prefer fullName/name, else username
        final List<String> keys = ['fullName', 'FullName', 'name', 'Name', 'username', 'Username'];
        for (final k in keys) {
          final dynamic v = data[k];
          if (v == null) continue;
          final String s = v.toString().trim();
          if (s.isNotEmpty) return s;
        }
      } catch (_) {}
      return null;
    }

    return Material(
      elevation: 6,
      shadowColor: customColors.black87.withOpacity(0.3),
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: customColors.primary,
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: customColors.black87.withOpacity(0.2),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (showBack)
                  IconButton(
                    icon: Container(
                      decoration: BoxDecoration(
                        color: customColors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: customColors.black87.withOpacity(0.1),
                            offset: const Offset(0, 2),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child:  Icon(Icons.keyboard_arrow_left_sharp, size: 32, color: customColors.black54),
                    ),
                    onPressed: onBackTap ?? () {
                      // Navigate to SampleAnalysisScreen instead of just popping
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => SampleAnalysisScreen()),
                      );
                    },
                  )
                else
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu, color: customColors.white),
                      onPressed: onMenuTap ?? () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        screenTitle,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: customColors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // FutureBuilder<String?>(
                      //   future: loadDisplayName(),
                      //   builder: (context, snapshot) {
                      //     final displayName = (snapshot.connectionState == ConnectionState.done && (snapshot.data ?? '').isNotEmpty)
                      //         ? snapshot.data!
                      //         : username;
                      //     return Text(
                      //       displayName,
                      //       style: const TextStyle(
                      //         fontSize: 15,
                      //         color: customColors.white,
                      //       ),
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                ),
                if (actions != null) ...actions!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}