import 'package:flutter/material.dart';
import '../../../config/Themes/colors/colorsTheme.dart';
import '../../utils/validators.dart';

BoxDecoration fieldBoxDecoration = BoxDecoration(

color: customColors.white,
borderRadius: BorderRadius.circular(5),

boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 12,
      offset: const Offset(0, 3),
    ),
  ],
);



class BlocTextInput extends StatefulWidget {
  final String label;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final IconData? icon;

  const BlocTextInput({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.icon,
  });

  @override
  State<BlocTextInput> createState() => _BlocTextInputState();
}

class _BlocTextInputState extends State<BlocTextInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant BlocTextInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: 'Enter ${widget.label}',
        prefixIcon:
        widget.icon != null ? Icon(widget.icon, color: customColors.primary) : null,
        filled: true,
        fillColor: customColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: customColors.greyDivider),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class BlocDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final void Function(String?) onChanged;
  final IconData? icon;


  const BlocDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value != null && items.contains(value) ? value : null,
      decoration: InputDecoration(
        hintText: 'Select $label',
        hintStyle: const TextStyle(fontSize: 16),
        prefixIcon: icon != null ? Icon(icon, color: customColors.primary) : null,
        filled: true,
        fillColor: customColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: customColors.greyDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: customColors.primary, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: customColors.greyDivider),
        ),
      ),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
      validator: (val) => val == null || val.isEmpty ? '$label is required' : null,
    );
  }
}

class BlocDatePicker extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onChanged;
  final IconData? icon;

  const BlocDatePicker({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onChanged(picked); // Trigger BLoC event
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Select Date',
          prefixIcon: icon != null
              ? Icon(icon, color: customColors.primary)
              : null,
          filled: true,
          fillColor: customColors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: customColors.greyDivider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: customColors.primary, width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: customColors.greyDivider),
          ),
        ),
        child: Text(
          selectedDate != null
              ? "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}"
              : "Select Date",
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}

class BlocYesNoRadio extends StatelessWidget {
  final String label;
  final bool? value; // can be true, false, or null
  final ValueChanged<bool> onChanged;
  final IconData? icon;

  const BlocYesNoRadio({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: customColors.white,
        border: Border.all(color: customColors.greyDivider),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null)
                Icon(
                  icon,
                  color: value != null ? customColors.primary : customColors.primary,
                ),
              if (icon != null) const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                softWrap: true,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Radio<bool>(
                value: true,
                groupValue: value,
                visualDensity: VisualDensity.compact,
                onChanged: (val) {
                  if (val != null) onChanged(val);
                },
              ),
              const Text("Yes", style: TextStyle(fontSize: 14)),
              const SizedBox(width: 100),
              Radio<bool>(
                value: false,
                groupValue: value,
                visualDensity: VisualDensity.compact,
                onChanged: (val) {
                  if (val != null) onChanged(val);
                },
              ),
              const Text("No", style: TextStyle(fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}

