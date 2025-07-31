// view_sample_dialog.dart
import 'package:flutter/material.dart';
import 'package:food_inspector/config/Themes/colors/colorsTheme.dart';

import '../../../Screens/Sample list/view/SampleList.dart';

class ViewSampleDialog extends StatelessWidget {
  final SampleData data;

  const ViewSampleDialog({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Sample Details',
        style: TextStyle(color: customColors.primary, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Serial No:', data.serialNo),
          _buildDetailRow('Status:', data.status),
          _buildDetailRow('Lab Location:', data.labLocation),
          _buildDetailRow('Requested Date:', data.sampleRequestedDate),
          _buildDetailRow('Sent Date:', data.sampleSentDate),
          _buildDetailRow('Resent Date:', data.sampleResentDate),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Close', style: TextStyle(color: customColors.primary)),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
