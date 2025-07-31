import 'package:flutter/material.dart';
import 'package:food_inspector/config/Themes/colors/colorsTheme.dart';

import '../../../config/Routes/RouteName.dart';
import '../../utils/ExitCOnfirmtionWidget.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(context),
          Expanded(
            child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildSectionTitle("Wallets & Earnings"),
              _buildMenuItem(
                context,
                Icons.account_balance_wallet,
                "Wallet Balance",
                // onTap: () => Navigator.pushNamed(context, RouteName.walletScreen),
              ),
              _buildMenuItem(
                context,
                Icons.money,
                "Form 6",
                // onTap: () => Navigator.pushNamed(context, RouteName.earningsScreen),
              ),
              _buildMenuItem(
                context,
                Icons.card_giftcard,
                "Double Dhamaka Bonus",
                // onTap: () => Navigator.pushNamed(context, RouteName.bonusScreen),
              ),
              const Divider(),
              _buildSectionTitle("Others"),
              _buildMenuItem(
                context,
                Icons.library_books,
                "Sample List Records",
                onTap: () => Navigator.pushNamed(context, RouteName.SampleAnalysisScreen),
              ),
              _buildMenuItem(
                context,
                Icons.settings,
                "Settings",
                onTap: () => Navigator.pushNamed(context, RouteName.settingScreen),
              ),
              _buildMenuItem(
                context,
                Icons.support_agent_outlined,
                "Help & Support",
                onTap: () => Navigator.pushNamed(context, RouteName.supportScreen),
              ),
            ],
          ),

    ),
          const Divider(),
          _buildMenuItem(context, Icons.logout, "Logout", onTap: () {
            ExitConfirmation.show(
              context,
              title: "Logout",
              description: "Are you sure you want to Logout?",
              confirmText: "Yes",
              cancelText: "No",
              confirmIcon: Icons.exit_to_app,
              cancelIcon: Icons.cancel_outlined,
            );
          }),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RouteName.profileScreen);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: 70,
          bottom: 40,
          left: 16,
          right: 16,
        ),
        decoration: BoxDecoration(
          color: customColors.primary,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: customColors.white,
              child: Icon(Icons.person, size: 30, color: customColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Rajeev Ranjan",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: customColors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "User ID: 394884",
                    style: TextStyle(fontSize: 13, color: customColors.white70),
                  ),
                ],
              ),
            ),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: customColors.white,
            //     foregroundColor: customColors.primary,
            //     padding: const EdgeInsets.symmetric(horizontal: 12),
            //     minimumSize: const Size(0, 32),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(20),
            //     ),
            //   ),
            //   onPressed: () {},
            //   child: const Text("EDIT", style: TextStyle(fontWeight: FontWeight.bold)),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: customColors.black87,
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context,
      IconData icon,
      String label, {
        Widget? trailing,
        VoidCallback? onTap,
      }) {
    return ListTile(
      leading: Icon(icon, color: customColors.primary),
      title: Text(label, style: const TextStyle(fontSize: 15)),
      trailing: trailing,
      onTap: onTap,
    );
  }



}
