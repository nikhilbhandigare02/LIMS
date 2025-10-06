import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:food_inspector/config/Themes/colors/colorsTheme.dart';

import '../../../config/Routes/RouteName.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key, this.onContinue});
  final VoidCallback? onContinue;

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionItem {
  _PermissionItem({
    required this.title,
    required this.icon,
    required this.permission,
    this.requiredOnPlatform = true,
  });

  final String title;
  final IconData icon;
  final Permission permission;
  final bool requiredOnPlatform;
  PermissionStatus status = PermissionStatus.denied;
}

class _PermissionScreenState extends State<PermissionScreen> {
  late List<_PermissionItem> _items;
  bool _loading = true;
  bool _requesting = false;

  @override
  void initState() {
    super.initState();
    _items = _buildPermissionListForPlatform();
    _refreshStatuses();
  }

  List<_PermissionItem> _buildPermissionListForPlatform() {
    final isAndroid = Platform.isAndroid;
    final isIOS = Platform.isIOS;

    return [
      _PermissionItem(
        title: 'Location',
        icon: Icons.location_on_rounded,
        permission: Permission.locationWhenInUse,
      ),
      _PermissionItem(
        title: 'Camera',
        icon: Icons.photo_camera_rounded,
        permission: Permission.camera,
      ),
      _PermissionItem(
        title: isIOS ? 'Photos' : 'Storage',
        icon: isIOS ? Icons.photo_rounded : Icons.folder_rounded,
        permission: isIOS ? Permission.photos : Permission.storage,
      ),
      _PermissionItem(
        title: 'Notifications',
        icon: Icons.notifications_active_rounded,
        permission: Permission.notification,
      ),
    ];
  }

  Future<void> _refreshStatuses() async {
    setState(() => _loading = true);
    for (final item in _items) {
      item.status = await item.permission.status;
    }
    setState(() => _loading = false);
  }

  bool get _allGranted => _items.every((e) => e.status.isGranted);
  bool get _anyPermanentlyDenied =>
      _items.any((e) => e.status.isPermanentlyDenied || e.status.isRestricted);

  Future<void> _requestAll() async {
    if (_requesting) return;
    setState(() => _requesting = true);

    for (final item in _items) {
      if (item.status.isGranted ||
          item.status.isPermanentlyDenied ||
          item.status.isRestricted) continue;
      item.status = await item.permission.request();
    }

    setState(() => _requesting = false);

    if (_anyPermanentlyDenied && context.mounted) {
      await _openAppSettings();
    }

    setState(() {});
  }

  Future<void> _openAppSettings() async {
    await openAppSettings();
    await _refreshStatuses();
  }

  Future<void> _requestSingle(int index) async {
    final item = _items[index];
    if (item.status.isGranted ||
        item.status.isPermanentlyDenied ||
        item.status.isRestricted) {
      if (item.status.isPermanentlyDenied || item.status.isRestricted) {
        await _openAppSettings();
      }
      return;
    }
    final result = await item.permission.request();
    setState(() => item.status = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customColors.white,
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            // Scrollable content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshStatuses,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _screenHeader(),
                      const SizedBox(height: 20),
                      ...List.generate(
                        _items.length,
                            (i) => _permissionTile(i),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),

            // Sticky bottom section
            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.black.withOpacity(0.05),
              //       offset: const Offset(0, -2),
              //       blurRadius: 6,
              //     ),
              //   ],
              // ),
              child: _actionButtons(),
            ),
          ],
        ),
      ),
    );
  }


  Widget _screenHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.lock_outline_rounded,
            size: 40,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "To continue, we need access to some features",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          "We’ll use these permissions to provide better functionality — "
              "like scanning documents, detecting location, sending alerts, "
              "and letting you upload photos. You can change this anytime "
              "from your device settings.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.4),
        ),
      ],
    );
  }

  Widget _permissionTile(int index) {
    final item = _items[index];
    final status = item.status;

    Color chipColor;
    String chipLabel;
    Color chipTextColor;

    if (status.isGranted) {
      chipColor = Colors.green.shade100;
      chipLabel = 'Granted';
      chipTextColor = Colors.green.shade800;
    } else if (status.isPermanentlyDenied || status.isRestricted) {
      chipColor = Colors.red.shade100;
      chipLabel = 'Denied';
      chipTextColor = Colors.red.shade800;
    } else {
      chipColor = Colors.grey.shade200;
      chipLabel = 'Pending';
      chipTextColor = Colors.grey.shade700;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.blue.shade50,
          child: Icon(item.icon, color: Colors.blueAccent, size: 18),
        ),
        title: Text(
          item.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontSize: 16,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: chipColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                chipLabel,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: chipTextColor,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: status.isGranted
                  ? 'Granted'
                  : (status.isPermanentlyDenied || status.isRestricted)
                  ? 'Settings'
                  : 'Grant',
              icon: Icon(
                status.isGranted
                    ? Icons.check_circle
                    : (status.isPermanentlyDenied || status.isRestricted)
                    ? Icons.settings
                    : Icons.arrow_forward_ios_rounded,
                color: status.isGranted
                    ? Colors.green
                    : (status.isPermanentlyDenied || status.isRestricted)
                    ? Colors.red
                    : Colors.blueAccent,
              ),
              onPressed: () async {
                if (status.isPermanentlyDenied || status.isRestricted) {
                  await _openAppSettings();
                } else if (!status.isGranted) {
                  await _requestSingle(index);
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _actionButtons() {
    final _secureStorage = const FlutterSecureStorage();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Allow All button
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: customColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          onPressed: _requesting ? null : _requestAll,
          icon: _requesting
              ? const SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : Icon(Icons.verified_user, color: customColors.white),
          label: Text(
            _requesting ? 'Requesting...' : 'Allow All',
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),

        if (_allGranted)
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: customColors.primary,
              padding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () async {
              await _secureStorage.write(key: 'permissionGranted', value: '1');

              if (!mounted) return;

              // Remove widget.onContinue?.call(); if it triggers other navigation
              Navigator.of(context, rootNavigator: true)
                  .pushReplacementNamed(RouteName.SampleAnalysisScreen);
            },
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 18,
            ),
            label: const Text(
              'Continue',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
      ],
    );
  }
}
