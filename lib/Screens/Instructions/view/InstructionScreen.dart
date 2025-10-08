import 'package:flutter/material.dart';
import 'package:food_inspector/config/Themes/colors/colorsTheme.dart';
import 'dart:async';
import '../../../config/Routes/RouteName.dart';

class InstructionScreen extends StatefulWidget {
  const InstructionScreen({super.key});

  @override
  State<InstructionScreen> createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<InstructionScreen>
    with SingleTickerProviderStateMixin {
  late final PageController _controller;
  int _index = 0;
  Timer? _autoTimer;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = PageController();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);

    _startAutoSlide();
  }

  @override
  void dispose() {
    _controller.dispose();
    _autoTimer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _autoTimer?.cancel();
    _autoTimer = Timer.periodic(const Duration(seconds: 4), (t) {
      if (!mounted) return;
      final total = _pages(context).length;
      if (total <= 1) return;
      final next = (_index + 1) % total;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  void _pauseAutoSlide() {
    _autoTimer?.cancel();
    _autoTimer = null;
  }

  void _resumeAutoSlide() {
    if (_autoTimer == null) {
      _startAutoSlide();
    }
  }

  Widget _tile(
      BuildContext context, {
        required IconData icon,
        required String title,
        String? subtitle,
      }) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
          foregroundColor: theme.colorScheme.primary,
          child: Icon(icon, size: 24),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
        ),
        subtitle:
        subtitle == null ? null : Text(subtitle, style: const TextStyle(height: 1.3)),
      ),
    );
  }

  Widget _section(
      BuildContext context, {
        required String title,
        required IconData sectionIcon,
        required List<Widget> tiles,
      }) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 40,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            child: Icon(sectionIcon, color: theme.colorScheme.primary, size: 40),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 24),
          ...tiles,
        ],
      ),
    );
  }

  List<Widget> _pages(BuildContext context) => [
    _section(
      context,
      title: 'Permissions',
      sectionIcon: Icons.security_outlined,
      tiles: [
        _tile(
          context,
          icon: Icons.language,
          title: 'Language',
          subtitle:
          'Change app language from Settings. English, हिंदी and मराठी are supported.',
        ),
        _tile(
          context,
          icon: Icons.location_on_outlined,
          title: 'Location',
          subtitle: 'Allow location to auto-fill geo information where required.',
        ),
        _tile(
          context,
          icon: Icons.camera_alt_outlined,
          title: 'Camera & Storage',
          subtitle: 'Allow camera and storage for capturing and uploading documents/photos.',
        ),
      ],
    ),
    _section(
      context,
      title: 'Key Features',
      sectionIcon: Icons.star_outline_rounded,
      tiles: [
        _tile(
          context,
          icon: Icons.description_outlined,
          title: 'Form VI',
          subtitle:
          'Fill sections step-by-step. Use Save & Next to proceed and Submit at the end.',
        ),
        _tile(
          context,
          icon: Icons.list_alt_outlined,
          title: 'Sample List',
          subtitle:
          'View, filter and review submitted samples and their statuses.',
        ),
        _tile(
          context,
          icon: Icons.confirmation_number_outlined,
          title: 'Request Slip Number',
          subtitle: 'Request DO slip numbers and check details in Slip Number Info.',
        ),
        _tile(
          context,
          icon: Icons.replay_circle_filled_outlined,
          title: 'Resubmit Sample',
          subtitle: 'If any sample needs resubmission, use the Resubmit option from the menu.',
        ),
      ],
    ),
    _section(
      context,
      title: 'Tips',
      sectionIcon: Icons.lightbulb_outline_rounded,
      tiles: [
        _tile(
          context,
          icon: Icons.wifi_tethering,
          title: 'Connectivity',
          subtitle:
          'Ensure a stable internet connection while submitting forms or uploading files.',
        ),
        _tile(
          context,
          icon: Icons.notifications_active_outlined,
          title: 'Notifications',
          subtitle:
          'Tap notifications to open relevant screens. In-app banners also provide quick actions.',
        ),
        _tile(
          context,
          icon: Icons.logout,
          title: 'Logout',
          subtitle: 'Use the Logout option from the drawer to securely exit your session.',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = _pages(context);
    final isLast = _index == pages.length - 1;

    if (isLast) {
      _fadeController.forward();
    } else {
      _fadeController.reverse();
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: customColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Expanded(
              child: GestureDetector(
                onPanDown: (_) => _pauseAutoSlide(),
                onPanCancel: _resumeAutoSlide,
                onPanEnd: (_) => _resumeAutoSlide(),
                child: PageView(
                  controller: _controller,
                  onPageChanged: (i) => setState(() => _index = i),
                  children: pages,
                ),
              ),
            ),
            FadeTransition(
              opacity: _fadeAnimation,
              child: isLast
                  ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RouteName.SampleAnalysisScreen,
                          (route) => false,
                    );
                  },
                  child: AnimatedScale(
                    scale: isLast ? 1.0 : 0.9,
                    duration: const Duration(milliseconds: 400),
                    child: Container(
                      width: 200,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: LinearGradient(
                          colors: [
                            customColors.primary,
                            customColors.primary.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: customColors.primary.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Continue',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
                  : const SizedBox(height: 80),
            ),
            _buildPageIndicator(pages.length),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final selected = i == _index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 10,
          width: selected ? 26 : 10,
          decoration: BoxDecoration(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(12),
            boxShadow: selected
                ? [
              BoxShadow(
                color:
                Theme.of(context).colorScheme.primary.withOpacity(0.4),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ]
                : [],
          ),
        );
      }),
    );
  }
}
