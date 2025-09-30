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

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        final color = getColor(type);
        final icon = getIcon(type);

        // 👇 keyboard height
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

        return Positioned(
          left: 16,
          right: 16,
          bottom: keyboardHeight + 16, // 👈 stay above keyboard if open
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: color, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (overlayEntry.mounted) overlayEntry.remove();
                    },
                    child: const Icon(Icons.close, size: 18, color: Colors.grey),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );

    overlayState.insert(overlayEntry);

    // Auto remove after 3 sec
    Future.delayed(const Duration(seconds: 3), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }



  static Future<void> showPopup(
      BuildContext context, {
        required String message,
        required MessageType type,
        String? title,
        bool barrierDismissible = false,
        VoidCallback? onOk,
      }) {
    final color = getColor(type);
    final icon = getIcon(type);

    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 32,
                  ),
                ),

                const SizedBox(height: 16),

                // Title
                Text(
                  title ?? type.name.toUpperCase(),
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                // Message
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey.shade700,
                        side: BorderSide(color: Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        if (onOk != null) onOk();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "OK",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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

// import 'package:flutter/material.dart';
//
// enum MessageType { success, error, network, info }

class AppDialog {
  static bool _isDialogOpen = false;

  static Future<void> show(
      BuildContext context,
      String message,
      MessageType type, {
        String? title,
        String? serialNumber,
        VoidCallback? onOk,
      }) async {
    if (_isDialogOpen) return;
    _isDialogOpen = true;

    final color = _getColor(type);
    final icon = _getIcon(type);

    // Build message with serial number (bold inline)
    final formattedMessage = RichText(
      text: TextSpan(
        text: message,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
          height: 1.4,
        ),
        children: serialNumber != null
            ? [
          const TextSpan(text: "\n\nSerial Number: ",
              style: TextStyle(color: Colors.grey)),
          TextSpan(
            text: serialNumber,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ]
            : [],
      ),
    );

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.all(16),
          title: type == MessageType.info
              ? null
              : Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 10),
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
          content: type == MessageType.info
              ? Row(
            children: [
              SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: formattedMessage),
            ],
          )
              : formattedMessage,
          actions: type == MessageType.info
              ? null
              : [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  if (onOk != null) onOk();
                },
                child: const Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ).whenComplete(() => _isDialogOpen = false);
  }

  static void closePopup(BuildContext context) {
    if (_isDialogOpen) {
      Navigator.of(context, rootNavigator: true).pop();
      _isDialogOpen = false;
    }
  }

  static IconData _getIcon(MessageType type) {
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

  static Color _getColor(MessageType type) {
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


class ConfirmDialog {
  static Future<bool> show(
      BuildContext context, {
        required String title,
        required String message,
        String cancelText = "Cancel",
        String confirmText = "OK",
        IconData? icon,
        Color confirmColor = Colors.blue,
      }) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          backgroundColor: Colors.white,
          title: Row(
            children: [
              if (icon != null)
                Icon(icon, color: confirmColor, size: 22),
              if (icon != null) const SizedBox(width: 8),
              Text(title,),
            ],
          ),
          content: Text(message, style: TextStyle(fontSize: 18),),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.cancel_outlined, color: Colors.blue),
                  label: Text(cancelText, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: confirmColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                  ),
                  icon: const Icon(Icons.exit_to_app, color: Colors.white),
                  label: Text(confirmText,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                ),
              ],
            )
          ],
        );
      },
    ) ??
        false;
  }
}

