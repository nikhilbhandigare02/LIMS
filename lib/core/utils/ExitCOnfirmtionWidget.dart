import 'package:flutter/material.dart';

class ExitConfirmation extends StatelessWidget {
  final String title;
  final String description;
  final String confirmText;
  final String cancelText;
  final IconData confirmIcon;
  final IconData cancelIcon;

  const ExitConfirmation({
    super.key,
    required this.title,
    required this.description,
    this.confirmText = "Yes",
    this.cancelText = "Cancel",
    this.confirmIcon = Icons.check_circle,
    this.cancelIcon = Icons.cancel,
  });

  /// Static method to show the dialog and return true/false
  static Future<bool> show(
      BuildContext context, {
        required String title,
        required String description,
        String confirmText = "Yes",
        String cancelText = "Cancel",
        IconData confirmIcon = Icons.check_circle,
        IconData cancelIcon = Icons.cancel,
      }) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ExitConfirmation(
        title: title,
        description: description,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmIcon: confirmIcon,
        cancelIcon: cancelIcon,
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: Text(description),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDialogButton(context, cancelText, cancelIcon, false),
            _buildDialogButton(context, confirmText, confirmIcon, true),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDialogButton(
      BuildContext context, String label, IconData icon, bool result) {
    return Container(
      width: 110,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextButton.icon(
        onPressed: () => Navigator.of(context).pop(result),
        icon: Icon(icon, size: 18, color: Colors.black),
        label: Text(label, style: const TextStyle(color: Colors.black)),
      ),
    );
  }
}
