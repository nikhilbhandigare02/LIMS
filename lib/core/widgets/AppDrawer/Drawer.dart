import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_inspector/config/Themes/colors/colorsTheme.dart';

import '../../../Screens/FORM6/bloc/Form6Bloc.dart';
import '../../../Screens/FORM6/repository/form6Repository.dart';
import '../../../Screens/FORM6/view/form6_landing_screen.dart';
import '../../../config/Routes/RouteName.dart';
import '../../utils/ExitCOnfirmtionWidget.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildDrawerHeader(context),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // _buildSectionTitle("Wallets & Earnings"),
                  // _buildMenuItem (
                  //   context,
                  //   Icons.account_balance_wallet,
                  //   "Home",
                  //   onTap: () => Navigator.pushNamed(context, RouteName.homeScreen),
                  // ),
                  _buildMenuItem(
                    context,
                    Icons.money,
                    "Form VI",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => SampleFormBloc(form6repository: Form6Repository()),
                          child: Form6LandingScreen(),
                        ),
                      ),
                    ),



                  ),

                  _buildMenuItem(
                    context,
                    Icons.library_books,
                    "Sample List Records",
                    onTap: () => Navigator.pushNamed(context, RouteName.SampleAnalysisScreen),
                  ),
                  _buildMenuItem(
                    context,
                    Icons.assignment_turned_in,
                    "Request for slip number",
                    onTap: () => Navigator.pushNamed(context, RouteName.requestForSlip),
                  ),
                  _buildMenuItem(
                    context,
                    Icons.info,
                    "  slip number Info",
                    onTap: () => Navigator.pushNamed(context, RouteName.SlipRequestDetailsScreen),
                  ),
                  const Divider(),
                  _buildSectionTitle("Others"),

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
                  _buildMenuItem(
                    context,
                    Icons.info_outline_rounded,
                    "About Us",
                    onTap: () => Navigator.pushNamed(context, RouteName.AboutUsScreen),
                  ),
                ],
              ),
            ),
            const Divider(),
            _buildMenuItem(context, Icons.logout, "Logout", onTap: () async {
              final bool confirmed = await showDialog<bool>(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    // Set the dialog's shape to a square
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.zero),
                    ),
                    // Set the dialog's background color to white
                    backgroundColor: Colors.white,

                    title: const Text("Logout"),
                    content: const Text("Are you sure you want to Logout?"),
                    actions: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            icon: const Icon(Icons.cancel_outlined, color: Colors.blue), // Icon for "No"
                            label: const Text(
                              "No",
                              style: TextStyle(color: Colors.blue),
                            ),
                            onPressed: () {
                              Navigator.of(dialogContext).pop(false);
                            },
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.zero),
                              ),
                            ),
                            icon: const Icon(Icons.exit_to_app, color: Colors.white), // Icon for "Logout"
                            label: const Text(
                              "Logout",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.of(dialogContext).pop(true);
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ) ?? false;

              if (confirmed) {
                // Set login flag = 0 on logout
                const storage = FlutterSecureStorage();
                await storage.write(key: 'isLogin', value: '0');
                // Navigate to login screen and clear navigation history
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteName.loginScreen,
                      (Route<dynamic> route) => false,
                );
              }
            }),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    Future<Map<String, String>> loadUserHeader() async {
      try {
        const storage = FlutterSecureStorage();
        final String? jsonString = await storage.read(key: 'loginData');
        if (jsonString == null || jsonString.isEmpty) {
          return {
            'name': 'User',
            'subtitle': '',
          };
        }
        final Map<String, dynamic> data = jsonDecode(jsonString) as Map<String, dynamic>;
        String? name;
        for (final k in ['fullName', 'FullName', 'name', 'Name', 'username', 'Username']) {
          final v = data[k];
          if (v != null && v.toString().trim().isNotEmpty) {
            name = v.toString().trim();
            break;
          }
        }
        String subtitle = '';
        final userId = data['userId'] ?? data['UserId'] ?? data['user_id'];
        final username = data['username'] ?? data['Username'];
        final email = data['email'] ?? data['Email'];
        if (userId != null && userId.toString().trim().isNotEmpty) {
          subtitle = 'User ID: ${userId.toString()}';
        } else if (username != null && username.toString().trim().isNotEmpty) {
          subtitle = 'Username: ${username.toString()}';
        } else if (email != null && email.toString().trim().isNotEmpty) {
          subtitle = email.toString();
        }
        return {
          'name': name ?? 'User',
          'subtitle': 'Food Safety Officer',
        };
      } catch (_) {
        return {
          'name': 'User',
          'subtitle': '',
        };
      }
    }

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
              child: FutureBuilder<Map<String, String>>(
                future: loadUserHeader(),
                builder: (context, snapshot) {
                  final name = snapshot.hasData ? (snapshot.data!['name'] ?? 'User') : 'User';
                  final subtitle = snapshot.hasData ? (snapshot.data!['subtitle'] ?? '') : '';
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: customColors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (subtitle.isNotEmpty)
                        Text(
                          subtitle,
                          style: const TextStyle(fontSize: 13, color: customColors.white70),
                        ),
                    ],
                  );
                },
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
