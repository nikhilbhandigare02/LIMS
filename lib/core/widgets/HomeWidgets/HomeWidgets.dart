import 'package:flutter/material.dart';

import '../../utils/validators.dart';

class BlocTextInput extends StatelessWidget {
  final String label;
  final String initialValue;
  final ValueChanged<String> onChanged;

  const BlocTextInput({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      initialValue: initialValue,
      onChanged: onChanged,
      validator: (value) => Validators.validateEmptyField(value, label),
    );
  }
}

class BlocDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final void Function(String?) onChanged;

  const BlocDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value != null && items.contains(value) ? value : null,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      hint: Text('Select $label'),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      validator: (val) =>
          val == null || val.isEmpty ? '$label is required' : null,
    );
  }
}

class BlocDatePicker extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onChanged;

  const BlocDatePicker({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      initialValue: selectedDate,
      validator: (value) => value == null ? '$label is required' : null,
      builder: (field) {
        return InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              onChanged(picked);
              field.didChange(picked); // update FormField state
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              errorText: field.errorText,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
            child: Text(
              field.value != null
                  ? "${field.value!.day}-${field.value!.month}-${field.value!.year}"
                  : "Select Date",
              style: const TextStyle(fontSize: 14),
            ),
          ),
        );
      },
    );
  }
}

class BlocYesNoRadio extends StatelessWidget {
  final String label;
  final bool? value;
  final ValueChanged<bool> onChanged;

  const BlocYesNoRadio({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      validator: (val) => value == null ? '$label is required' : null,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 14)),
            Row(
              children: [
                Row(
                  children: [
                    Radio<bool>(
                      visualDensity: VisualDensity.compact,
                      value: true,
                      groupValue: value,
                      onChanged: (val) {
                        onChanged(val!);
                        field.didChange(val);
                      },
                    ),
                    const Text("Yes", style: TextStyle(fontSize: 14)),
                  ],
                ),
                  SizedBox(width: 100,),
                Row(
                  children: [
                    Radio<bool>(
                      visualDensity: VisualDensity.compact,
                      value: false,
                      groupValue: value,
                      onChanged: (val) {
                        onChanged(val!);
                        field.didChange(val);
                      },
                    ),
                    const Text("No", style: TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  field.errorText ?? '',
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}
