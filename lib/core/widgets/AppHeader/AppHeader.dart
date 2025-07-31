import 'package:flutter/material.dart';
import 'package:food_inspector/config/Themes/colors/colorsTheme.dart';

import '../../../config/Themes/colors/colorsTheme.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String screenTitle;
  final String username;
  final String userId;
  final bool showBack;
  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;

  const AppHeader({
    super.key,
    required this.screenTitle,
    required this.username,
    required this.userId,
    this.showBack = false,
    this.onBackTap,
    this.onMenuTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
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
                      child:  Icon(Icons.keyboard_arrow_left_sharp, size: 32, color: customColors.black87),
                    ),
                    onPressed: onBackTap ?? () => Navigator.of(context).pop(),
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
                      Text(
                        "$username • ID: $userId",
                        style: const TextStyle(
                          fontSize: 15,
                          color: customColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
