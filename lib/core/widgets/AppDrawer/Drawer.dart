import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_inspector/config/Themes/colors/colorsTheme.dart';


// For showing resubmit notifications count when available
import '../../../core/utils/enums.dart';
import '../../../Screens/ResubmitSample/bloc/resubmit_bloc.dart';
import '../../../Screens/ResubmitSample/repository/resubmit_repository.dart';

import '../../../Screens/FORM6/bloc/Form6Bloc.dart';
import '../../../Screens/FORM6/repository/form6Repository.dart';
import '../../../Screens/FORM6/view/form6_landing_screen.dart';
import '../../../config/Routes/RouteName.dart';
import '../../../l10n/app_localizations.dart';
import '../../utils/ExitCOnfirmtionWidget.dart';
import '../../utils/Message.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

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
                    Icons.assignment_turned_in,
                    AppLocalizations.of(context)!.menuRequestSlipNumber,
                    onTap: () => Navigator.pushNamed(context, RouteName.requestForSlip),
                  ),
                  _buildMenuItem(
                    context,
                    Icons.info,
                    AppLocalizations.of(context)!.menuSlipNumberInfo,
                    onTap: () => Navigator.pushNamed(context, RouteName.SlipRequestDetailsScreen),
                  ),
                  _buildMenuItem(
                    context,
                    Icons.money,
                    AppLocalizations.of(context)!.menuFormVI,
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
                    AppLocalizations.of(context)!.menuSampleListRecords,
                    onTap: () => Navigator.pushNamed(context, RouteName.SampleAnalysisScreen),
                  ),


                  _buildMenuItem(
                    context,
                    Icons.replay_circle_filled,
                    AppLocalizations.of(context)!.menuRequestNewSample,
                    trailing: _resubmitBellBadge(context),
                    onTap: () => Navigator.pushNamed(context, RouteName.ResubmitSample),
                  ),
                  const Divider(),
                  _buildSectionTitle(AppLocalizations.of(context)!.menuOthers),

                  _buildMenuItem(
                    context,
                    Icons.settings,
                    AppLocalizations.of(context)!.menuSettings,
                    onTap: () => Navigator.pushNamed(context, RouteName.settingScreen),
                  ),
                  // _buildMenuItem(
                  //   context,
                  //   Icons.menu_book_outlined,
                  //   'Instructions',
                  //   onTap: () => Navigator.pushNamed(context, RouteName.instructionScreen),
                  // ),
                  _buildMenuItem(
                    context,
                    Icons.support_agent_outlined,
                    AppLocalizations.of(context)!.menuHelpSupport,
                    onTap: () => Navigator.pushNamed(context, RouteName.supportScreen),
                  ),
                  _buildMenuItem(
                    context,
                    Icons.info_outline_rounded,
                    AppLocalizations.of(context)!.menuAboutUs,
                    onTap: () => Navigator.pushNamed(context, RouteName.AboutUsScreen),
                  ),
                ],
              ),
            ),
            const Divider(),
          _buildMenuItem(context, Icons.logout, AppLocalizations.of(context)!.menuLogout, onTap: () async {
            final confirmed = await ConfirmDialog.show(
              context,
              title: AppLocalizations.of(context)!.logoutTitle,
              message: AppLocalizations.of(context)!.logoutMessage,
              confirmText: AppLocalizations.of(context)!.logoutConfirm,
              confirmColor: Colors.red,
              icon: Icons.logout,
            );

            if (confirmed) {
              const storage = FlutterSecureStorage();
              await storage.write(key: 'isLogin', value: '0');
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
            'name': AppLocalizations.of(context)!.userFallback,
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
          'name': name ?? AppLocalizations.of(context)!.userFallback,
          'subtitle': AppLocalizations.of(context)!.designationFoodSafetyOfficer,
        };
      } catch (_) {
        return {
          'name': AppLocalizations.of(context)!.userFallback,
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
                  final name = snapshot.hasData ? (snapshot.data!['name'] ?? AppLocalizations.of(context)!.userFallback) : AppLocalizations.of(context)!.userFallback;
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

  // Builds a bell icon with a small badge that shows the number of
  // available resubmit items. If ResubmitBloc is not available in the
  // widget tree, nothing is shown.
  Widget _resubmitBellBadge(BuildContext context) {
    // If a ResubmitBloc already exists above us, reuse it.
    try {
      final existing = BlocProvider.of<ResubmitBloc>(context);
      return BlocBuilder<ResubmitBloc, ResubmitState>(
        bloc: existing,
        buildWhen: (prev, curr) => prev.fetchList != curr.fetchList,
        builder: (context, state) {
          if (state.fetchList.status == Status.loading) {
            return const SizedBox.shrink();
          }
          int count = 0;
          final data = state.fetchList.data;
          if (data is List) {
            count = data.length;
          }
          if (count <= 0) return const SizedBox.shrink();
          return _bellWithBadge(count);
        },
      );
    } catch (_) {
      // No existing bloc: create a local one to fetch count when drawer builds.
      return BlocProvider<ResubmitBloc>(
        create: (_) {
          final b = ResubmitBloc(repository: ResubmitRepository());
          b.add(const FetchApprovedSamplesByUser());
          return b;
        },
        child: BlocBuilder<ResubmitBloc, ResubmitState>(
          buildWhen: (prev, curr) => prev.fetchList != curr.fetchList,
          builder: (context, state) {
            if (state.fetchList.status == Status.loading) {
              return const SizedBox.shrink();
            }
            int count = 0;
            final data = state.fetchList.data;
            if (data is List) {
              count = data.length;
            }
            if (count <= 0) return const SizedBox.shrink();
            return _bellWithBadge(count);
          },
        ),
      );
    }
  }

  Widget _bellWithBadge(int count) {
    final String text = count > 99 ? '99+' : count.toString();
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.notifications_none, color: customColors.primary),
        Positioned(
          right: -2,
          top: -2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

}
