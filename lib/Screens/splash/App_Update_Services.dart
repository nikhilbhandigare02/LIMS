// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../config/Routes/RouteName.dart';
// import 'model/UpdateAppModel.dart';
// import 'repository/UpdateAppRepository.dart';
//
// class AppUpdateService {
//   static Future<void> checkUpdate(BuildContext context) async {
//     try {
//       final packageInfo = await PackageInfo.fromPlatform();
//       final currentVersionCode = int.parse(packageInfo.buildNumber);
//
//       final repo = UpdateAppRepository();
//       final UpdateAppModel latest = await repo.fetchUpdateInfo();
//
//       if ((latest.success ?? false) && latest.versionCode != null) {
//         if ((latest.versionCode ?? 0) > currentVersionCode) {
//           _showUpdateDialog(context, latest);
//         } else {
//           Navigator.pushNamedAndRemoveUntil(
//               context, RouteName.loginScreen, (route) => false);
//         }
//       } else {
//         debugPrint('Update API message: ${latest.message}');
//         Navigator.pushNamedAndRemoveUntil(
//             context, RouteName.loginScreen, (route) => false);
//       }
//     } catch (e) {
//       print('Error checking update: $e');
//       Navigator.pushNamedAndRemoveUntil(
//           context, RouteName.loginScreen, (route) => false);
//     }
//   }
//
//   static void _showUpdateDialog(BuildContext context, UpdateAppModel update) {
//     final bool mandatory = update.isMandatory ?? false;
//     showDialog(
//       barrierDismissible: !mandatory,
//       context: context,
//       builder: (_) {
//         return WillPopScope(
//           onWillPop: () async => !mandatory,
//           child: AlertDialog(
//             title: Text(update.updateTitle ?? "Update Available"),
//             content: Text(update.updateDescription ?? ""),
//             actions: [
//               if (!mandatory)
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                     Navigator.pushNamedAndRemoveUntil(
//                         context, RouteName.loginScreen, (route) => false);
//                   },
//                   child: const Text("Later"),
//                 ),
//               ElevatedButton(
//                 onPressed: () async {
//                   final url = update.downloadUrl;
//                   if (url != null && await canLaunchUrl(Uri.parse(url))) {
//                     await launchUrl(
//                       Uri.parse(url),
//                       mode: LaunchMode.externalApplication,
//                     );
//                   }
//                   if (!mandatory) Navigator.pop(context);
//                 },
//                 child: const Text("Update"),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
