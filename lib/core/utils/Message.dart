import 'package:flutter/material.dart';
import 'enums.dart';

class Message {
  static void showTopRightOverlay(
      BuildContext context, String message, MessageType type,
      {String? title}) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => _OverlayMessage(
        message: message,
        type: type,
        title: title,
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3))
        .then((_) => overlayEntry.remove());
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
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(1.0, 0), end: Offset.zero).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOut),
        );

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();

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
              constraints: const BoxConstraints(maxWidth: 280),
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
                  children: [
                    // Side colored bar
                    Container(
                      width: 6,
                      height: 60,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(icon, color: color, size: 20),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    widget.title ??
                                        widget.type.name.toUpperCase(),
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
