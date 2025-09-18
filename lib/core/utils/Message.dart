// message.dart
import 'package:flutter/material.dart';
import '../../config/Themes/colors/colorsTheme.dart';
import 'enums.dart'; // your MessageType enum

class Message {
  /// Toast-like overlay in top-right
  static void showTopRightOverlay(
      BuildContext context,
      String message,
      MessageType type, {
        String? title,
      }) {
    final overlayState = Overlay.of(context);
    if (overlayState == null) return;

    final overlayEntry = OverlayEntry(
      builder: (context) => _OverlayMessage(
        message: message,
        type: type,
        title: title,
      ),
    );

    overlayState.insert(overlayEntry);

    // remove after a while (safe check)
    Future.delayed(const Duration(seconds: 3), () {
      try {
        if (overlayEntry.mounted) overlayEntry.remove();
      } catch (_) {}
    });
  }

  /// Modal popup dialog with OK button (blocking)
  static Future<void> showPopup(
      BuildContext context, {
        required String message,
        required MessageType type,
        String? title,
        bool barrierDismissible = false, // force user to press OK by default
        VoidCallback? onOk,
      }) {
    final color = getColor(type);
    final icon = getIcon(type);

    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title ?? type.name.toUpperCase(),
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          content: Text(message, textAlign: TextAlign.center), // optional center text
          actionsAlignment: MainAxisAlignment.center, // 👈 this centers actions
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                if (onOk != null) onOk();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  static IconData getIcon(MessageType type) {
    switch (type) {
      case MessageType.success:
        return Icons.check_circle;
      case MessageType.error:
        return Icons.error;
      case MessageType.network:
        return Icons.wifi_off;
      case MessageType.info:
      default:
        return Icons.info;
    }
  }

  static Color getColor(MessageType type) {
    switch (type) {
      case MessageType.success:
        return Colors.green;
      case MessageType.error:
        return Colors.red;
      case MessageType.network:
        return Colors.orange;
      case MessageType.info:
      default:
        return Colors.blue;
    }
  }
}

/// Private overlay message widget (kept in same file so it remains accessible)
class _OverlayMessage extends StatefulWidget {
  final String message;
  final String? title;
  final MessageType type;

  const _OverlayMessage({
    Key? key,
    required this.message,
    required this.type,
    this.title,
  }) : super(key: key);

  @override
  State<_OverlayMessage> createState() => _OverlayMessageState();
}

class _OverlayMessageState extends State<_OverlayMessage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();

    // auto-reverse after 2s (visual); actual removal is handled by caller
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Message.getColor(widget.type);
    final icon = Message.getIcon(widget.type);

    return Positioned(
      top: 60,
      right: 20,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Side colored bar
                    Container(
                      width: 6,
                      height: 64,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                    ),

                    // content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Icon(icon, color: color, size: 20),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    widget.title ?? widget.type.name.toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.message,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Close button
                    IconButton(
                      onPressed: () {
                        if (mounted) {
                          _controller.reverse();
                        }
                      },
                      icon: const Icon(Icons.close, size: 18),
                      color: Colors.black54,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppDialog {
  static bool _isDialogOpen = false;

  /// Show popup dialog (handles info/loading, success, error, etc.)
  static Future<void> show(
      BuildContext context,
      String message,
      MessageType type, {
        String? title,
        VoidCallback? onOk,
      }) async {
    if (_isDialogOpen) return; // prevent stacking dialogs
    _isDialogOpen = true;

    final color = getColor(type);
    final icon = getIcon(type);

    if (type == MessageType.info) {
      // Loading dialog (no OK button)
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: Row(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(message),
                ),
              ],
            ),
          );
        },
      ).whenComplete(() {
        _isDialogOpen = false;
      });
    } else {
      // Success / Error / Other popups (with OK button)
      await showDialog<void>(
        context: context,
        barrierDismissible: false, // cannot close by tapping outside
        builder: (ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title ?? type.name.toUpperCase(),
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            content: Text(message),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: customColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop(); // close on OK
                  if (onOk != null) onOk();
                },
                child: Text(
                  "OK",
                  style: TextStyle(
                    color: customColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          );
        },
      ).whenComplete(() {
        _isDialogOpen = false;
      });
    }
  }

  /// Close popup manually (useful for closing loading popup)
  static void closePopup(BuildContext context) {
    if (_isDialogOpen) {
      Navigator.of(context, rootNavigator: true).pop();
      _isDialogOpen = false;
    }
  }

  /// Icons
  static IconData getIcon(MessageType type) {
    switch (type) {
      case MessageType.success:
        return Icons.check_circle;
      case MessageType.error:
        return Icons.error;
      case MessageType.network:
        return Icons.wifi_off;
      case MessageType.info:
      default:
        return Icons.info;
    }
  }

  /// Colors
  static Color getColor(MessageType type) {
    switch (type) {
      case MessageType.success:
        return Colors.green;
      case MessageType.error:
        return Colors.red;
      case MessageType.network:
        return Colors.orange;
      case MessageType.info:
      default:
        return Colors.blue;
    }
  }
}
