// edit_sample_dialog.dart
import 'package:flutter/material.dart';
import 'package:food_inspector/config/Themes/colors/colorsTheme.dart';

import '../../../Screens/Sample list/view/SampleList.dart';

class EditSampleDialog extends StatefulWidget {
  final SampleData data;

  const EditSampleDialog({super.key, required this.data});

  @override
  State<EditSampleDialog> createState() => _EditSampleDialogState();
}

class _EditSampleDialogState extends State<EditSampleDialog> {
  bool resendConfirmed = false;
  bool showDateError = false;
  DateTime? selectedDate;
  late TextEditingController labController;
  late String selectedStatus;

  @override
  void initState() {
    super.initState();
    labController = TextEditingController(text: widget.data.labLocation);
    selectedStatus = widget.data.status;
  }

  @override
  void dispose() {
    labController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Edit Sample',
        style: TextStyle(color: customColors.primary, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: Text("Update Sample Status as Resend"),
              value: resendConfirmed,
              activeColor: customColors.primary,
              onChanged: (bool? value) {
                setState(() {
                  resendConfirmed = value ?? false;
                  showDateError = false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            SizedBox(height: 16),
            if (resendConfirmed) ...[
              Text('Update Sample Resent Date'),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    setState(() {
                      selectedDate = picked;
                      showDateError = false;
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate != null
                            ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                            : "Select Resend Date",
                        style: TextStyle(
                          color: selectedDate != null ? Colors.black : Colors.grey,
                        ),
                      ),
                      Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
                    ],
                  ),
                ),
              ),
              if (showDateError)
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, left: 4.0),
                  child: Text(
                    "Please select a resend date",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
        ),
        SizedBox(width: 120),
        ElevatedButton(
          onPressed: () {
            if (resendConfirmed && selectedDate == null) {
              setState(() {
                showDateError = true;
              });
              return;
            }

            print('Resend Confirmed: $resendConfirmed');
            print('Resend Date: ${selectedDate?.toIso8601String() ?? 'Not selected'}');

            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: customColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
